[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 3
    dx = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    dy = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    dz = '30 300 30'
    ix = '2 2 2 2 2 2 2 2 2'
    iy = '2 2 2 2 2 2 2 2 2'
    iz = '1 5 1'
    subdomain_id = '99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99

		    50  1 51  3 52  5 53  6 99
  		     1  7  8  9  1 54 10 11 99
 		    51  8 51  1  2  5 53 12 99
  		     3  9  1 13  1 55 15 14 99
		    52  1  2  1 56  3 57 99 99
 		     5 54  5 55  3 15  8 99 99
 		    53 10 53 15 57  8 99 99 99
  		     6 11 12 14 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99

		    99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99
  		    99 99 99 99 99 99 99 99 99
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
    boundary = '0 2 3 5'
    value = '0 0'
  []

  [ReflectingBoundaries]
    type = ArrayNeumannBC
    variable = scalar_flux
    boundary = '1 4'
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
# store reaction rate (fission power)
  [kappa_fission_phi]
    family = L2_LAGRANGE
    order = FIRST
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
  [compute_kappa_fission_phi]
    type = ReactionRateAux
    variable = kappa_fission_phi
    scalar_flux_variable = scalar_flux
    cross_section = kappa_sigma_f
  []
[]

[UserObjects]
# Computes layered averages axially of kappa sigma f
  [integrate_kappa_fission_by_layer]
    type = LayeredIntegral
    direction = z
    num_layers = 20
    variable = kappa_fission_phi
    execute_on = timestep_end
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
     [u42_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.373845e+00  3.792145e-01 "
     sigma_t = " 5.577729e-01  1.473914e+00 "
     nu_sigma_f = " 7.625890e-03  1.578920e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 9.889730e-14  2.101800e-12 "
     adf = " 1.010790e+00  1.003070e+00 "
     sigma_s = " 5.303440e-01  0 ;
                 1.748660e-02  1.355580e+00 "
     block =  1 
     []
     [u42_2250]
     type = MultigroupXSMaterial
     diffusivity = " 1.391242e+00  3.672075e-01 "
     sigma_t = " 5.584834e-01  1.487941e+00 "
     nu_sigma_f = " 6.080590e-03  1.562600e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 7.659100e-14  1.969850e-12 "
     adf = " 1.002190e+00  9.436800e-01 "
     sigma_s = " 5.308610e-01  0 ;
                 1.704800e-02  1.372770e+00 "
     block =  2 
     []
     [u45_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.372589e+00  3.798268e-01 "
     sigma_t = " 5.569455e-01  1.476976e+00 "
     nu_sigma_f = " 7.960890e-03  1.667230e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 1.033350e-13  2.219420e-12 "
     adf = " 1.010360e+00  1.000580e+00 "
     sigma_s = " 5.295720e-01  0 ;
                 1.727610e-02  1.354480e+00 "
     block =  3 
     []
     [m43_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.383964e+00  3.681854e-01 "
     sigma_t = " 5.502577e-01  1.536182e+00 "
     nu_sigma_f = " 7.694120e-03  3.108840e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 9.112900e-14  3.668540e-12 "
     adf = " 9.962600e-01  1.199830e+00 "
     sigma_s = " 5.232790e-01  0 ;
                 1.465950e-02  1.320410e+00 "
     block =  5 
     []
     [u42_3250]
     type = MultigroupXSMaterial
     diffusivity = " 1.402830e+00  3.647604e-01 "
     sigma_t = " 5.600983e-01  1.487800e+00 "
     nu_sigma_f = " 5.503170e-03  1.440550e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 6.852550e-14  1.788780e-12 "
     adf = " 1.002080e+00  9.418100e-01 "
     sigma_s = " 5.321460e-01  0 ;
                 1.705640e-02  1.376150e+00 "
     block =  6 
     []
     [u42_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.385759e+00  3.687768e-01 "
     sigma_t = " 5.576902e-01  1.487108e+00 "
     nu_sigma_f = " 6.396600e-03  1.612680e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.105450e-14  2.050380e-12 "
     adf = " 1.002490e+00  9.463200e-01 "
     sigma_s = " 5.302260e-01  0 ;
                 1.707330e-02  1.370620e+00 "
     block =  7 
     []
     [u45_3250]
     type = MultigroupXSMaterial
     diffusivity = " 1.400495e+00  3.655444e-01 "
     sigma_t = " 5.593640e-01  1.490340e+00 "
     nu_sigma_f = " 5.770590e-03  1.522730e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 7.207880e-14  1.897580e-12 "
     adf = " 1.001920e+00  9.410300e-01 "
     sigma_s = " 5.314790e-01  0 ;
                 1.690980e-02  1.374670e+00 "
     block =  8 
     []
     [m40_2250]
     type = MultigroupXSMaterial
     diffusivity = " 1.385800e+00  3.688421e-01 "
     sigma_t = " 5.515759e-01  1.514071e+00 "
     nu_sigma_f = " 7.043850e-03  2.737560e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.347960e-14  3.228660e-12 "
     adf = " 9.960700e-01  1.132170e+00 "
     sigma_s = " 5.245000e-01  0 ;
                 1.483290e-02  1.321180e+00 "
     block =  9 
     []
     [m40_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.376432e+00  3.677301e-01 "
     sigma_t = " 5.476349e-01  1.571044e+00 "
     nu_sigma_f = " 8.339770e-03  3.678160e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 9.891940e-14  4.346910e-12 "
     adf = " 1.004620e+00  1.257080e+00 "
     sigma_s = " 5.210330e-01  0 ;
                 1.500230e-02  1.319850e+00 "
     block =  10 
     []
     [u45_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.384211e+00  3.696368e-01 "
     sigma_t = " 5.570338e-01  1.489703e+00 "
     nu_sigma_f = " 6.702310e-03  1.696720e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.512950e-14  2.162990e-12 "
     adf = " 1.002410e+00  9.460300e-01 "
     sigma_s = " 5.296150e-01  0 ;
                 1.691660e-02  1.369030e+00 "
     block =  11 
     []
     [m43_3500]
     type = MultigroupXSMaterial
     diffusivity = " 1.391591e+00  3.686891e-01 "
     sigma_t = " 5.526504e-01  1.501813e+00 "
     nu_sigma_f = " 6.787620e-03  2.506620e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.033920e-14  2.952170e-12 "
     adf = " 9.943800e-01  1.127420e+00 "
     sigma_s = " 5.253220e-01  0 ;
                 1.465060e-02  1.322150e+00 "
     block =  12 
     []
     [m40_3750]
     type = MultigroupXSMaterial
     diffusivity = " 1.393790e+00  3.692454e-01 "
     sigma_t = " 5.537751e-01  1.487623e+00 "
     nu_sigma_f = " 6.293800e-03  2.242660e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 7.454690e-14  2.640120e-12 "
     adf = " 9.957200e-01  1.080690e+00 "
     sigma_s = " 5.263420e-01  0 ;
                 1.486960e-02  1.322780e+00 "
     block =  13 
     []
     [u45_2000]
     type = MultigroupXSMaterial
     diffusivity = " 1.386786e+00  3.687997e-01 "
     sigma_t = " 5.574143e-01  1.490218e+00 "
     nu_sigma_f = " 6.536200e-03  1.673140e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.278300e-14  2.124020e-12 "
     adf = " 1.002200e+00  9.443600e-01 "
     sigma_s = " 5.299230e-01  0 ;
                 1.690180e-02  1.370190e+00 "
     block =  14 
     []
     [m43_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.376398e+00  3.669326e-01 "
     sigma_t = " 5.470737e-01  1.580733e+00 "
     nu_sigma_f = " 8.726880e-03  3.839990e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 1.034190e-13  4.537550e-12 "
     adf = " 1.003460e+00  1.294330e+00 "
     sigma_s = " 5.204740e-01  0 ;
                 1.481260e-02  1.320910e+00 "
     block =  15 
     []
     [u42_3500_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.405817e+00  3.642478e-01 "
     sigma_t = " 5.604957e-01  1.487503e+00 "
     nu_sigma_f = " 5.370440e-03  1.407960e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 6.668740e-14  1.742240e-12 "
     adf = " 1.002100e+00  9.416200e-01 "
     sigma_s = " 5.324610e-01  0 ;
                 1.706600e-02  1.376870e+00 "
     block =  50 
     []
     [u42_2250_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.391242e+00  3.672075e-01 "
     sigma_t = " 5.584834e-01  1.487941e+00 "
     nu_sigma_f = " 6.080590e-03  1.562600e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 7.659100e-14  1.969850e-12 "
     adf = " 1.002190e+00  9.436800e-01 "
     sigma_s = " 5.308610e-01  0 ;
                 1.704800e-02  1.372770e+00 "
     block =  51 
     []
     [u45_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.406333e+00  3.645166e-01 "
     sigma_t = " 5.601413e-01  1.489645e+00 "
     nu_sigma_f = " 5.494200e-03  1.455190e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 6.825940e-14  1.801350e-12 "
     adf = " 1.001930e+00  9.406600e-01 "
     sigma_s = " 5.320980e-01  0 ;
                 1.693380e-02  1.376130e+00 "
     block =  52 
     []
     [u45_0015_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.372589e+00  3.798268e-01 "
     sigma_t = " 5.569455e-01  1.476976e+00 "
     nu_sigma_f = " 7.960890e-03  1.667230e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 1.033350e-13  2.219420e-12 "
     adf = " 1.010360e+00  1.000580e+00 "
     sigma_s = " 5.295720e-01  0 ;
                 1.727610e-02  1.354480e+00 "
     block =  53 
     []
     [u42_3250_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.402830e+00  3.647604e-01 "
     sigma_t = " 5.600983e-01  1.487800e+00 "
     nu_sigma_f = " 5.503170e-03  1.440550e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 6.852550e-14  1.788780e-12 "
     adf = " 1.002080e+00  9.418100e-01 "
     sigma_s = " 5.321460e-01  0 ;
                 1.705640e-02  1.376150e+00 "
     block =  54 
     []
     [u45_2000_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.386786e+00  3.687997e-01 "
     sigma_t = " 5.574143e-01  1.490218e+00 "
     nu_sigma_f = " 6.536200e-03  1.673140e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.278300e-14  2.124020e-12 "
     adf = " 1.002200e+00  9.443600e-01 "
     sigma_s = " 5.299230e-01  0 ;
                 1.690180e-02  1.370190e+00 "
     block =  55 
     []
     [u42_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.408883e+00  3.637644e-01 "
     sigma_t = " 5.608513e-01  1.487137e+00 "
     nu_sigma_f = " 5.242490e-03  1.375210e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 6.492130e-14  1.695960e-12 "
     adf = " 1.002100e+00  9.415000e-01 "
     sigma_s = " 5.327350e-01  0 ;
                 1.707760e-02  1.377550e+00 "
     block =  56 
     []
     [u42_1750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.385759e+00  3.687768e-01 "
     sigma_t = " 5.576902e-01  1.487108e+00 "
     nu_sigma_f = " 6.396600e-03  1.612680e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 8.105450e-14  2.050380e-12 "
     adf = " 1.002490e+00  9.463200e-01 "
     sigma_s = " 5.302260e-01  0 ;
                 1.707330e-02  1.370620e+00 "
     block =  57 
     []
     [reflector]
     type = MultigroupXSMaterial
     diffusivity = " 1.104166e+00  2.719601e-01 "
     sigma_t = " 6.700725e-01  2.027498e+00 "
     nu_sigma_f = " 0  0 "
     chi = " 1  0 "
     kappa_sigma_f = " 0  0 "
     adf = " 1.176390e+00  2.275500e-01 "
     sigma_s = " 6.401210e-01  0 ;
                 2.752620e-02  1.990260e+00 "
     block =  99 
     []
[]








