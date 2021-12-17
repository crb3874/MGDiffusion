[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '9'
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
     [m40_2250]
     type = MultigroupXSMaterial
     diffusivity = " 2.763339e+00  1.948247e+00  1.160203e+00  7.719373e-01  7.461428e-01  7.497393e-01  4.934653e-01  2.675227e-01 "
     sigma_t = " 1.767440e-01  2.678662e-01  5.415889e-01  8.506207e-01  8.914633e-01  9.092597e-01  1.243246e+00  1.739431e+00 "
     nu_sigma_f = " 1.201580e-02  5.330600e-03  9.384250e-04  4.266490e-03  2.585490e-02  1.317370e-02  3.065660e-01  2.470800e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.403700e-13  6.621080e-14  1.095590e-14  5.034960e-14  3.052320e-13  1.555310e-13  3.620510e-12  2.910060e-12 "
     adf = " 9.905500e-01  9.866900e-01  9.943400e-01  1.000270e+00  1.007810e+00  1.017910e+00  1.101850e+00  1.156810e+00 "
     sigma_s = " 1.027100e-01  0  0  0  0  0  0  0 ;
                 4.402510e-02  1.700380e-01  0  0  0  0  0  0 ;
                 2.491950e-02  9.446680e-02  4.702850e-01  0  0  0  0  0 ;
                 1.816130e-04  7.601310e-04  6.840660e-02  7.033610e-01  0  0  0  0 ;
                 8.208320e-07  7.963810e-06  9.329830e-04  1.318700e-01  6.805490e-01  0  0  0 ;
                 0  0  2.233040e-05  3.370260e-03  1.356160e-01  5.912540e-01  6.341240e-03  0 ;
                 0  0  0  4.891140e-04  1.915140e-02  2.117110e-01  7.402700e-01  1.175860e-01 ;
                 0  0  0  1.306230e-04  5.821940e-03  4.252070e-02  2.960510e-01  1.435210e+00 "
     block =  9 
     []
[]
