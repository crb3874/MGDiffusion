[Mesh]
  [Mesh]
	type = CartesianMeshGenerator
	dim = 2
	dx = 50
	dy = 50
	ix = 40
	iy = 40
	subdomain_id = 0
  []
[]

[Variables]
  [scalar_flux]
    order = FIRST
    family = LAGRANGE
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

[BCs]
  [bottom]
    type = ArrayDirichletBC
    variable = scalar_flux
    boundary = 0
    values = '0 0 0 0'
  []

  [right]
    type = ArrayDirichletBC
    variable = scalar_flux
    boundary = 1
    values = '0 0 0 0'
  []

  [top]
    type = ArrayDirichletBC
    variable = scalar_flux
    boundary = 2
    values = '0 0 0 0'
  []

  [left]
    type = ArrayDirichletBC
    variable = scalar_flux
    boundary = 3
    values = '0 0 0 0'
  []

[]

[Materials]
  [XSMat0]
    type = MultigroupXSMaterial
    diffusivity = ' 0.667 0.2667 0.3333 0.3704 '
    sigma_t = ' 0.50 1.25 1.00 0.90 '
    nu_sigma_f = ' 0.05 0.00 1.25 1.50 '
    chi = ' 0.95 0.05 0.00 0.00 '
    kappa_sigma_f = ' 1 1 1 1 '
    adf = ' 1 1 1 1 '
    sigma_s = '0.05 0.00 0.00 0.00;
	       0.05 0.10 0.00 0.00;
	       0.25 0.10 0.20 0.20;
 	       0.00 0.00 0.20 0.20 '
    block = 0
  []

[]

[Executioner]
  type = Eigenvalue
  solve_type = 'NEWTON'
  free_power_iterations = 4
  nl_abs_tol = 1e-10
  nl_max_its = 1000

  line_search = none

  l_abs_tol = 1e-10

[]

[Outputs]
  exodus = true
[]