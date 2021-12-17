[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '3'
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
     [u45_0015]
     type = MultigroupXSMaterial
     diffusivity = " 2.698072e+00  1.926515e+00  1.168938e+00  7.719623e-01  7.503350e-01  7.665514e-01  5.216304e-01  2.707452e-01 "
     sigma_t = " 1.759968e-01  2.671938e-01  5.454011e-01  8.695608e-01  9.030987e-01  8.802287e-01  1.123176e+00  1.752532e+00 "
     nu_sigma_f = " 1.154120e-02  4.977310e-03  1.132930e-03  6.931830e-03  2.467290e-02  2.534100e-02  1.043180e-01  2.147280e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.371050e-13  6.374480e-14  1.500770e-14  9.229610e-14  3.284950e-13  3.374080e-13  1.388210e-12  2.858830e-12 "
     adf = " 1.007490e+00  1.011870e+00  1.015710e+00  1.009050e+00  1.001340e+00  9.978500e-01  9.968000e-01  1.003480e+00 "
     sigma_s = " 1.005970e-01  0  0  0  0  0  0  0 ;
                 4.488370e-02  1.667180e-01  0  0  0  0  0  0 ;
                 2.551330e-02  9.714090e-02  4.717920e-01  0  0  0  0  0 ;
                 1.906750e-04  7.911240e-04  7.055750e-02  7.160970e-01  0  0  0  0 ;
                 8.691690e-07  8.288720e-06  9.636810e-04  1.371240e-01  6.875430e-01  0  0  0 ;
                 0  0  2.304820e-05  3.508830e-03  1.429610e-01  5.844560e-01  4.434470e-03  0 ;
                 0  0  0  5.092340e-04  2.020200e-02  2.260470e-01  7.284010e-01  1.222750e-01 ;
                 0  0  0  1.359560e-04  6.141340e-03  4.534100e-02  3.149580e-01  1.471520e+00 "
     block =  3 
     []
[]
