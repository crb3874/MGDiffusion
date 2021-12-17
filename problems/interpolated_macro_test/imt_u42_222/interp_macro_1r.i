[Mesh]
	[QuarterCore]
		type = CartesianMeshGenerator
    		dim = 2
    		dx = '21.42'
    		dy = '21.42'
    		ix = '1'
    		iy = '1'
    		subdomain_id = '1'
  []
[]

[Variables]
	[scalar_flux]
		order = FIRST
		family = L2_LAGRANGE
		components = 2
	[]
[]

[AuxVariables]
	[burnup]
		family = MONOMIAL
		order = CONSTANT
	[]
	[mod_dens]
		family = MONOMIAL
		order = CONSTANT
	[]
	[boron]
		family = MONOMIAL
		order = CONSTANT
	[]
	[fuel_temp]
		family = MONOMIAL
		order = CONSTANT
	[]

[]

[ICs]
	[ic_burnup]
		type = ConstantIC
		variable = burnup
		value = 0.1500
	[]
	[ic_mod_dens]
		type = ConstantIC
		variable = mod_dens
		value = 711.87
	[]
	[ic_boron]
		type = ConstantIC
		variable = boron
		value = 1000
	[]
	[ic_fuel_temp]
		type = ConstantIC
		variable = fuel_temp
		value = 900
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
  	[ReflectingBoundaries]
    		type = ArrayNeumannBC
    		variable = scalar_flux
    		boundary = '0 1 2 3'
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

[Materials]
	[example_mg_interp_material]
		type = InterpolatedMGXSMaterial
		xs_table = '/Users/colinbrennan/projects/mg_diffusion/problems/interpolated_macro_test/example_xs_lib.csv'
		n_groups = 2
		burnup_var = burnup
		fuel_temp_var = fuel_temp
		boron_var = boron
		mod_dens_var = mod_dens
	[]
[]
