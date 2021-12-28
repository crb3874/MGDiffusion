[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 3
    dx = '10.71 10.71'
    dy = '10.71 10.71'
    dz = '30 300 30'
    ix = '2 2'
    iy = '2 2'
    iz = '2 30 2'
    subdomain_id = '99 99
		    99 99

		     1  1
		     1  1
		    
		    99 99
		    99 99'
  []
[]

[Variables]
  [scalar_flux]
    order = FIRST
    family = L2_LAGRANGE
    components = 2
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
  [VacuumBoundaries]
    type = ArrayPenaltyDirichletBC
    variable = scalar_flux
    boundary = '0 1 2 3 4 5'
    value = '0 0'
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

[AuxVariables]
# store reaction rate (fission power)
  [kappa_fission_phi]
# [q_triple_prime]
    family = L2_LAGRANGE
    order = FIRST
  []
[]

[AuxKernels]
  [compute_kappa_fission_phi]
    type = ReactionRateAux
    variable = kappa_fission_phi
    scalar_flux_variable = scalar_flux
    cross_section = kappa_sigma_f
  []
[]

[UserObjects]
# Computes layered averages axially of kappa sigma f
  [integrate_kappa_fission_by_layer]
    type = LayeredIntegral
    direction = z
    num_layers = 20
    variable = kappa_fission_phi
#   variable = q_triple_prime
    execute_on = timestep_end
    cumulative = true
    positive_cumulative_direction = true
  []

[]

[VectorPostprocessors]
# output axial power integral
  [axial_power_out]
    type = SpatialUserObjectVectorPostprocessor
    userobject = integrate_kappa_fission_by_layer
  []
[]

[Outputs]
  file_base = 'temp_profile'
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
     diffusivity = " 1.373845e+00  3.792145e-01 "
     sigma_t = " 5.577729e-01  1.473914e+00 "
     nu_sigma_f = " 7.625890e-03  1.578920e-01 "
     chi = " 1  0 "
     kappa_sigma_f = " 9.889730e-14  2.101800e-12 "
     adf = " 1.010790e+00  1.003070e+00 "
     sigma_s = " 5.303440e-01  0 ;
                 1.748660e-02  1.355580e+00 "
     block =  1 
     []
     [reflector]
     type = MultigroupXSMaterial
     diffusivity = " 1.104166e+00  2.719601e-01 "
     sigma_t = " 6.700725e-01  2.027498e+00 "
     nu_sigma_f = " 0  0 "
     chi = " 1  0 "
     kappa_sigma_f = " 0  0 "
     adf = " 1.176390e+00  2.275500e-01 "
     sigma_s = " 6.401210e-01  0 ;
                 2.752620e-02  1.990260e+00 "
     block =  99 
     []
[]








