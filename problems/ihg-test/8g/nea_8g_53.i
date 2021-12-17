[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '53'
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
     [u45_0015_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 2.960516e+00  2.009679e+00  1.167960e+00  7.643454e-01  7.299856e-01  7.369495e-01  5.172963e-01  2.713336e-01 "
     sigma_t = " 1.769465e-01  2.664438e-01  5.392138e-01  8.532080e-01  9.103308e-01  8.962129e-01  1.126205e+00  1.736871e+00 "
     nu_sigma_f = " 1.160820e-02  4.963080e-03  1.136740e-03  6.944220e-03  2.530240e-02  2.604170e-02  1.081670e-01  2.303110e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.376840e-13  6.356260e-14  1.506030e-14  9.246110e-14  3.368770e-13  3.467380e-13  1.439430e-12  3.066290e-12 "
     adf = " 1.043400e+00  1.051030e+00  1.044480e+00  1.057470e+00  1.127280e+00  1.203020e+00  1.310100e+00  1.442300e+00 "
     sigma_s = " 1.026950e-01  0  0  0  0  0  0  0 ;
                 4.450850e-02  1.694760e-01  0  0  0  0  0  0 ;
                 2.458510e-02  9.352400e-02  4.675360e-01  0  0  0  0  0 ;
                 1.786640e-04  7.444620e-04  6.777660e-02  7.003600e-01  0  0  0  0 ;
                 8.105630e-07  7.797760e-06  9.210660e-04  1.283140e-01  6.803490e-01  0  0  0 ;
                 0  0  2.206470e-05  3.271740e-03  1.314700e-01  5.787820e-01  4.838710e-03  0 ;
                 0  0  0  4.748270e-04  1.855810e-02  2.150010e-01  7.186150e-01  1.192240e-01 ;
                 0  0  0  1.266200e-04  5.641590e-03  4.310960e-02  2.936940e-01  1.423110e+00 "
     block =  53 
     []
[]
