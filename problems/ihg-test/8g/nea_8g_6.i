[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '6'
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
     [u42_3250]
     type = MultigroupXSMaterial
     diffusivity = " 2.828118e+00  1.985782e+00  1.181020e+00  7.736860e-01  7.454520e-01  7.557259e-01  5.049273e-01  2.763202e-01 "
     sigma_t = " 1.744958e-01  2.660855e-01  5.452612e-01  8.678346e-01  9.083405e-01  9.019910e-01  1.156093e+00  1.699935e+00 "
     nu_sigma_f = " 1.116490e-02  4.673720e-03  6.265050e-04  3.461970e-03  1.618420e-02  1.120680e-02  1.405680e-01  1.462540e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.319270e-13  5.934710e-14  7.910560e-15  4.435840e-14  2.041530e-13  1.436450e-13  1.708870e-12  1.839200e-12 "
     adf = " 9.988800e-01  1.000720e+00  1.007100e+00  1.003880e+00  9.962800e-01  9.869800e-01  9.580100e-01  9.315800e-01 "
     sigma_s = " 1.001630e-01  0  0  0  0  0  0  0 ;
                 4.435250e-02  1.662750e-01  0  0  0  0  0  0 ;
                 2.512270e-02  9.662600e-02  4.711350e-01  0  0  0  0  0 ;
                 1.891480e-04  7.897090e-04  7.131180e-02  7.149940e-01  0  0  0  0 ;
                 8.572350e-07  8.274020e-06  9.740030e-04  1.378620e-01  6.930770e-01  0  0  0 ;
                 0  0  2.332050e-05  3.527630e-03  1.421180e-01  5.911540e-01  4.508180e-03  0 ;
                 0  0  0  5.119640e-04  2.009320e-02  2.243820e-01  7.282000e-01  1.180870e-01 ;
                 0  0  0  1.367730e-04  6.108190e-03  4.502540e-02  3.249500e-01  1.461860e+00 "
     block =  6 
     []
[]
