#include "MGDiffusionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
MGDiffusionApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy material output, i.e., output properties on INITIAL as well as TIMESTEP_END
  params.set<bool>("use_legacy_material_output") = false;

  return params;
}

MGDiffusionApp::MGDiffusionApp(InputParameters parameters) : MooseApp(parameters)
{
  MGDiffusionApp::registerAll(_factory, _action_factory, _syntax);
}

MGDiffusionApp::~MGDiffusionApp() {}

void
MGDiffusionApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAll(f, af, syntax);
  Registry::registerObjectsTo(f, {"MGDiffusionApp"});
  Registry::registerActionsTo(af, {"MGDiffusionApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
MGDiffusionApp::registerApps()
{
  registerApp(MGDiffusionApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
MGDiffusionApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  MGDiffusionApp::registerAll(f, af, s);
}
extern "C" void
MGDiffusionApp__registerApps()
{
  MGDiffusionApp::registerApps();
}
