[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '21.42'
    dy = '21.42'
    ix = '4'
    iy = '4'
    subdomain_id = '6'
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
     [u42_3250]
     type = MultigroupXSMaterial
     diffusivity = " 1.722297e+00  7.625584e-01  7.557259e-01  3.647604e-01 "
     sigma_t = " 3.979972e-01  8.838216e-01  9.019946e-01  1.489544e+00 "
     nu_sigma_f = " 3.804230e-03  8.477430e-03  1.120680e-02  1.440550e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.629340e-14  1.073540e-13  1.436450e-13  1.788780e-12 "
     adf = " 1.003780e+00  1.000880e+00  9.869800e-01  9.418100e-01 "
     sigma_s = " 3.562570e-01  0  0  0 ;
                 3.918720e-02  7.898850e-01  0  0 ;
                 1.256500e-05  5.816370e-02  5.911540e-01  1.744060e-03 ;
                 0  1.072250e-02  2.694110e-01  1.376150e+00 "
     block =  6 
     []
[]
