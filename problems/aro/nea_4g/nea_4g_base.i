[Mesh]
  [QuarterCore]
    type = CartesianMeshGenerator
    dim = 2
    dx = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    dy = '10.71 21.42 21.42 21.42 21.42 21.42 21.42 21.42 21.42'
    ix = '1 1 1 1 1 1 1 1 1'
    iy = '1 1 1 1 1 1 1 1 1'
    subdomain_id = '50  1 51  3 52  5 53  6 99
  		     1  7  8  9  1 54 10 11 99
 		    51  8 51  1  2  5 53 12 99
  		     3  9  1 13  1 55 15 14 99
		    52  1  2  1 56  3 57 99 99
 		     5 54  5 55  3 15  8 99 99
 		    53 10 53 15 57  8 99 99 99
  		     6 11 12 14 99 99 99 99 99
 		    99 99 99 99 99 99 99 99 99'
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
  [VacuumBoundaries]
    type = ArrayPenaltyDirichletBC
    variable = scalar_flux
    boundary = '1 2'
    value = '0 0 0 0'
  []

  [ReflectingBoundaries]
    type = ArrayNeumannBC
    variable = scalar_flux
    boundary = '1 2'
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

[AuxVariables]
# copy array variable components
  [flux_0]
    family = L2_LAGRANGE
    order = FIRST
  []
  [flux_1]
    family = L2_LAGRANGE
    order = FIRST
  []
  [flux_2]
    family = L2_LAGRANGE
    order = FIRST
  []
  [flux_3]
    family = L2_LAGRANGE
    order = FIRST
  []
# store integrated flux over each element
  [integrated_flux_0]
    family = MONOMIAL
    order = CONSTANT
  []
  [integrated_flux_1]
    family = MONOMIAL
    order = CONSTANT
  []
  [integrated_flux_2]
    family = MONOMIAL
    order = CONSTANT
  []
  [integrated_flux_3]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [copy_flux_0]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_0
    component = 0 
  []
  [copy_flux_1]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_1
    component = 1 
  []
  [copy_flux_2]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_2
    component = 2 
  []
  [copy_flux_3]
    type = ArrayVariableComponent
    array_variable = scalar_flux
    variable = flux_3
    component = 3 
  []
  [integrate_flux_0] 
    type = ElementLpNormAux
    variable = integrated_flux_0
    coupled_variable = flux_0
    p = 1
  []
  [integrate_flux_1] 
    type = ElementLpNormAux
    variable = integrated_flux_1
    coupled_variable = flux_1
    p = 1
  []
  [integrate_flux_2] 
    type = ElementLpNormAux
    variable = integrated_flux_2
    coupled_variable = flux_2
    p = 1
  []
  [integrate_flux_3] 
    type = ElementLpNormAux
    variable = integrated_flux_3
    coupled_variable = flux_3
    p = 1
  []
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

[VectorPostprocessors]
  [flux_sampler]
    type = ElementValueSampler
    variable = 'integrated_flux_0 integrated_flux_1 integrated_flux_2 integrated_flux_3'
    sort_by = id
    execute_on = 'TIMESTEP_END'
  []
[]

