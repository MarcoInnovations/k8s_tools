echo "\npods on sysops group: \n"
for n in $(kubectl --kubeconfig=./output/kubeconfig_mrt92-04 get nodes -l worker_group=sysops --no-headers | cut -d " " -f1); do 
    kubectl --kubeconfig=./output/kubeconfig_mrt92-04 get pods --all-namespaces  --no-headers --field-selector spec.nodeName=${n} 
done

echo "\npods on app group: \n"
for n in $(kubectl --kubeconfig=./output/kubeconfig_mrt92-04 get nodes -l worker_group=app --no-headers | cut -d " " -f1); do 
    kubectl --kubeconfig=./output/kubeconfig_mrt92-04 get pods --all-namespaces  --no-headers --field-selector spec.nodeName=${n} 
done