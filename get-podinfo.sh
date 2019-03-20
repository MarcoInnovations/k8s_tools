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

clear
echo ""
echo "Search restricted to namespace: $namespace"
echo ""
unset options i
i=0
howmany() { echo $#; }  #https://stackoverflow.com/questions/638802/number-of-tokens-in-bash-variable
mytextvar=$(kubectl get po -n $namespace)
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

echo "Please choose one of the following pods to get info:"

select opt in "${options[@]}" "Stop the script"; do
  case $opt in
    *-*)
      echo ""
      echo "Information for: $opt"
#      info1=$(kubectl describe po $opt -n $namespace)
      loginfo=$(kubectl describe po $opt -n $namespace| grep "Container ID:"| awk '{ gsub(/docker:\/\//, "" ); print $3; }')
      statusinfo1=$(kubectl describe po $opt -n $namespace| grep "Status:"| awk '{print $NF}')
      readyinfo1=$(kubectl describe po $opt -n $namespace| grep "Ready:"| awk '{print $NF}')
      echo "POD Status     : $statusinfo1"
      echo "Ready Status   : $readyinfo1"
      echo "CloudWatch log : $loginfo"
      echo ""
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

