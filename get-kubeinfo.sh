#! /bin/bash
# provide information about running kubernetes cluster

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  

kc=$(ls ./output/kubeconfig*)

if [ $# == 1 ]
then
    namespace=$1
else
    namespace="default"
fi

clear
howmany() { echo $#; }  #https://stackoverflow.com/questions/638802/number-of-tokens-in-bash-variable
context=$(kubectl --kubeconfig=$kc config view |grep "current-context:"| awk '{ print $NF }')
echo ">>  k8s cluster name: $context"
mymasters=$(kubectl --kubeconfig=$kc get nodes | grep master)
mynodes=$(kubectl --kubeconfig=$kc get nodes | grep node)
masters=$(howmany $mymasters)
if [ $masters == 0 ]
then
    echo "Please check your kubectl configuration."
    exit 1
fi
nodes=$(howmany $mynodes)
if [ $nodes == 0 ]
then
    echo "Please check your kubectl configuration."
    exit 1
fi
hm=$(((masters / 5)))
hn=$(((nodes / 5)))
mytotal=$((hm + hn))
echo "    * Total k8s instances: $mytotal"
echo "    * Number of Masters  : $hm"
echo "    * Number of Nodes    : $hn"
i=0
z=1
while (( i < hm )); do
  vari=$(echo $mymasters |cut -d " " -f $z)
  options[$i]=$vari
  z=$((z+5))
  ((i++))
done
echo ">>  Available masters:"
printf '    * %s\n' "${options[@]}"
unset options vari
i=0
z=1
while (( i < hn )); do
  vari=$(echo $mynodes |cut -d " " -f $z)
  options[$i]=$vari
  z=$((z+5))
  ((i++))
done
echo ">>  Available nodes:"
printf '    * %s\n' "${options[@]}"
unset options vari i hn hm z mymasters mynodes mytotal
mytextvar=$(kubectl get namespaces)
words=$(howmany $mytextvar)
if [ $words == 0 ]
then
    echo "Please check your kubectl --kubeconfig=$kc configuration."
    exit 1
fi
h=$(((words / 3) -1))
z=4
while (( i < h )); do
  vari=$(echo $mytextvar |cut -d " " -f $z)
  options[$i]=$vari
  z=$((z+3))
  ((i++))
done
echo ">>  User Configured Namespaces:"
printf '    * %s\n' "${options[@]}"
unset options i z h mytextvar words
echo ">>  User Configured Services:"
kubectl --kubeconfig=$kc get services --all-namespaces |grep -v "kube-system"
echo ">>  User Configured ReplicaSets:"
kubectl --kubeconfig=$kc get ReplicaSets --all-namespaces |grep -v "kube-system"
echo ">>  User Configured Deployments:"
kubectl --kubeconfig=$kc get deployments --all-namespaces |grep -v "kube-system"
echo ">>  Running Pods:"
kubectl --kubeconfig=$kc get pods --all-namespaces |grep -v "kube-system"

exit