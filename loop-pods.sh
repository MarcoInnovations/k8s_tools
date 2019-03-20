kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"

while true; do
	amount=$(kubectl --kubeconfig=$kc get pod --all-namespaces | grep ' Running ' | wc -l)
	echo "Running pods in all namespaces:   $amount"
	kubectl --kubeconfig=$kc get pod --all-namespaces
	echo ""
	sleep 2
done
