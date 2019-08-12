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
	kubectl --kubeconfig=$kc get nodes --all-namespaces
	sleep 2
done
