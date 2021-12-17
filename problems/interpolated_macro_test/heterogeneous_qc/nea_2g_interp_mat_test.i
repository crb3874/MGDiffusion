[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    dy = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    ix = '1 1 1 1 1 1 1 1 1'
    iy = '1 1 1 1 1 1 1 1 1'
    subdomain_id = '50  1 51  3 52  5 53  6 99
  		     1  7  8  9  1 54 10 11 99
 		    51  8 51  1  2  5 53 12 99
  		     3  9  1 13  1 55 15 14 99
		    52  1  2  1 56  3 57 99 99
 		     5 54  5 55  3 15  8 99 99
 		    53 10 53 15 57  8 99 99 99
  		     6 11 12 14 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99'
  []
[]

[Variables]
  [scalar_flux]
    order = FIRST
    family = L2_LAGRANGE
    components = 2
  []
[]

[Kernels]
  [diffusion]
    type = ArrayDiffusion
    variable = scalar_flux
    diffusion_coefficient = diffusivity
  []
  [absorption]
    type = MultigroupAbsorption
    variable = scalar_flux
    sigma_t = sigma_t
  []
  [scattering]
    type = MultigroupScattering
    variable = scalar_flux
    sigma_s = sigma_s
  []
  [fission]
    type = MultigroupFission
    variable = scalar_flux
    nu_sigma_f = nu_sigma_f
    chi = chi
    extra_vector_tags = 'eigen'
  []
[]

[DGKernels]
  [dgdiffusion]
    type = MultigroupDGDiffusion
    variable = scalar_flux
    use_adf = true
    epsilon = 0
  []
[]

[BCs]
  [VacuumBoundaries]
    type = ArrayPenaltyDirichletBC
    variable = scalar_flux
    boundary = '1 2'
    value = '0 0'
  []

  [ReflectingBoundaries]
    type = ArrayNeumannBC
    variable = scalar_flux
    boundary = '1 2'
    value = '0 0'
  []

[]

[Executioner]
  type = Eigenvalue
  solve_type = 'Newton'
  free_power_iterations = 4
  nl_abs_tol = 1e-10
  nl_max_its = 10000

  line_search = none

  l_abs_tol = 1e-10

[]

[AuxVariables]
# copy array variable components
  [flux_fast]
    family = L2_LAGRANGE
    order = FIRST
  []
  [flux_thermal]
    family = L2_LAGRANGE
    order = FIRST
  []
# store integrated flux over each element
  [integrated_flux_fast]
    family = MONOMIAL
    order = CONSTANT
  []
  [integrated_flux_thermal]
    family = MONOMIAL
    order = CONSTANT
  []
# state variables
  [burnup]
    family = MONOMIAL
    order = CONSTANT
  []
  [fuel_temp]
    family = MONOMIAL
    order = CONSTANT
  []
  [boron]
    family = MONOMIAL
    order = CONSTANT
  []
  [mod_dens]
    family = MONOMIAL
    order = CONSTANT
  []
# store mat properties for debugging
  [diff_fast]
    family = MONOMIAL
    order = CONSTANT
  []
  [sigma_t_fast]
    family = MONOMIAL
    order = CONSTANT
  []
  [nu_sigma_f_fast]
    family = MONOMIAL
    order = CONSTANT
  []
  [adf_fast]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [copy_flux_fast]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_fast
    component = 0 
  []
  [copy_flux_thermal]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_thermal
    component = 1 
  []
  [integrate_flux_fast] 
    type = ElementLpNormAux
    variable = integrated_flux_fast
    coupled_variable = flux_fast
    p = 1
  []
  [integrate_flux_thermal] 
    type = ElementLpNormAux
    variable = integrated_flux_thermal
    coupled_variable = flux_thermal
    p = 1
  []
  [copy_diff_0]
    type = MaterialRealArrayValueAux
    property = diffusivity
    variable = diff_fast
    index = 0
    execute_on = timestep_end
  []
  [copy_sigma_t_0]
    type = MaterialRealArrayValueAux
    property = sigma_t
    variable = sigma_t_fast
    component = 0
    execute_on = timestep_end
  []
  [copy_nu_sigma_f_0]
    type = MaterialRealArrayValueAux
    property = nu_sigma_f
    variable = nu_sigma_f_fast
    component = 0
    execute_on = timestep_end
  []
  [copy_adf_0]
    type = MaterialRealArrayValueAux
    property = adf
    variable = adf_fast
    component = 0
    execute_on = timestep_end
  []
[]

[ICs]
# setting initial conditions for state variables for static calculation
  [ic_burnup_0015]
    type = ConstantIC
    variable = burnup
    value = 0.150000
    block = '1 3 10 15 53'
  []
  [ic_burnup_1750]
    type = ConstantIC
    variable = burnup
    value = 17.500000
    block = '5 7 11 57'
  []
  [ic_burnup_2000]
    type = ConstantIC
    variable = burnup
    value = 20.000000
    block = '14 55'
  []
  [ic_burnup_2250]
    type = ConstantIC
    variable = burnup
    value = 22.500000
    block = '2 9 51'
  []
  [ic_burnup_3250]
    type = ConstantIC
    variable = burnup
    value = 32.500000
    block = '6 8 54'
  []
  [ic_burnup_3500]
    type = ConstantIC
    variable = burnup
    value = 35.000000
    block = '12 50'
  []
  [ic_burnup_3750]
    type = ConstantIC
    variable = burnup
    value = 37.500000
    block = '13 52 56'
  []
  [ic_fuel_temp]
    type = ConstantIC
    variable = fuel_temp
    value = 560.00
  []
  [ic_boron]
    type = ConstantIC
    variable = boron
    value = 1000.00
  []
  [ic_mod_dens]
    type = ConstantIC
    variable = mod_dens
    value = 752.06
  []
[]

[Postprocessors]
  [mem_per_process]
    type = MemoryUsage
    mem_units = megabytes
    value_type = average
    outputs = 'csv'
  []
  [perf_graph]
    type = PerfGraphData
    data_type = TOTAL
    section_name = 'Root'
    outputs = 'csv'
  []
[]

[VectorPostprocessors]
  [flux_sampler]
    type = ElementValueSampler
    variable = 'integrated_flux_fast integrated_flux_thermal'
    sort_by = id
    execute_on = 'TIMESTEP_END'
  []
[]

[Outputs]
  file_base = 'flux_sampler'
  exodus = true
  csv = true
  [pgraph]
    type = PerfGraphOutput
    execute_on = 'final'
    level = 2
    outputs = 'csv'
  []
[]

[Materials]
	[u42_assembly]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/u42_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '1 2 6 7'
	[]
	[u45_assembly]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/u45_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '3 8 11 14'
	[]
	[m40_assembly]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/m40_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '9 10 13'
	[]
	[m43_assembly]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/m43_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '5 12 15'
	[]
	[refl]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/refl_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = 99
	[]
	[u42_rodded]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/u42_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '50 51 54 56 57'
	[]
	[u45_rodded]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/xs_lib/u45_unrodded_2g.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
		block = '52 53 55'
	[]
[]








