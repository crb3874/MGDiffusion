#!/bin/bash
#----------------------------------------------------
# submission script - ARI NEA validation problem, with refinement.
#----------------------------------------------------

#SBATCH -J ari_32cores
#SBATCH -o ari_32cores.o%j
#SBATCH -e ari_32cores.e%j
#SBATCH -p small
#SBATCH -N 2
#SBATCH -n 32
#SBATCH -t 04:00:00
#SBATCH --mail-type=all
#SBATCH -A Clarno_INL_Codes
#SBATCH --mail-user=cbrennan545@utexas.edu

module list
pwd
date

# Setting environment variables
MOOSE="/work/07954/cbrennan/MOOSE_Shared/moose_proj"
MGDIFF="/work/07954/cbrennan/MOOSE_Shared/moose_proj/mg_diffusion"
MGDIFFEXE="/work/07954/cbrennan/MOOSE_Shared/moose_proj/mg_diffusion/mg_diffusion-opt"

# ARO="/work/07954/cbrennan/MOOSE_Shared/moose_proj/mg_diffusion/problems/aro"
ARI="/work/07954/cbrennan/MOOSE_Shared/moose_proj/mg_diffusion/problems/ari"

# Load py3env
python3 -m venv $STOCKYARD/MOOSE_shared/py3env
source $STOCKYARD/MOOSE_shared/py3env/bin/activate

# 2G Problems

echo "**********************"
echo "Running 2G problems..."
echo "**********************"
cd $ARI/nea_2g

echo " "
echo "2G 1x1/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='1 1 1 1 1 1 1 1 1' Mesh/QuarterCore/iy='1 1 1 1 1 1 1 1 1' Outputs/file_base='1x'

echo " "
echo "2G 2x2/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='2 2 2 2 2 2 2 2 2' Mesh/QuarterCore/iy='2 2 2 2 2 2 2 2 2' Outputs/file_base='2x'

echo " "
echo "2G 4x4/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='4 4 4 4 4 4 4 4 4' Mesh/QuarterCore/iy='4 4 4 4 4 4 4 4 4' Outputs/file_base='4x'

echo " "
echo "2G 8x8/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='8 8 8 8 8 8 8 8 8' Mesh/QuarterCore/iy='8 8 8 8 8 8 8 8 8' Outputs/file_base='8x'

echo " "
echo "2G 16x16/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='16 16 16 16 16 16 16 16 16' Mesh/QuarterCore/iy='16 16 16 16 16 16 16 16 16' Outputs/file_base='16x'

echo " "
echo "2G 32x32/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='32 32 32 32 32 32 32 32 32' Mesh/QuarterCore/iy='32 32 32 32 32 32 32 32 32' Outputs/file_base='32x'

echo " "
echo "2G 64x64/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_2g_base.i Mesh/QuarterCore/ix='64 64 64 64 64 64 64 64 64' Mesh/QuarterCore/iy='64 64 64 64 64 64 64 64 64' Outputs/file_base='64x'

# 4G Problems

echo "**********************"
echo "Running 4G problems..."
echo "**********************"
cd $ARI/nea_4g

echo " "
echo "4G 1x1/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='1 1 1 1 1 1 1 1 1' Mesh/QuarterCore/iy='1 1 1 1 1 1 1 1 1' Outputs/file_base='1x'

echo " "
echo "4G 2x2/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='2 2 2 2 2 2 2 2 2' Mesh/QuarterCore/iy='2 2 2 2 2 2 2 2 2' Outputs/file_base='2x'

echo " "
echo "4G 4x4/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='4 4 4 4 4 4 4 4 4' Mesh/QuarterCore/iy='4 4 4 4 4 4 4 4 4' Outputs/file_base='4x'

echo " "
echo "4G 8x8/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='8 8 8 8 8 8 8 8 8' Mesh/QuarterCore/iy='8 8 8 8 8 8 8 8 8' Outputs/file_base='8x'

echo " "
echo "4G 16x16/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='16 16 16 16 16 16 16 16 16' Mesh/QuarterCore/iy='16 16 16 16 16 16 16 16 16' Outputs/file_base='16x'

echo " "
echo "4G 32x32/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='32 32 32 32 32 32 32 32 32' Mesh/QuarterCore/iy='32 32 32 32 32 32 32 32 32' Outputs/file_base='32x'

echo " "
echo "4G 64x64/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_4g_base.i Mesh/QuarterCore/ix='64 64 64 64 64 64 64 64 64' Mesh/QuarterCore/iy='64 64 64 64 64 64 64 64 64' Outputs/file_base='64x'


# 8G Problems

echo "**********************"
echo "Running 8G problems..."
echo "**********************"
cd $ARI/nea_8g

echo " "
echo "8G 1x1/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='1 1 1 1 1 1 1 1 1' Mesh/QuarterCore/iy='1 1 1 1 1 1 1 1 1' Outputs/file_base='1x'

echo " "
echo "8G 2x2/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='2 2 2 2 2 2 2 2 2' Mesh/QuarterCore/iy='2 2 2 2 2 2 2 2 2' Outputs/file_base='2x'

echo " "
echo "8G 4x4/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='4 4 4 4 4 4 4 4 4' Mesh/QuarterCore/iy='4 4 4 4 4 4 4 4 4' Outputs/file_base='4x'

echo " "
echo "8G 8x8/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='8 8 8 8 8 8 8 8 8' Mesh/QuarterCore/iy='8 8 8 8 8 8 8 8 8' Outputs/file_base='8x'

echo " "
echo "8G 16x16/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='16 16 16 16 16 16 16 16 16' Mesh/QuarterCore/iy='16 16 16 16 16 16 16 16 16' Outputs/file_base='16x'

echo " "
echo "8G 32x32/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='32 32 32 32 32 32 32 32 32' Mesh/QuarterCore/iy='32 32 32 32 32 32 32 32 32' Outputs/file_base='32x'

echo " "
echo "8G 64x64/FA"
echo " "
ibrun $MGDIFFEXE -i ./nea_8g_base.i Mesh/QuarterCore/ix='64 64 64 64 64 64 64 64 64' Mesh/QuarterCore/iy='64 64 64 64 64 64 64 64 64' Outputs/file_base='64x'
