kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"

while true; do
	kubectl get hpa --kubeconfig=$kc
	sleep 2
done
