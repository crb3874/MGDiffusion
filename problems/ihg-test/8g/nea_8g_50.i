[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '50'
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
     [u42_3500_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 3.155550e+00  2.082969e+00  1.181091e+00  7.662994e-01  7.253204e-01  7.256157e-01  5.019264e-01  2.770597e-01 "
     sigma_t = " 1.749950e-01  2.651783e-01  5.389080e-01  8.513550e-01  9.157100e-01  9.203107e-01  1.160351e+00  1.682778e+00 "
     nu_sigma_f = " 1.127620e-02  4.647250e-03  6.006760e-04  3.290380e-03  1.595870e-02  1.086350e-02  1.449170e-01  1.510040e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.327510e-13  5.898840e-14  7.558000e-15  4.201580e-14  2.006020e-13  1.387840e-13  1.757090e-12  1.891620e-12 "
     adf = " 1.036520e+00  1.042120e+00  1.037480e+00  1.052800e+00  1.122520e+00  1.195580e+00  1.285550e+00  1.366590e+00 "
     sigma_s = " 1.022530e-01  0  0  0  0  0  0  0 ;
                 4.366730e-02  1.690000e-01  0  0  0  0  0  0 ;
                 2.405510e-02  9.289060e-02  4.667480e-01  0  0  0  0  0 ;
                 1.760350e-04  7.422980e-04  6.850180e-02  6.991810e-01  0  0  0  0 ;
                 7.894430e-07  7.774210e-06  9.309340e-04  1.290190e-01  6.861940e-01  0  0  0 ;
                 0  0  2.232580e-05  3.289540e-03  1.305160e-01  5.856580e-01  5.027730e-03  0 ;
                 0  0  0  4.774080e-04  1.843520e-02  2.131000e-01  7.191800e-01  1.149670e-01 ;
                 0  0  0  1.273930e-04  5.604240e-03  4.275110e-02  3.005900e-01  1.413480e+00 "
     block =  50 
     []
[]
