[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '55'
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
     [u45_2000_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.032674e+00  2.039672e+00  1.174151e+00  7.653352e-01  7.262496e-01  7.297683e-01  5.051018e-01  2.738278e-01 "
     sigma_t = " 1.759530e-01  2.657320e-01  5.388244e-01  8.522092e-01  9.147984e-01  9.103968e-01  1.158975e+00  1.708456e+00 "
     nu_sigma_f = " 1.141980e-02  4.806680e-03  8.428960e-04  4.866630e-03  2.073600e-02  1.686940e-02  1.518330e-01  1.942950e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.348870e-13  6.117740e-14  1.086490e-14  6.347600e-14  2.675280e-13  2.200120e-13  1.881720e-12  2.498280e-12 "
     adf = " 1.036180e+00  1.041670e+00  1.037130e+00  1.052520e+00  1.122060e+00  1.193690e+00  1.284020e+00  1.371260e+00 "
     sigma_s = " 1.024460e-01  0  0  0  0  0  0  0 ;
                 4.411290e-02  1.692040e-01  0  0  0  0  0  0 ;
                 2.431520e-02  9.316850e-02  4.669930e-01  0  0  0  0  0 ;
                 1.774960e-04  7.433200e-04  6.807710e-02  6.998620e-01  0  0  0  0 ;
                 8.013540e-07  7.785650e-06  9.251540e-04  1.286470e-01  6.846510e-01  0  0  0 ;
                 0  0  2.217290e-05  3.280150e-03  1.306570e-01  5.833740e-01  5.146560e-03  0 ;
                 0  0  0  4.760450e-04  1.844990e-02  2.134770e-01  7.215250e-01  1.167980e-01 ;
                 0  0  0  1.269850e-04  5.608680e-03  4.281740e-02  2.971830e-01  1.418980e+00 "
     block =  55 
     []
[]
