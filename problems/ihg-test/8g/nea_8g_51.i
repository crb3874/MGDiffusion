[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '51'
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
     [u42_2250_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.068633e+00  2.052533e+00  1.175995e+00  7.656182e-01  7.266122e-01  7.294632e-01  5.045322e-01  2.753774e-01 "
     sigma_t = " 1.757551e-01  2.656250e-01  5.389592e-01  8.518467e-01  9.140798e-01  9.121121e-01  1.157500e+00  1.696671e+00 "
     nu_sigma_f = " 1.137730e-02  4.744120e-03  7.462360e-04  4.255250e-03  1.876930e-02  1.458080e-02  1.471980e-01  1.770820e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.342850e-13  6.034860e-14  9.562000e-15  5.522670e-14  2.405700e-13  1.892420e-13  1.811790e-12  2.261630e-12 "
     adf = " 1.036550e+00  1.042130e+00  1.037480e+00  1.052760e+00  1.122300e+00  1.194260e+00  1.284780e+00  1.369730e+00 "
     sigma_s = " 1.024240e-01  0  0  0  0  0  0  0 ;
                 4.401400e-02  1.691800e-01  0  0  0  0  0  0 ;
                 2.425590e-02  9.311210e-02  4.670280e-01  0  0  0  0  0 ;
                 1.771100e-04  7.430410e-04  6.821650e-02  6.996270e-01  0  0  0  0 ;
                 7.982260e-07  7.782580e-06  9.270470e-04  1.288030e-01  6.846770e-01  0  0  0 ;
                 0  0  2.222300e-05  3.284090e-03  1.307320e-01  5.838110e-01  5.080390e-03  0 ;
                 0  0  0  4.766170e-04  1.846130e-02  2.133820e-01  7.202470e-01  1.160160e-01 ;
                 0  0  0  1.271550e-04  5.612140e-03  4.279750e-02  2.986430e-01  1.416330e+00 "
     block =  51 
     []
[]
