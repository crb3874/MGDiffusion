[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '14'
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
     [u45_2000]
     type = MultigroupXSMaterial
     diffusivity = " 2.743439e+00  1.949557e+00  1.174722e+00  7.729325e-01  7.463516e-01  7.593654e-01  5.086566e-01  2.735716e-01 "
     sigma_t = " 1.750974e-01  2.665098e-01  5.450057e-01  8.685967e-01  9.076035e-01  8.937612e-01  1.154311e+00  1.722099e+00 "
     nu_sigma_f = " 1.133140e-02  4.818110e-03  8.408460e-04  4.858140e-03  2.027630e-02  1.641650e-02  1.460820e-01  1.817710e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.341260e-13  6.132270e-14  1.083600e-14  6.336470e-14  2.615450e-13  2.140950e-13  1.810730e-12  2.337330e-12 "
     adf = " 9.990700e-01  1.000940e+00  1.007270e+00  1.003880e+00  9.960500e-01  9.869000e-01  9.600700e-01  9.336700e-01 "
     sigma_s = " 1.003370e-01  0  0  0  0  0  0  0 ;
                 4.456590e-02  1.664350e-01  0  0  0  0  0  0 ;
                 2.527570e-02  9.682590e-02  4.712550e-01  0  0  0  0  0 ;
                 1.898000e-04  7.903610e-04  7.085020e-02  7.156510e-01  0  0  0  0 ;
                 8.622450e-07  8.280920e-06  9.677140e-04  1.374630e-01  6.918650e-01  0  0  0 ;
                 0  0  2.315380e-05  3.517480e-03  1.421500e-01  5.891390e-01  4.646780e-03  0 ;
                 0  0  0  5.104910e-04  2.009460e-02  2.246680e-01  7.307140e-01  1.197360e-01 ;
                 0  0  0  1.363330e-04  6.108640e-03  4.507590e-02  3.208570e-01  1.467400e+00 "
     block =  14 
     []
[]
