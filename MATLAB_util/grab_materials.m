mat_map  = [[50  1 51  3 52  5 53  6 99];
 [ 1  7  8  9  1 54 10 11 99];
 [51  8 51  1  2  5 53 12 99];
 [ 3  9  1 13  1 55 15 14 99];
 [52  1  2  1 56	 3 57 99 99];
 [ 5 54  5 55  3	15  8 99 99];
 [53 10 53 15 57  8 99 99 99];
 [ 6 11 12 14 99	99 99 99 99];
 [99 99 99 99 99 99 99 99 99]];

ids = [1 2 3 5 6 7 8 9 10 11 12 13 14 15 50 51 52 53 54 55 56 57 99];
names = {'u42_0015','u42_2250','u45_0015','m43_1750','u42_3250','u42_1750','u45_3250','m40_2250','m40_0015','u45_1750','m43_3500','m40_3750','u45_2000','m43_0015','u42_3500_rodded','u42_2250_rodded','u45_3750_rodded','u45_0015_rodded','u42_3250_rodded','u45_2000_rodded','u42_3750_rodded','u42_1750_rodded','reflector'};

out111 = print_MOOSE_materials(ids,names,mat_map,2,G2_111)
out123 = print_MOOSE_materials(ids,names,mat_map,2,G2_123)
out222 = print_MOOSE_materials(ids,names,mat_map,2,G2_222)
out321 = print_MOOSE_materials(ids,names,mat_map,2,G2_321)
out333 = print_MOOSE_materials(ids,names,mat_map,2,G2_333)

function screen_out = print_MOOSE_materials(ids,names,mat_map,n_groups,gdir)
    screen_out = [''];
    for i = 1:length(ids)

        new_entry = grab_material_data(ids(i),mat_map,n_groups,gdir);
        screen_out = append(screen_out,['[',names{i},']',newline,new_entry,newline,'[]',newline]);

    end
end


function printed = grab_material_data(id,mat_map,n_groups,gdir)

    md = struct();
    
    [ix,iy] = find(mat_map==id,1);
    
    md.diffusivity = zeros(n_groups,1);
    md.sigma_t = zeros(n_groups,1);
    md.nu_sigma_f = zeros(n_groups,1);
    md.chi = zeros(n_groups,1);
    md.kappa_fission = zeros(n_groups,1);
    md.adf = zeros(n_groups,1);
    md.sigma_s = zeros(n_groups,n_groups);
    
    
    for k = 1:n_groups
        
        md.diffusivity(k)   = gdir{k}.diffCoeff(ix,iy);
        md.sigma_t(k)       = gdir{k}.sigA(ix,iy);
        md.nu_sigma_f(k)    = gdir{k}.sigF(ix,iy);
        md.chi(k)           = gdir{k}.chi;
        md.kappa_fission(k) = gdir{k}.kapfission(ix,iy);
        md.adf(k)           = gdir{k}.discFactors(ix,iy,1);
        for j = 1:n_groups
            md.sigma_s(k,j) = gdir{j}.sigS{k}(ix,iy);
        end
        md.sigma_t(k) = md.sigma_t(k) + md.sigma_s(k,k);
    end
    
    diffString      = sprintf(' %d ',md.diffusivity(:));
    sigtString      = sprintf(' %d ',md.sigma_t(:));
    nusigfString    = sprintf(' %d ',md.nu_sigma_f(:));
    chiString       = sprintf(' %d ',md.chi(:));
    kapfissString   = sprintf(' %d ',md.kappa_fission(:));
    adfString       = sprintf(' %d ',md.adf(:));
    idString        = sprintf(' %d ',id);
    
    scatterStrings  = cell(n_groups,1);
    for i = 1:n_groups
        scatterStrings{i} = sprintf(' %d ',md.sigma_s(i,:));
    end
    
    a = ['type = MultigroupXSMaterial'];
    a = append(a,[newline,'diffusivity = "',diffString,'"']);
    a = append(a,[newline,'sigma_t = "',sigtString,'"']);
    a = append(a,[newline,'nu_sigma_f = "',nusigfString,'"']);
    a = append(a,[newline,'chi = "',chiString,'"']);
    a = append(a,[newline,'kappa_sigma_f = "',kapfissString,'"']);
    a = append(a,[newline,'adf = "',adfString,'"']);
    a = append(a,[newline,'sigma_s = "',scatterStrings{1},';']);
    for i = 2:n_groups-1
        a = append(a,[newline,'           ',scatterStrings{i},';']);
    end
    a = append(a,[newline,'           ',scatterStrings{n_groups},'"']);
    a = append(a,[newline,'block = ',idString]);
    printed = a;
    
end