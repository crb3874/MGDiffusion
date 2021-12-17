[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '5'
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
     [m43_1750]
     type = MultigroupXSMaterial
     diffusivity = " 2.741115e+00  1.939744e+00  1.158920e+00  7.714889e-01  7.459675e-01  7.504414e-01  4.897783e-01  2.625499e-01 "
     sigma_t = " 1.769431e-01  2.679635e-01  5.415750e-01  8.511053e-01  8.919677e-01  9.082876e-01  1.270890e+00  1.772495e+00 "
     nu_sigma_f = " 1.223180e-02  5.532830e-03  1.104690e-03  4.950300e-03  2.884530e-02  1.566930e-02  3.431640e-01  2.828390e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.426030e-13  6.846120e-14  1.288960e-14  5.844700e-14  3.409180e-13  1.850650e-13  4.054710e-12  3.333020e-12 "
     adf = " 9.892400e-01  9.852000e-01  9.935300e-01  1.000870e+00  1.012180e+00  1.026230e+00  1.148910e+00  1.244070e+00 "
     sigma_s = " 1.027830e-01  0  0  0  0  0  0  0 ;
                 4.405870e-02  1.700560e-01  0  0  0  0  0  0 ;
                 2.494860e-02  9.448250e-02  4.703400e-01  0  0  0  0  0 ;
                 1.817190e-04  7.601100e-04  6.828090e-02  7.036840e-01  0  0  0  0 ;
                 8.214400e-07  7.962900e-06  9.312190e-04  1.316920e-01  6.800480e-01  0  0  0 ;
                 0  0  2.228460e-05  3.365750e-03  1.356240e-01  5.912950e-01  6.728300e-03  0 ;
                 0  0  0  4.884710e-04  1.915070e-02  2.113920e-01  7.471680e-01  1.191040e-01 ;
                 0  0  0  1.304310e-04  5.821640e-03  4.246910e-02  2.937850e-01  1.444080e+00 "
     block =  5 
     []
[]
