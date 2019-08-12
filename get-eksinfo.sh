#!/bin/bash
# provide information about running kubernetes cluster

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  expecting kubeconfig in ./output folder
#   4)  .....

if [ $# == 1 ]
then
    namespace=$1
else
    namespace="default"
fi
kc=$(ls ./output/kubeconfig*)
howmany() { echo "$#"; } #https://stackoverflow.com/questions/638802/number-of-tokens-in-bash-variable
clear
context=$(kubectl --kubeconfig=$kc config view |grep "current-context:"| awk '{ print $NF }')
echo ">>  EKS cluster name: $context"

mytotalnodes="$(kubectl --kubeconfig=$kc get nodes | grep internal)"
nodes=$(echo "$mytotalnodes" | wc -l)

if [ $nodes == 0 ]
then
    echo "Please check your kubectl configuration. \nAre you querying an EKS cluster?"
    exit 1
fi

readynodes=$(echo "$mytotalnodes" | grep ' Ready ' | wc -l)
notreadynodes=$(echo "$mytotalnodes" | grep -v ' Ready ' | wc -l)
mytotal=$((readynodes + notreadynodes))
echo "    * Total worker nodes        :  $mytotal"
echo "    * Number of ready nodes     : "$readynodes""
echo "    * Number of nodes not ready : "$notreadynodes""

unset options vari i notreadynodes readynodes z mymasters mynodes mytotal
mynamespaces=$(kubectl --kubeconfig=$kc get namespaces)
words=$(howmany $mynamespaces)
if [ $words == 0 ]
then
    echo "Please check your kubectl configuration."
    exit 1
fi
h=$(((words / 3) -1))
z=4
while (( i < h )); do
  vari=$(echo $mynamespaces |cut -d " " -f $z)
  options[$i]=$vari
  z=$((z+3))
  ((i++))
done
echo "\n>>  Configured Namespaces:"
printf '    * %s\n' "${options[@]}"
unset options i z h mynamespaces words
echo "\n>>  Services configured in user namespaces:"
kubectl --kubeconfig=$kc get services --all-namespaces |grep -v "kube-system"
echo "\n>>  ReplicaSets configured in user namespaces:"
kubectl --kubeconfig=$kc get ReplicaSets --all-namespaces |grep -v "kube-system" # |grep -v "NAMESPACE"
echo "\n>>  Deployments configured in user namespaces:"
kubectl --kubeconfig=$kc get deployments --all-namespaces |grep -v "kube-system" # |grep -v "NAMESPACE"
echo "\n>>  Pods running in user namespaces:"
kubectl --kubeconfig=$kc get pods --all-namespaces |grep -v "kube-system" # |grep -v "NAMESPACE"

exit