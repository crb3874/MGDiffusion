[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '57'
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
     [u42_1750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.763006e+00  7.514040e-01  7.312700e-01  3.767449e-01 "
     sigma_t = " 3.977927e-01  8.744955e-01  9.081183e-01  1.460849e+00 "
     nu_sigma_f = " 3.922700e-03  1.029390e-02  1.640630e-02  1.689740e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.794540e-14  1.333950e-13  2.141680e-13  2.145740e-12 "
     adf = " 1.038740e+00  1.078420e+00  1.193960e+00  1.334430e+00 "
     sigma_s = " 3.565420e-01  0  0  0 ;
                 3.807520e-02  7.753740e-01  0  0 ;
                 1.216390e-05  5.013190e-02  5.827430e-01  2.236490e-03 ;
                 0  9.230020e-03  2.564800e-01  1.306580e+00 "
     block =  57 
     []
[]
