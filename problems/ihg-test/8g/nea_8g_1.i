[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '1'
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
     [u42_0015]
     type = MultigroupXSMaterial
     diffusivity = " 2.711328e+00  1.932132e+00  1.169689e+00  7.721072e-01  7.511466e-01  7.675381e-01  5.219302e-01  2.720089e-01 "
     sigma_t = " 1.759876e-01  2.671887e-01  5.455515e-01  8.692729e-01  9.018770e-01  8.791019e-01  1.119846e+00  1.743223e+00 "
     nu_sigma_f = " 1.150510e-02  4.925680e-03  1.058170e-03  6.479490e-03  2.317390e-02  2.370820e-02  9.806210e-02  2.028350e-01 "
     chi = " 3.723410e-01  4.037190e-01  2.236200e-01  3.199790e-04  0  0  0  0 "
     kappa_sigma_f = " 1.366850e-13  6.308990e-14  1.401720e-14  8.627260e-14  3.085330e-13  3.156650e-13  1.304880e-12  2.700440e-12 "
     adf = " 1.007950e+00  1.012460e+00  1.016170e+00  1.009370e+00  1.001760e+00  9.984000e-01  9.983900e-01  1.006580e+00 "
     sigma_s = " 1.006000e-01  0  0  0  0  0  0  0 ;
                 4.488910e-02  1.667340e-01  0  0  0  0  0  0 ;
                 2.550880e-02  9.714010e-02  4.718860e-01  0  0  0  0  0 ;
                 1.906280e-04  7.910480e-04  7.064520e-02  7.159310e-01  0  0  0  0 ;
                 8.689540e-07  8.288070e-06  9.648860e-04  1.372510e-01  6.871150e-01  0  0  0 ;
                 0  0  2.307990e-05  3.511950e-03  1.431130e-01  5.840690e-01  4.357950e-03  0 ;
                 0  0  0  5.096900e-04  2.022270e-02  2.261460e-01  7.269410e-01  1.217050e-01 ;
                 0  0  0  1.360920e-04  6.147570e-03  4.535330e-02  3.161740e-01  1.468660e+00 "
     block =  1 
     []
[]
