kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"

while true; do
	amount=$(kubectl --kubeconfig=$kc get pod -n default | grep ' Running ' | wc -l)
	echo "Running pods in default namespace is:   $amount"
	kubectl --kubeconfig=$kc get pod -n default
	echo ""
	sleep 2
done
