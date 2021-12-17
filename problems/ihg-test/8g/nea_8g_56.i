[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '56'
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
     [u42_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.173696e+00  2.089078e+00  1.182117e+00  7.664615e-01  7.251500e-01  7.249355e-01  5.015722e-01  2.774056e-01 "
     sigma_t = " 1.748314e-01  2.650866e-01  5.388893e-01  8.512481e-01  9.159585e-01  9.217033e-01  1.160341e+00  1.680080e+00 "
     nu_sigma_f = " 1.125830e-02  4.629250e-03  5.751310e-04  3.122360e-03  1.542750e-02  1.024620e-02  1.437250e-01  1.460520e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.324690e-13  5.873800e-14  7.209300e-15  3.972980e-14  1.931830e-13  1.304460e-13  1.738440e-12  1.822700e-12 "
     adf = " 1.036550e+00  1.042170e+00  1.037520e+00  1.052830e+00  1.122580e+00  1.195850e+00  1.285780e+00  1.366350e+00 "
     sigma_s = " 1.022160e-01  0  0  0  0  0  0  0 ;
                 4.359080e-02  1.689610e-01  0  0  0  0  0  0 ;
                 2.401250e-02  9.284610e-02  4.666850e-01  0  0  0  0  0 ;
                 1.757950e-04  7.421460e-04  6.855550e-02  6.990750e-01  0  0  0  0 ;
                 7.874730e-07  7.772500e-06  9.316680e-04  1.290570e-01  6.864230e-01  0  0  0 ;
                 0  0  2.234510e-05  3.290490e-03  1.304860e-01  5.859120e-01  5.009710e-03  0 ;
                 0  0  0  4.775480e-04  1.843170e-02  2.130880e-01  7.188600e-01  1.147740e-01 ;
                 0  0  0  1.274350e-04  5.603130e-03  4.274990e-02  3.009880e-01  1.412880e+00 "
     block =  56 
     []
[]
