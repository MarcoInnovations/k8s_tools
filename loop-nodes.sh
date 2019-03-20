kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"

while true; do
	kubectl --kubeconfig=$kc get nodes --all-namespaces
	sleep 2
done
