//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "MGDiffusionTestApp.h"
#include "MGDiffusionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
MGDiffusionTestApp::validParams()
{
  InputParameters params = MGDiffusionApp::validParams();
  return params;
}

MGDiffusionTestApp::MGDiffusionTestApp(InputParameters parameters) : MooseApp(parameters)
{
  MGDiffusionTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

MGDiffusionTestApp::~MGDiffusionTestApp() {}

void
MGDiffusionTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  MGDiffusionApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"MGDiffusionTestApp"});
    Registry::registerActionsTo(af, {"MGDiffusionTestApp"});
  }
}

void
MGDiffusionTestApp::registerApps()
{
  registerApp(MGDiffusionApp);
  registerApp(MGDiffusionTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
MGDiffusionTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  MGDiffusionTestApp::registerAll(f, af, s);
}
extern "C" void
MGDiffusionTestApp__registerApps()
{
  MGDiffusionTestApp::registerApps();
}
