MGDIFF="/Users/colinbrennan/projects/mg_diffusion"
MGDIFFEXE="/Users/colinbrennan/projects//mg_diffusion/mg_diffusion-opt"
IHG="/Users/colinbrennan/projects/mg_diffusion/problems/ihg-test"

cd $IHG/4g

for input in *.i; do
    echo "Running 4G IHG test for material..."
    echo $input
    $MGDIFFEXE -i "$input"
done

cd $MGDIFF
