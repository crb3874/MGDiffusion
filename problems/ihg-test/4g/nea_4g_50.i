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
    components = 4
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
    value = '0 0 0 0'
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
     diffusivity = " 1.808420e+00  7.511873e-01  7.256157e-01  3.725369e-01 "
     sigma_t = " 3.963632e-01  8.751284e-01  9.203116e-01  1.460943e+00 "
     nu_sigma_f = " 3.784970e-03  7.962990e-03  1.086350e-02  1.484190e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.589570e-14  1.005090e-13  1.387840e-13  1.834500e-12 "
     adf = " 1.038450e+00  1.078520e+00  1.195580e+00  1.332180e+00 "
     sigma_s = " 3.551050e-01  0  0  0 ;
                 3.814810e-02  7.758590e-01  0  0 ;
                 1.219630e-05  5.021590e-02  5.856580e-01  2.134760e-03 ;
                 0  9.248430e-03  2.558520e-01  1.312450e+00 "
     block =  50 
     []
[]
