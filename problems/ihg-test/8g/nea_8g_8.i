[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '8'
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
     [u45_3250]
     type = MultigroupXSMaterial
     diffusivity = " 2.811848e+00  1.979120e+00  1.180137e+00  7.735352e-01  7.447774e-01  7.553287e-01  5.051592e-01  2.752364e-01 "
     sigma_t = " 1.745246e-01  2.660974e-01  5.451057e-01  8.680870e-01  9.093871e-01  9.019890e-01  1.158755e+00  1.707773e+00 "
     nu_sigma_f = " 1.118810e-02  4.711330e-03  6.820420e-04  3.802000e-03  1.740850e-02  1.234390e-02  1.457810e-01  1.564720e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.322120e-13  5.982500e-14  8.643830e-15  4.887810e-14  2.204410e-13  1.587380e-13  1.777370e-12  1.975330e-12 "
     adf = " 9.987400e-01  1.000520e+00  1.006950e+00  1.003750e+00  9.960300e-01  9.866000e-01  9.575900e-01  9.303100e-01 "
     sigma_s = " 1.001560e-01  0  0  0  0  0  0  0 ;
                 4.436760e-02  1.662650e-01  0  0  0  0  0  0 ;
                 2.513480e-02  9.663310e-02  4.710470e-01  0  0  0  0  0 ;
                 1.892620e-04  7.898010e-04  7.122200e-02  7.151650e-01  0  0  0  0 ;
                 8.581300e-07  8.274990e-06  9.727880e-04  1.377560e-01  6.934710e-01  0  0  0 ;
                 0  0  2.328810e-05  3.524840e-03  1.419660e-01  5.912050e-01  4.589880e-03  0 ;
                 0  0  0  5.115640e-04  2.007280e-02  2.243440e-01  7.296390e-01  1.186090e-01 ;
                 0  0  0  1.366540e-04  6.101960e-03  4.502050e-02  3.235190e-01  1.464010e+00 "
     block =  8 
     []
[]
