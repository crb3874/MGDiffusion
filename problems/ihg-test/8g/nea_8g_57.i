[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '57'
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
     [u42_1750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.036680e+00  2.040833e+00  1.174002e+00  7.653616e-01  7.273320e-01  7.312700e-01  5.061548e-01  2.747623e-01 "
     sigma_t = " 1.760355e-01  2.657995e-01  5.389713e-01  8.520603e-01  9.131888e-01  9.081163e-01  1.154343e+00  1.702412e+00 "
     nu_sigma_f = " 1.142150e-02  4.784680e-03  8.119920e-04  4.698590e-03  1.993510e-02  1.640630e-02  1.452500e-01  1.876710e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.349440e-13  6.093010e-14  1.047820e-14  6.134250e-14  2.575480e-13  2.141680e-13  1.802470e-12  2.416250e-12 "
     adf = " 1.036810e+00  1.042450e+00  1.037730e+00  1.052920e+00  1.122380e+00  1.193960e+00  1.285180e+00  1.373240e+00 "
     sigma_s = " 1.024870e-01  0  0  0  0  0  0  0 ;
                 4.413780e-02  1.692460e-01  0  0  0  0  0  0 ;
                 2.433130e-02  9.320100e-02  4.671300e-01  0  0  0  0  0 ;
                 1.774880e-04  7.433400e-04  6.809950e-02  6.997960e-01  0  0  0  0 ;
                 8.012900e-07  7.785880e-06  9.254550e-04  1.287100e-01  6.838600e-01  0  0  0 ;
                 0  0  2.218100e-05  3.281690e-03  1.308580e-01  5.827430e-01  5.074390e-03  0 ;
                 0  0  0  4.762700e-04  1.847730e-02  2.136350e-01  7.203100e-01  1.164800e-01 ;
                 0  0  0  1.270510e-04  5.616990e-03  4.284300e-02  2.978870e-01  1.417380e+00 "
     block =  57 
     []
[]
