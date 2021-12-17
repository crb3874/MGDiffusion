dx = [0, 21.42/2, repelem(21.42,8)];
dy = [0, 21.42/2, repelem(21.42,8)];
dx = cumsum(dx);
dy = cumsum(dy);

aro_parcs2g = readmatrix("/Users/colinbrennan/projects/mg_diffusion/MATLAB_util/data/parc2g_aro.csv");
ari_parcs2g = readmatrix("/Users/colinbrennan/projects/mg_diffusion/MATLAB_util/data/parc2g_ari.csv");

aro_power = [ [1.374 1.735 1.418 1.525 1.035 1.032 0.997 0.413 0.000];
              [1.735 1.563 1.245 1.277 1.349 0.918 0.978 0.491 0.000];
              [1.418 1.245 1.325 1.446 1.247 1.114 0.991 0.393 0.000];
              [1.525 1.277 1.446 1.076 1.308 1.143 0.892 0.341 0.000];
              [1.035 1.348 1.247 1.308 0.904 1.067 0.585 0.000 0.000];
              [1.032 0.917 1.114 1.142 1.067 0.754 0.281 0.000 0.000];
              [0.997 0.978 0.991 0.892 0.585 0.281 0.000 0.000 0.000];
              [0.413 0.491 0.393 0.340 0.000 0.000 0.000 0.000 0.000];
              [0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000]];
                
ari_power = [ [1.209 2.533 1.202 2.196 0.742 0.669 0.300 0.205 0.000];
              [2.533 2.459 1.812 2.103 1.832 0.449 0.489 0.268 0.000];
              [1.202 1.812 1.198 2.452 1.944 0.985 0.329 0.198 0.000];
              [2.196 2.103 2.452 1.823 1.675 0.531 0.450 0.186 0.000];
              [0.742 1.832 1.944 1.675 0.508 0.696 0.190 0.000 0.000];
              [0.669 0.449 0.985 0.531 0.696 0.562 0.186 0.000 0.000];
              [0.300 0.489 0.329 0.450 0.190 0.186 0.000 0.000 0.000];
              [0.205 0.268 0.198 0.186 0.000 0.000 0.000 0.000 0.000];
              [0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000]];
     
aro_power=aro_parcs2g;
ari_power=ari_parcs2g;
aro_power = aro_power/sum(sum(aro_power));
ari_power = ari_power/sum(sum(ari_power));

aro_path = "/Users/colinbrennan/problems/aro";
ari_path = "/Users/colinbrennan/problems/ari";

energy_groups_paths = aro_path + ["/nea_2g","/nea_4g","/nea_8g"];
gdir = {G2_Group_Directory,G4_Group_Directory,G8_Group_Directory};
n_groups = [2,4,8];

cellsperfa = [1 2 4 8 16 32 64];
file_paths = ["/1x_flux_sampler_0001.csv","/2x_flux_sampler_0001.csv","/4x_flux_sampler_0001.csv",...
    "/8x_flux_sampler_0001.csv","/16x_flux_sampler_0001.csv","/32x_flux_sampler_0001.csv","/64x_flux_sampler_0001.csv"];
  
pwe_ref = zeros(length(file_paths),3); ewe_ref = zeros(length(file_paths),3); 
l2_error = zeros(length(file_paths),3); l1_error = zeros(length(file_paths),3); linfty_error = zeros(length(file_paths),3);

reference_power = aro_power;

for k = 1:length(energy_groups_paths)-1
    
    ref_assm_flux = integrate_MOOSE_2d_vpp_over_subdomains(dx,dy,cellsperfa(7),n_groups(k),energy_groups_paths(k) + file_paths(7));
    reference_power = compute_MOOSE_power(ref_assm_flux, n_groups(k), gdir{k});
    
    for i = 1:length(file_paths)
        
        if isfile( energy_groups_paths(k) + file_paths(i) )
            
            integrated_assembly_flux = integrate_MOOSE_2d_vpp_over_subdomains(dx,dy,cellsperfa(i),n_groups(k),energy_groups_paths(k) + file_paths(i));
            power = compute_MOOSE_power(integrated_assembly_flux, n_groups(k), gdir{k});

            error = 100 * (power - reference_power)./reference_power;
            error( isnan( error ) ) = 0;

            pwe = sum(sum( abs(error) .* reference_power ) ); pwe_ref(i,k) = pwe;
            ewe = sum(sum( abs(error) .* abs(error) ) )/ sum(sum( abs(error) ) ); ewe_ref(i,k) = ewe;
            l2 = sqrt( sum(sum( error.^2 )) ); l2_error(i,k) = l2;
            l1 = sum(sum(error)); l1_error(i,k) = l1;
            linfty = max(max( abs(error) ) ); linfty_error(i,k) = linfty;
            
        end

    end                
end

aro_2g_eigen    =[0.9399687270 0.9398635308 0.9399117273 0.9400029373 0.9400428625 0.9400548038];
aro_2g_time     =[1.486 2.313 6.376 23.544 92.011 449.093];

aro_4g_eigen    =[0.9398536496 0.9397928238 0.9399041904 0.9400065490 0.9400446450 0.9400554957];
aro_4g_time     =[1.623 3.383 9.953 37.798 174.812 867.693];

aro_8g_eigen    =[0.9390558798 0.9389908359 0.9391062584 0.9392070596 0.9392474322 0.9392595170];
aro_8g_time     =[2.705 7.318 24.463 101.662 538.137 2856.847]; 

ari_2g_eigen    =[1.0100011269 1.0089378428 1.0086832545 1.0086406032 1.0086368415 1.0086367067];
ari_2g_time     =[1.431 1.643 4.680 16.599 64.736 317.358];

