[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '12'
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
     [m43_3500]
     type = MultigroupXSMaterial
     diffusivity = " 2.796608e+00  1.961246e+00  1.162814e+00  7.723272e-01  7.436310e-01  7.444248e-01  4.946347e-01  2.701768e-01 "
     sigma_t = " 1.762595e-01  2.675688e-01  5.413522e-01  8.505511e-01  8.947475e-01  9.167253e-01  1.225964e+00  1.722298e+00 "
     nu_sigma_f = " 1.184230e-02  5.231550e-03  8.671330e-04  4.001080e-03  2.513100e-02  1.180230e-02  2.813710e-01  2.266410e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.383390e-13  6.501670e-14  1.011810e-14  4.711430e-14  2.959470e-13  1.390220e-13  3.319380e-12  2.664930e-12 "
     adf = " 9.880700e-01  9.835100e-01  9.920800e-01  9.991900e-01  1.008190e+00  1.020930e+00  1.101270e+00  1.147870e+00 "
     sigma_s = " 1.025090e-01  0  0  0  0  0  0  0 ;
                 4.388880e-02  1.699010e-01  0  0  0  0  0  0 ;
                 2.482760e-02  9.434090e-02  4.699070e-01  0  0  0  0  0 ;
                 1.814310e-04  7.600470e-04  6.856490e-02  7.031430e-01  0  0  0  0 ;
                 8.196640e-07  7.963690e-06  9.351700e-04  1.319340e-01  6.827450e-01  0  0  0 ;
                 0  0  2.238810e-05  3.371760e-03  1.351470e-01  5.926170e-01  6.046610e-03  0 ;
                 0  0  0  4.893440e-04  1.909200e-02  2.118590e-01  7.358420e-01  1.167770e-01 ;
                 0  0  0  1.306930e-04  5.803870e-03  4.256010e-02  2.977620e-01  1.431060e+00 "
     block =  12 
     []
[]
