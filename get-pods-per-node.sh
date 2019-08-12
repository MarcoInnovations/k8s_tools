#! /bin/bash
# provide information about running kubernetes cluster

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  expecting kubeconfig in ./output folder
#   4)  .....

kc=$(ls ./output/kubeconfig* 2>/dev/null)

[ -z "$kc" ] && echo "Check if you have a kubeconfig file ..." && exit

echo "\npods per node:"
for n in $(kubectl --kubeconfig=$kc get nodes  --no-headers | cut -d " " -f1); do 
    echo "\n>>node ${n}:"
    kubectl --kubeconfig=$kc get pods --all-namespaces --field-selector spec.nodeName=${n} 
done