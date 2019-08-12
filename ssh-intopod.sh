#! /bin/bash
# provide information about running pods

# prereq: 
#   1)  kubectl installed
#   2)  functioning kubectl configuration
#   3)  

if [ $# == 1 ]
then
    namespace=$1
else
    namespace="default"
fi
kc=$(ls ./output/kubeconfig*)

clear
echo ""
echo "Search restricted to namespace: $namespace"
echo ""
unset options i
i=0
howmany() { echo $#; }  #https://stackoverflow.com/questions/638802/number-of-tokens-in-bash-variable
mytextvar=$(kubectl --kubeconfig=$kc get po -n $namespace)
words=$(howmany $mytextvar)
if [ $words == 0 ]
then
    echo "Please check your namespace."
    exit
fi
h=$(((words / 5) -1))
z=6
while (( i < h )); do
  vari=$(echo $mytextvar |cut -d " " -f $z)
  options[$i]=$vari
  z=$((z+5))
  ((i++))
done

echo "Choose one of the following pods to SSH into:"

select opt in "${options[@]}" "Stop the script"; do
  case $opt in
    *-*)
      echo ""
      echo "Connecting to:  $opt"
      kubectl --kubeconfig=$kc exec -ti $opt -n $namespace -- /bin/bash
      rc=$?
      if (( rc > 0 )); then
        kubectl --kubeconfig=$kc exec -ti $opt -n $namespace -- /bin/sh
        rc=$?
        if (( rc > 0 )); then
          echo "Unable to attach to selected pod"
          exit 1
        fi
      fi
      break
      ;;
    "Stop the script")
      echo "You choose to stop"
      break
      ;;
    *)
      echo "This is not a number"
      ;;
  esac
done

exit

