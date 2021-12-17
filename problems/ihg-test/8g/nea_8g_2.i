[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '2'
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
     [u42_2250]
     type = MultigroupXSMaterial
     diffusivity = " 2.770229e+00  1.961073e+00  1.176567e+00  7.731961e-01  7.466877e-01  7.590144e-01  5.075823e-01  2.750457e-01 "
     sigma_t = " 1.749630e-01  2.664182e-01  5.451711e-01  8.682250e-01  9.069069e-01  8.954409e-01  1.153178e+00  1.710719e+00 "
     nu_sigma_f = " 1.127530e-02  4.754150e-03  7.446060e-04  4.248150e-03  1.836800e-02  1.418890e-02  1.416910e-01  1.658260e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.334080e-13  6.047600e-14  9.538850e-15  5.513400e-14  2.353700e-13  1.841460e-13  1.744250e-12  2.117970e-12 "
     adf = " 9.989600e-01  1.000860e+00  1.007250e+00  1.003940e+00  9.962600e-01  9.871200e-01  9.595600e-01  9.332500e-01 "
     sigma_s = " 1.003100e-01  0  0  0  0  0  0  0 ;
                 4.451790e-02  1.664140e-01  0  0  0  0  0  0 ;
                 2.523720e-02  9.678230e-02  4.713030e-01  0  0  0  0  0 ;
                 1.895980e-04  7.901660e-04  7.100760e-02  7.153940e-01  0  0  0  0 ;
                 8.607200e-07  8.278920e-06  9.698470e-04  1.376330e-01  6.918430e-01  0  0  0 ;
                 0  0  2.321060e-05  3.521840e-03  1.422500e-01  5.895790e-01  4.563960e-03  0 ;
                 0  0  0  5.111270e-04  2.010850e-02  2.245880e-01  7.291900e-01  1.189420e-01 ;
                 0  0  0  1.365210e-04  6.112920e-03  4.505840e-02  3.228130e-01  1.464420e+00 "
     block =  2 
     []
[]
