NAMESPACE=default

# Delete all standard resources
kubectl delete all --all -n $NAMESPACE

# Delete additional resources
kubectl delete pvc --all -n $NAMESPACE
kubectl delete cm --all -n $NAMESPACE
kubectl delete secrets --all -n $NAMESPACE
kubectl delete ingresses --all -n $NAMESPACE
kubectl delete roles --all -n $NAMESPACE
kubectl delete rolebindings --all -n $NAMESPACE
kubectl delete serviceaccounts --all -n $NAMESPACE

# Optionally delete the namespace itself
# kubectl delete namespace $NAMESPACE