ari_4g_eigen    =[1.0106733333 1.0091667431 1.0088895704 1.0088341203 1.0088220669 1.0088191732];
ari_4g_time     =[1.008 2.269 6.701 25.340 117.288 598.111];

ari_8g_eigen    =[1.0100052636 1.0083445844 1.0080610922 1.0080014526 1.0079924003 1.0079912208];
ari_8g_time     =[3.071 4.935 16.694 68.999 357.996 1906.764];

aro_eigen = 1./[aro_2g_eigen; aro_4g_eigen; aro_8g_eigen];
aro_time = [aro_2g_time; aro_4g_time; aro_8g_time];

ari_eigen = 1./[ari_2g_eigen; ari_4g_eigen; ari_8g_eigen];
ari_time = [ari_2g_time; ari_4g_time; ari_8g_time];

report_aro_eigens = [1.06387 1.06379 1.06364 1.06378 1.06379 1.06376 1.06354 1.06379];
true_aro_eigen = mean(report_aro_eigens);
stdv_aro_eigen = std(report_aro_eigens);

report_ari_eigens = [0.99202 0.99154 0.99142 0.99153 0.99154 0.99136 0.99114 0.99153];
true_ari_eigen = mean(report_ari_eigens);
stdv_ari_eigen = std(report_ari_eigens);

figure(1);
loglog( cellsperfa(1:7).^2 , pwe_ref(1:7,1:2) , "o-" )
grid on
box on
legend("2g","4g")
title("PWE w/ Mesh Refinement")
xlabel("Elements per assembly")
ylabel("% Error")

figure(2);
loglog( cellsperfa(1:7).^2 , ewe_ref(1:7,1:2) , "o-" )
grid on
box on
legend("2g","4g")
title("EWE w/ Mesh Refinement")
xlabel("Elements per assembly")
ylabel("% Error")

figure(99);
loglog( cellsperfa(1:7).^2 , l2_error(1:7,1:2) , "o-" )
grid on
box on
legend("2g","4g")
title("L2 Error w/ Mesh Refinement")
xlabel("Elements per assembly")
ylabel("% Error")

figure(100);
loglog( cellsperfa(1:7).^2 , l1_error(1:7,1:2) , "o-" )
grid on
box on
legend("2g","4g")
title("L1 Error w/ Mesh Refinement")
xlabel("Elements per assembly")
ylabel("% Error")

figure(101);
loglog( cellsperfa(1:7).^2 , linfty_error(1:7,1:2) , "o-" )
grid on
box on
legend("2g","4g")
title("L_{\infty} Error w/ Mesh Refinement")
xlabel("Elements per assembly")
ylabel("% Error")

figure(3);
loglog( cellsperfa(1:6).^2 , abs( aro_eigen' - true_aro_eigen )*1e5)
yline( stdv_aro_eigen*1e5 , "--");
grid on
box on
legend("2g","4g","8g")
title("\Delta pcm, ARO")
xlabel("Elements per assembly")
ylabel("\Delta pcm")

figure(4);
loglog( cellsperfa(1:6).^2 , abs( ari_eigen' - true_ari_eigen )*1e5)
yline( stdv_ari_eigen*1e5 , "--");
grid on
box on
legend("2g","4g","8g")
title("\Delta pcm, ARI")
xlabel("Elements per assembly")
ylabel("\Delta pcm")

figure(5);
loglog( cellsperfa(1:6).^2 , aro_time)
grid on
box on
legend("2g","4g","8g")
title("Runtime, ARO, 2 Nodes/32 Cores Frontera")
xlabel("Elements per assembly")
ylabel("(s)")

figure(6);
loglog( cellsperfa(1:6).^2 , ari_time)
grid on
box on
legend("2g","4g","8g")
title("Runtime, ARI, 2 Nodes/32 Cores Frontera")
xlabel("Elements per assembly")
ylabel("(s)")


function flux_out = integrate_MOOSE_2d_vpp_over_subdomains(dx,dy,ref,n_vectors,file_path)
    
    flux_out = zeros( length(dx), length(dy), n_vectors);
    
    in = readmatrix(file_path);
    
    raw_flux = zeros( length(in), n_vectors );
    for j = 1:n_vectors
        raw_flux(:,j) = in(:,1+j);
    end
    
    x_coords = in(:,2 + n_vectors);
    y_coords = in(:,3 + n_vectors);
    
    for i = 1:length(x_coords)
        
        x = x_coords(i);
        y = y_coords(i);
        
        ix = -1;
        iy = -1;
        % Compare x_coord with subdomain divisions.
        for k = 1:length(dx)-1
            if x >= dx(k) && x < dx(k+1)
                ix = k;
            end
        end
        
        % Compare y_coords with subdomain divisions.
        for k = 1:length(dy)-1
            if y >= dy(k) && y < dy(k+1)
                iy = k;
            end
        end
        
        for j = 1:n_vectors
            flux_out(ix, iy, j) = flux_out(ix, iy, j) + raw_flux(i,j)'/ref^2;
        end
        
    end
    
    
end

function power_out = compute_MOOSE_power(integrated_assembly_flux, n_groups, gdir)
    
    power = gdir{1}.kapfission .* integrated_assembly_flux(1:end-1,1:end-1,1);
    
    for i = 2:n_groups
        power = power + gdir{i}.kapfission .* integrated_assembly_flux(1:end-1,1:end-1,i);
    end
    
    power(2:end,1) = power(2:end,1)*2;
    power(1,2:end) = power(1,2:end)*2;
    power(1,1) = power(1,1)*4;

    norm = sum(sum(power));
    power_out = power/norm;

end
