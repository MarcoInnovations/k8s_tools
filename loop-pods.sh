#!/bin/bash
# provide information about running kubernetes cluster

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  expecting kubeconfig in ./output folder
#   4)  .....

kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"

while true; do
	amount=$(kubectl --kubeconfig=$kc get pod --all-namespaces | grep ' Running ' | wc -l)
	echo "Running pods in all namespaces:   $amount"
	kubectl --kubeconfig=$kc get pod --all-namespaces
	echo ""
	sleep 2
done
