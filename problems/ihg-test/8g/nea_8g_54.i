[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '54'
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
     [u42_3250_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.137609e+00  2.076830e+00  1.180066e+00  7.661673e-01  7.255351e-01  7.263240e-01  5.023258e-01  2.767101e-01 "
     sigma_t = " 1.751534e-01  2.652697e-01  5.389221e-01  8.514413e-01  9.154331e-01  9.188384e-01  1.160206e+00  1.685501e+00 "
     nu_sigma_f = " 1.129490e-02  4.665760e-03  6.274630e-04  3.466820e-03  1.650260e-02  1.152060e-02  1.459280e-01  1.560730e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.330410e-13  5.924630e-14  7.924550e-15  4.442120e-14  2.082410e-13  1.476730e-13  1.773910e-12  1.962580e-12 "
     adf = " 1.036500e+00  1.042090e+00  1.037450e+00  1.052780e+00  1.122460e+00  1.195310e+00  1.285340e+00  1.366910e+00 "
     sigma_s = " 1.022880e-01  0  0  0  0  0  0  0 ;
                 4.374120e-02  1.690380e-01  0  0  0  0  0  0 ;
                 2.409680e-02  9.293540e-02  4.668070e-01  0  0  0  0  0 ;
                 1.762660e-04  7.424470e-04  6.844690e-02  6.992650e-01  0  0  0  0 ;
                 7.913390e-07  7.775920e-06  9.301840e-04  1.289780e-01  6.859370e-01  0  0  0 ;
                 0  0  2.230600e-05  3.288500e-03  1.305490e-01  5.853630e-01  5.043850e-03  0 ;
                 0  0  0  4.772610e-04  1.843910e-02  2.131260e-01  7.194730e-01  1.151670e-01 ;
                 0  0  0  1.273480e-04  5.605430e-03  4.275490e-02  3.001920e-01  1.414060e+00 "
     block =  54 
     []
[]
