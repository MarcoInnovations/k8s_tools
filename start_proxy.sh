kc=$(ls ./output/kubeconfig*)
echo "Using kubeconfig: $kc"
echo ""

kubectl -n kube-system describe secret --kubeconfig=$kc $(kubectl -n kube-system get secret --kubeconfig=$kc | grep admin-mrt | awk '{print $1}') | grep "token: "
echo ""

kubectl proxy --kubeconfig=$kc
