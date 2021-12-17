[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '52'
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
     [u45_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.149557e+00  2.081213e+00  1.181183e+00  7.662906e-01  7.245007e-01  7.245857e-01  5.013858e-01  2.762996e-01 "
     sigma_t = " 1.749251e-01  2.651103e-01  5.387476e-01  8.514874e-01  9.169708e-01  9.216443e-01  1.163386e+00  1.687861e+00 "
     nu_sigma_f = " 1.126590e-02  4.663430e-03  6.269200e-04  3.438540e-03  1.661990e-02  1.131760e-02  1.491850e-01  1.565660e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.326160e-13  5.917150e-14  7.891650e-15  4.392470e-14  2.089960e-13  1.446410e-13  1.809530e-12  1.962220e-12 "
     adf = " 1.036090e+00  1.041590e+00  1.037070e+00  1.052520e+00  1.122300e+00  1.195380e+00  1.284740e+00  1.365650e+00 "
     sigma_s = " 1.022040e-01  0  0  0  0  0  0  0 ;
                 4.365830e-02  1.689550e-01  0  0  0  0  0  0 ;
                 2.404590e-02  9.286230e-02  4.666030e-01  0  0  0  0  0 ;
                 1.761000e-04  7.422970e-04  6.847560e-02  6.992400e-01  0  0  0  0 ;
                 7.900360e-07  7.774270e-06  9.305840e-04  1.289580e-01  6.867710e-01  0  0  0 ;
                 0  0  2.231650e-05  3.288040e-03  1.303550e-01  5.859450e-01  5.080830e-03  0 ;
                 0  0  0  4.771900e-04  1.841350e-02  2.130460e-01  7.200980e-01  1.152630e-01 ;
                 0  0  0  1.273280e-04  5.597650e-03  4.274470e-02  2.999110e-01  1.414680e+00 "
     block =  52 
     []
[]
