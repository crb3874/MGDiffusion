[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '15'
  []
[]

[Variables]
  [scalar_flux]
    order = FIRST
    family = L2_LAGRANGE
    components = 8
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
    value = '0 0 0 0 0 0 0 0'
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

[Outputs]
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
     [m43_0015]
     type = MultigroupXSMaterial
     diffusivity = " 2.684038e+00  1.916689e+00  1.154709e+00  7.703798e-01  7.497831e-01  7.579082e-01  4.842814e-01  2.538735e-01 "
     sigma_t = " 1.776077e-01  2.683547e-01  5.417388e-01  8.520379e-01  8.877964e-01  8.927141e-01  1.327402e+00  1.831999e+00 "
     nu_sigma_f = " 1.266180e-02  5.873910e-03  1.403890e-03  6.116440e-03  3.230100e-02  2.162660e-02  4.122000e-01  3.568300e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.472460e-13  7.231660e-14  1.637370e-14  7.236580e-14  3.832020e-13  2.558540e-13  4.875740e-12  4.211740e-12 "
     adf = " 9.958000e-01  9.934200e-01  9.996400e-01  1.005780e+00  1.020830e+00  1.046060e+00  1.217580e+00  1.368280e+00 "
     sigma_s = " 1.030480e-01  0  0  0  0  0  0  0 ;
                 4.421320e-02  1.701860e-01  0  0  0  0  0  0 ;
                 2.506180e-02  9.463270e-02  4.707210e-01  0  0  0  0  0 ;
                 1.819760e-04  7.602160e-04  6.795220e-02  7.043850e-01  0  0  0  0 ;
                 8.228240e-07  7.962300e-06  9.266940e-04  1.313470e-01  6.758600e-01  0  0  0 ;
                 0  0  2.216480e-05  3.357020e-03  1.362560e-01  5.861220e-01  7.458820e-03  0 ;
                 0  0  0  4.871890e-04  1.922760e-02  2.121500e-01  7.600100e-01  1.215260e-01 ;
                 0  0  0  1.300490e-04  5.845150e-03  4.259670e-02  2.907060e-01  1.459710e+00 "
     block =  15 
     []
[]
