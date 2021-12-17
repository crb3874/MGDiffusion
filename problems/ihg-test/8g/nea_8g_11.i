[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '11'
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
     [u45_1750]
     type = MultigroupXSMaterial
     diffusivity = " 2.731144e+00  1.944077e+00  1.173688e+00  7.728107e-01  7.467697e-01  7.602938e-01  5.096170e-01  2.732554e-01 "
     sigma_t = " 1.752094e-01  2.665915e-01  5.449880e-01  8.687094e-01  9.071216e-01  8.918142e-01  1.152533e+00  1.725109e+00 "
     nu_sigma_f = " 1.136000e-02  4.839940e-03  8.755020e-04  5.092480e-03  2.085950e-02  1.737620e-02  1.448220e-01  1.867820e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.345130e-13  6.163500e-14  1.131950e-14  6.659880e-14  2.700730e-13  2.272040e-13  1.802890e-12  2.410920e-12 "
     adf = " 9.992800e-01  1.001200e+00  1.007480e+00  1.004000e+00  9.961500e-01  9.871400e-01  9.611700e-01  9.356100e-01 "
     sigma_s = " 1.003710e-01  0  0  0  0  0  0  0 ;
                 4.460500e-02  1.664670e-01  0  0  0  0  0  0 ;
                 2.530390e-02  9.686510e-02  4.712940e-01  0  0  0  0  0 ;
                 1.899080e-04  7.904730e-04  7.077870e-02  7.157450e-01  0  0  0  0 ;
                 8.630690e-07  8.282040e-06  9.667130e-04  1.374040e-01  6.914320e-01  0  0  0 ;
                 0  0  2.312810e-05  3.515980e-03  1.422070e-01  5.885750e-01  4.646580e-03  0 ;
                 0  0  0  5.102740e-04  2.010180e-02  2.247950e-01  7.307570e-01  1.199830e-01 ;
                 0  0  0  1.362670e-04  6.110800e-03  4.509860e-02  3.203080e-01  1.468030e+00 "
     block =  11 
     []
[]
