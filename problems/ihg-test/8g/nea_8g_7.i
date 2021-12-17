[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '7'
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
     [u42_1750]
     type = MultigroupXSMaterial
     diffusivity = " 2.743575e+00  1.949398e+00  1.174408e+00  7.729988e-01  7.475233e-01  7.609082e-01  5.094083e-01  2.744433e-01 "
     sigma_t = " 1.751913e-01  2.665816e-01  5.451258e-01  8.684119e-01  9.059899e-01  8.915371e-01  1.150005e+00  1.716323e+00 "
     nu_sigma_f = " 1.133070e-02  4.795720e-03  8.099590e-04  4.690170e-03  1.948950e-02  1.596800e-02  1.397890e-01  1.756770e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.341600e-13  6.107070e-14  1.044960e-14  6.123200e-14  2.517450e-13  2.084350e-13  1.735020e-12  2.261920e-12 "
     adf = " 9.993400e-01  1.001300e+00  1.007560e+00  1.004090e+00  9.963700e-01  9.874600e-01  9.613500e-01  9.362300e-01 "
     sigma_s = " 1.003780e-01  0  0  0  0  0  0  0 ;
                 4.459920e-02  1.664790e-01  0  0  0  0  0  0 ;
                 2.529540e-02  9.686070e-02  4.713800e-01  0  0  0  0  0 ;
                 1.898240e-04  7.903940e-04  7.085800e-02  7.155580e-01  0  0  0  0 ;
                 8.624650e-07  8.281290e-06  9.678160e-04  1.375170e-01  6.910540e-01  0  0  0 ;
                 0  0  2.315660e-05  3.518800e-03  1.423500e-01  5.884840e-01  4.569520e-03  0 ;
                 0  0  0  5.106860e-04  2.012160e-02  2.248160e-01  7.293500e-01  1.194100e-01 ;
                 0  0  0  1.363890e-04  6.116840e-03  4.509860e-02  3.217270e-01  1.465580e+00 "
     block =  7 
     []
[]
