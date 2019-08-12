#!/bin/bash
# provide information about running kubernetes cluster

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  expecting kubeconfig in ./output folder
#   4)  .....

kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"
echo ""

kubectl -n kube-system describe secret --kubeconfig=$kc $(kubectl -n kube-system get secret --kubeconfig=$kc | grep admin-mrt | awk '{print $1}') | grep "token: "
echo ""

kubectl proxy --kubeconfig=$kc
