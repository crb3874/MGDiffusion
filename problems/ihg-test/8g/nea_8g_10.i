[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '10'
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
     [m40_0015]
     type = MultigroupXSMaterial
     diffusivity = " 2.691189e+00  1.919592e+00  1.155017e+00  7.706149e-01  7.506916e-01  7.590525e-01  4.862680e-01  2.558062e-01 "
     sigma_t = " 1.776086e-01  2.683617e-01  5.418262e-01  8.517047e-01  8.864990e-01  8.907254e-01  1.316690e+00  1.818127e+00 "
     nu_sigma_f = " 1.254970e-02  5.750720e-03  1.299400e-03  5.685900e-03  3.039720e-02  2.019210e-02  3.976100e-01  3.396840e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.461600e-13  7.097420e-14  1.516250e-14  6.730750e-14  3.607330e-13  2.389990e-13  4.703480e-12  4.010240e-12 "
     adf = " 9.981700e-01  9.964000e-01  1.001620e+00  1.006090e+00  1.018230e+00  1.040850e+00  1.190600e+00  1.319850e+00 "
     sigma_s = " 1.030540e-01  0  0  0  0  0  0  0 ;
                 4.423210e-02  1.702100e-01  0  0  0  0  0  0 ;
                 2.506880e-02  9.465310e-02  4.707940e-01  0  0  0  0  0 ;
                 1.819610e-04  7.602160e-04  6.800220e-02  7.041900e-01  0  0  0  0 ;
                 8.228050e-07  7.962420e-06  9.273680e-04  1.314590e-01  6.754920e-01  0  0  0 ;
                 0  0  2.218290e-05  3.359720e-03  1.363800e-01  5.854290e-01  7.350030e-03  0 ;
                 0  0  0  4.875960e-04  1.924410e-02  2.123840e-01  7.575030e-01  1.209220e-01 ;
                 0  0  0  1.301690e-04  5.850060e-03  4.263210e-02  2.908680e-01  1.455240e+00 "
     block =  10 
     []
[]