[Outputs]
  file_base = 'flux_sampler'
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
     diffusivity = " 1.671866e+00  7.639005e-01  7.675381e-01  3.792145e-01 "
     sigma_t = " 4.000521e-01  8.820856e-01  8.791016e-01  1.475783e+00 "
     nu_sigma_f = " 4.120200e-03  1.301570e-02  2.370820e-02  1.578920e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.093270e-14  1.732930e-13  3.156650e-13  2.101800e-12 "
     adf = " 1.013590e+00  1.006390e+00  9.984000e-01  1.003070e+00 "
     sigma_s = " 3.583180e-01  0  0  0 ;
                 3.902060e-02  7.882090e-01  0  0 ;
                 1.249820e-05  5.817040e-02  5.840690e-01  1.869370e-03 ;
                 0  1.071750e-02  2.714990e-01  1.355580e+00 "
     block =  1 
     []
     [u42_2250]
     type = MultigroupXSMaterial
     diffusivity = " 1.700845e+00  7.627817e-01  7.590144e-01  3.672075e-01 "
     sigma_t = " 3.982000e-01  8.834253e-01  8.954415e-01  1.489750e+00 "
     nu_sigma_f = " 3.902790e-03  9.796480e-03  1.418890e-02  1.562600e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.767190e-14  1.259570e-13  1.841460e-13  1.969850e-12 "
     adf = " 1.003920e+00  1.000920e+00  9.871200e-01  9.436800e-01 "
     sigma_s = " 3.565980e-01  0  0  0 ;
                 3.900730e-02  7.896920e-01  0  0 ;
                 1.250070e-05  5.803350e-02  5.895790e-01  1.808840e-03 ;
                 0  1.069660e-02  2.696470e-01  1.372770e+00 "
     block =  2 
     []
     [u45_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.667776e+00  7.635296e-01  7.665514e-01  3.798268e-01 "
     sigma_t = " 3.998393e-01  8.826222e-01  8.802297e-01  1.478904e+00 "
     nu_sigma_f = " 4.183360e-03  1.385290e-02  2.534100e-02  1.667230e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.174900e-14  1.844410e-13  3.374080e-13  2.219420e-12 "
     adf = " 1.013090e+00  1.006040e+00  9.978500e-01  1.000580e+00 "
     sigma_s = " 3.581610e-01  0  0  0 ;
                 3.893910e-02  7.885640e-01  0  0 ;
                 1.247030e-05  5.791260e-02  5.844560e-01  1.928070e-03 ;
                 0  1.067020e-02  2.713890e-01  1.354480e+00 "
     block =  3 
     []
     [m43_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.681311e+00  7.616419e-01  7.504414e-01  3.681854e-01 "
     sigma_t = " 3.968802e-01  8.669078e-01  9.082875e-01  1.539310e+00 "
     nu_sigma_f = " 4.503020e-03  1.416870e-02  1.566930e-02  3.108840e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.353020e-14  1.674210e-13  1.850650e-13  3.668540e-12 "
     adf = " 9.905000e-01  1.005230e+00  1.026230e+00  1.199830e+00 "
     sigma_s = " 3.565980e-01  0  0  0 ;
                 3.749890e-02  7.754920e-01  0  0 ;
                 1.199940e-05  5.438790e-02  5.912950e-01  3.127950e-03 ;
                 0  1.001420e-02  2.538610e-01  1.320410e+00 "
     block =  5 
     []
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
     [u42_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.690734e+00  7.630017e-01  7.609082e-01  3.687768e-01 "
     sigma_t = " 3.983135e-01  8.832567e-01  8.915335e-01  1.488943e+00 "
     nu_sigma_f = " 3.955240e-03  1.049640e-02  1.596800e-02  1.612680e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.841610e-14  1.359770e-13  2.084350e-13  2.050380e-12 "
     adf = " 1.004280e+00  1.001060e+00  9.874600e-01  9.463200e-01 "
     sigma_s = " 3.567720e-01  0  0  0 ;
                 3.892350e-02  7.896110e-01  0  0 ;
                 1.247090e-05  5.798630e-02  5.884840e-01  1.834580e-03 ;
                 0  1.068760e-02  2.699110e-01  1.370620e+00 "
     block =  7 
     []
     [u45_3250]
     type = MultigroupXSMaterial
     diffusivity = " 1.716753e+00  7.622323e-01  7.553287e-01  3.655444e-01 "
     sigma_t = " 3.978796e-01  8.843505e-01  9.019895e-01  1.492143e+00 "
     nu_sigma_f = " 3.847670e-03  9.149270e-03  1.234390e-02  1.522730e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "

     kappa_sigma_f = " 4.686120e-14  1.163010e-13  1.587380e-13  1.897580e-12 "
     adf = " 1.003620e+00  1.000720e+00  9.866000e-01  9.410300e-01 "
     sigma_s = " 3.561870e-01  0  0  0 ;
                 3.912190e-02  7.902900e-01  0  0 ;
                 1.254230e-05  5.793210e-02  5.912050e-01  1.802800e-03 ;
                 0  1.068030e-02  2.693650e-01  1.374670e+00 "
     block =  8 
     []
     [m40_2250]
     type = MultigroupXSMaterial
     diffusivity = " 1.687430e+00  7.619379e-01  7.497393e-01  3.688421e-01 "
     sigma_t = " 3.971831e-01  8.664344e-01  9.092570e-01  1.516915e+00 "
     nu_sigma_f = " 4.309350e-03  1.263620e-02  1.317370e-02  2.737560e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.135700e-14  1.491660e-13  1.555310e-13  3.228660e-12 "
     adf = " 9.916000e-01  1.003190e+00  1.017910e+00  1.132170e+00 "
     sigma_s = " 3.568150e-01  0  0  0 ;
                 3.764740e-02  7.752400e-01  0  0 ;
                 1.205050e-05  5.464140e-02  5.912540e-01  2.843640e-03 ;
                 0  1.006200e-02  2.542290e-01  1.321180e+00 "
     block =  9 
     []
     [m40_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.666017e+00  7.629371e-01  7.590525e-01  3.677301e-01 "
     sigma_t = " 3.966085e-01  8.651341e-01  8.907213e-01  1.574614e+00 "
     nu_sigma_f = " 4.742390e-03  1.520720e-02  2.019210e-02  3.678160e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.629100e-14  1.803650e-13  2.389990e-13  4.346910e-12 "
     adf = " 9.995600e-01  1.010770e+00  1.040850e+00  1.257080e+00 "
     sigma_s = " 3.565400e-01  0  0  0 ;
                 3.720010e-02  7.739630e-01  0  0 ;
                 1.189670e-05  5.461320e-02  5.854290e-01  3.569550e-03 ;
                 0  1.004840e-02  2.550120e-01  1.319850e+00 "
     block =  10 
     []
     [u45_1750]
     type = MultigroupXSMaterial
     diffusivity = " 1.686500e+00  7.626247e-01  7.602938e-01  3.696368e-01 "
     sigma_t = " 3.981978e-01  8.837433e-01  8.918206e-01  1.491598e+00 "
     nu_sigma_f = " 4.007740e-03  1.125800e-02  1.737620e-02  1.696720e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.910150e-14  1.461660e-13  2.272040e-13  2.162990e-12 "
     adf = " 1.004200e+00  1.000940e+00  9.871400e-01  9.460300e-01 "
     sigma_s = " 3.566940e-01  0  0  0 ;
                 3.886390e-02  7.899250e-01  0  0 ;
                 1.245010e-05  5.774880e-02  5.885750e-01  1.894750e-03 ;
                 0  1.064410e-02  2.699000e-01  1.369030e+00 "
     block =  11 
     []
     [m43_3500]
     type = MultigroupXSMaterial
     diffusivity = " 1.697804e+00  7.612105e-01  7.444248e-01  3.686891e-01 "
     sigma_t = " 3.972129e-01  8.676725e-01  9.167262e-01  1.504467e+00 "
     nu_sigma_f = " 4.203780e-03  1.218320e-02  1.180230e-02  2.506620e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.010690e-14  1.434700e-13  1.390220e-13  2.952170e-12 "
     adf = " 9.890700e-01  1.002680e+00  1.020930e+00  1.127420e+00 "
     sigma_s = " 3.567100e-01  0  0  0 ;
                 3.781370e-02  7.760970e-01  0  0 ;
                 1.210740e-05  5.439850e-02  5.926170e-01  2.653830e-03 ;
                 0  1.002070e-02  2.544200e-01  1.322150e+00 "
     block =  12 
     []
     [m40_3750]
     type = MultigroupXSMaterial
     diffusivity = " 1.704289e+00  7.616436e-01  7.447957e-01  3.692454e-01 "
     sigma_t = " 3.975202e-01  8.670453e-01  9.157996e-01  1.490086e+00 "
     nu_sigma_f = " 4.075060e-03  1.092280e-02  1.028340e-02  2.242660e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.866320e-14  1.285500e-13  1.210770e-13  2.640120e-12 "
     adf = " 9.917000e-01  1.001980e+00  1.015310e+00  1.080690e+00 "
     sigma_s = " 3.569230e-01  0  0  0 ;
                 3.794830e-02  7.756310e-01  0  0 ;
                 1.215260e-05  5.469060e-02  5.919220e-01  2.462640e-03 ;
                 0  1.007420e-02  2.548770e-01  1.322780e+00 "
     block =  13 
     []
     [u45_2000]
     type = MultigroupXSMaterial
     diffusivity = " 1.691240e+00  7.625287e-01  7.593654e-01  3.687997e-01 "
     sigma_t = " 3.981301e-01  8.839560e-01  8.937673e-01  1.492100e+00 "
     nu_sigma_f = " 3.979990e-03  1.089200e-02  1.641650e-02  1.673140e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.870820e-14  1.409210e-13  2.140950e-13  2.124020e-12 "
     adf = " 1.003970e+00  1.000820e+00  9.869000e-01  9.443600e-01 "
     sigma_s = " 3.566000e-01  0  0  0 ;
                 3.890270e-02  7.901050e-01  0  0 ;
                 1.246390e-05  5.776950e-02  5.891390e-01  1.882310e-03 ;
                 0  1.064840e-02  2.697500e-01  1.370190e+00 "
     block =  14 
     []
     [m43_0015]
     type = MultigroupXSMaterial
     diffusivity = " 1.664096e+00  7.624712e-01  7.579082e-01  3.669326e-01 "
     sigma_t = " 3.964283e-01  8.657952e-01  8.927074e-01  1.584393e+00 "
     nu_sigma_f = " 4.856290e-03  1.616830e-02  2.162660e-02  3.839990e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.754680e-14  1.916910e-13  2.558540e-13  4.537550e-12 "
     adf = " 9.972300e-01  1.011560e+00  1.046060e+00  1.294330e+00 "
     sigma_s = " 3.563800e-01  0  0  0 ;
                 3.714370e-02  7.743890e-01  0  0 ;
                 1.187740e-05  5.437560e-02  5.861220e-01  3.659960e-03 ;
                 0  1.000530e-02  2.547400e-01  1.320910e+00 "
     block =  15 
     []
     [u42_3500_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.727814e+00  7.625444e-01  7.549848e-01  3.642478e-01 "
     sigma_t = " 3.979457e-01  8.839193e-01  9.034195e-01  1.489229e+00 "
     nu_sigma_f = " 3.781540e-03  8.167800e-03  1.056660e-02  1.407960e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.597830e-14  1.030380e-13  1.349870e-13  1.742240e-12 "
     adf = " 1.003790e+00  1.000900e+00  9.869800e-01  9.416200e-01 "
     sigma_s = " 3.561700e-01  0  0  0 ;
                 3.923200e-02  7.899320e-01  0  0 ;
                 1.258070e-05  5.819660e-02  5.914510e-01  1.725950e-03 ;
                 0  1.072930e-02  2.693920e-01  1.376870e+00 "
     block =  50 
     []
     [u42_2250_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.700845e+00  7.627817e-01  7.590144e-01  3.672075e-01 "
     sigma_t = " 3.982000e-01  8.834253e-01  8.954415e-01  1.489750e+00 "
     nu_sigma_f = " 3.902790e-03  9.796480e-03  1.418890e-02  1.562600e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.767190e-14  1.259570e-13  1.841460e-13  1.969850e-12 "
     adf = " 1.003920e+00  1.000920e+00  9.871200e-01  9.436800e-01 "
     sigma_s = " 3.565980e-01  0  0  0 ;
                 3.900730e-02  7.896920e-01  0  0 ;
                 1.250070e-05  5.803350e-02  5.895790e-01  1.808840e-03 ;
                 0  1.069660e-02  2.696470e-01  1.372770e+00 "
     block =  51 
     []
     [u45_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.727492e+00  7.622410e-01  7.539397e-01  3.645166e-01 "
     sigma_t = " 3.977826e-01  8.844377e-01  9.047113e-01  1.491410e+00 "
     nu_sigma_f = " 3.799640e-03  8.502030e-03  1.100690e-02  1.455190e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.619770e-14  1.072990e-13  1.406670e-13  1.801350e-12 "
     adf = " 1.003640e+00  1.000760e+00  9.866100e-01  9.406600e-01 "
     sigma_s = " 3.560210e-01  0  0  0 ;
                 3.921060e-02  7.902800e-01  0  0 ;
                 1.257360e-05  5.801260e-02  5.917520e-01  1.765050e-03 ;
                 0  1.069560e-02  2.693380e-01  1.376130e+00 "
     block =  52 
     []
     [u45_0015_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.667776e+00  7.635296e-01  7.665514e-01  3.798268e-01 "
     sigma_t = " 3.998393e-01  8.826222e-01  8.802297e-01  1.478904e+00 "
     nu_sigma_f = " 4.183360e-03  1.385290e-02  2.534100e-02  1.667230e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 5.174900e-14  1.844410e-13  3.374080e-13  2.219420e-12 "
     adf = " 1.013090e+00  1.006040e+00  9.978500e-01  1.000580e+00 "
     sigma_s = " 3.581610e-01  0  0  0 ;
                 3.893910e-02  7.885640e-01  0  0 ;
                 1.247030e-05  5.791260e-02  5.844560e-01  1.928070e-03 ;
                 0  1.067020e-02  2.713890e-01  1.354480e+00 "
     block =  53 
     []
     [u42_3250_rodded]
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
     block =  54 
     []
     [u45_2000_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.691240e+00  7.625287e-01  7.593654e-01  3.687997e-01 "
     sigma_t = " 3.981301e-01  8.839560e-01  8.937673e-01  1.492100e+00 "
     nu_sigma_f = " 3.979990e-03  1.089200e-02  1.641650e-02  1.673140e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.870820e-14  1.409210e-13  2.140950e-13  2.124020e-12 "
     adf = " 1.003970e+00  1.000820e+00  9.869000e-01  9.443600e-01 "
     sigma_s = " 3.566000e-01  0  0  0 ;
                 3.890270e-02  7.901050e-01  0  0 ;
                 1.246390e-05  5.776950e-02  5.891390e-01  1.882310e-03 ;
                 0  1.064840e-02  2.697500e-01  1.370190e+00 "
     block =  55 
     []
     [u42_3750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.733367e+00  7.625671e-01  7.542775e-01  3.637644e-01 "
     sigma_t = " 3.978869e-01  8.839087e-01  9.047835e-01  1.488844e+00 "
     nu_sigma_f = " 3.759760e-03  7.867660e-03  9.965150e-03  1.375210e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.567610e-14  9.887220e-14  1.268650e-13  1.695960e-12 "
     adf = " 1.003810e+00  1.000910e+00  9.869700e-01  9.415000e-01 "
     sigma_s = " 3.560770e-01  0  0  0 ;
                 3.927500e-02  7.898660e-01  0  0 ;
                 1.259610e-05  5.823320e-02  5.917210e-01  1.707440e-03 ;
                 0  1.073640e-02  2.693930e-01  1.377550e+00 "
     block =  56 
     []
     [u42_1750_rodded]
     type = MultigroupXSMaterial
     diffusivity = " 1.690734e+00  7.630017e-01  7.609082e-01  3.687768e-01 "
     sigma_t = " 3.983135e-01  8.832567e-01  8.915335e-01  1.488943e+00 "
     nu_sigma_f = " 3.955240e-03  1.049640e-02  1.596800e-02  1.612680e-01 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 4.841610e-14  1.359770e-13  2.084350e-13  2.050380e-12 "
     adf = " 1.004280e+00  1.001060e+00  9.874600e-01  9.463200e-01 "
     sigma_s = " 3.567720e-01  0  0  0 ;
                 3.892350e-02  7.896110e-01  0  0 ;
                 1.247090e-05  5.798630e-02  5.884840e-01  1.834580e-03 ;
                 0  1.068760e-02  2.699110e-01  1.370620e+00 "
     block =  57 
     []
     [reflector]
     type = MultigroupXSMaterial
     diffusivity = " 1.609490e+00  5.537181e-01  5.873125e-01  2.719601e-01 "
     sigma_t = " 4.121378e-01  1.074481e+00  1.093999e+00  2.028198e+00 "
     nu_sigma_f = " 0  0  0  0 "
     chi = " 9.996800e-01  3.199790e-04  0  0 "
     kappa_sigma_f = " 0  0  0  0 "
     adf = " 1.274670e+00  1.201470e+00  9.685200e-01  2.392000e-01 "
     sigma_s = " 3.702110e-01  0  0  0 ;
                 4.140310e-02  9.828650e-01  0  0 ;
                 1.325220e-05  7.457680e-02  7.607460e-01  7.002470e-04 ;
                 0  1.370600e-02  3.189600e-01  1.990260e+00 "
     block =  99 
     []
[]
