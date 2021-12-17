[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '13'
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
     [m40_3750]
     type = MultigroupXSMaterial
     diffusivity = " 2.819435e+00  1.969904e+00  1.163983e+00  7.726262e-01  7.443966e-01  7.447957e-01  4.974568e-01  2.734975e-01 "
     sigma_t = " 1.761430e-01  2.675123e-01  5.414563e-01  8.501969e-01  8.935405e-01  9.158000e-01  1.206953e+00  1.701553e+00 "
     nu_sigma_f = " 1.170510e-02  5.094070e-03  7.564540e-04  3.517040e-03  2.255380e-02  1.028340e-02  2.541600e-01  2.019430e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.369340e-13  6.349020e-14  8.829800e-15  4.140020e-14  2.654240e-13  1.210770e-13  2.997140e-12  2.373530e-12 "
     adf = " 9.908000e-01  9.868900e-01  9.943200e-01  9.997300e-01  1.005520e+00  1.015310e+00  1.066310e+00  1.091430e+00 "
     sigma_s = " 1.024700e-01  0  0  0  0  0  0  0 ;
                 4.386790e-02  1.698900e-01  0  0  0  0  0  0 ;
                 2.481070e-02  9.433840e-02  4.699270e-01  0  0  0  0  0 ;
                 1.813360e-04  7.600350e-04  6.868460e-02  7.028780e-01  0  0  0  0 ;
                 8.190350e-07  7.963820e-06  9.367640e-04  1.320770e-01  6.824940e-01  0  0  0 ;
                 0  0  2.243140e-05  3.375480e-03  1.352840e-01  5.919220e-01  5.760330e-03  0 ;
                 0  0  0  4.898830e-04  1.911120e-02  2.122540e-01  7.309010e-01  1.157920e-01 ;
                 0  0  0  1.308540e-04  5.809760e-03  4.262340e-02  2.997660e-01  1.425160e+00 "
     block =  13 
     []
[]
