aws eks update-kubeconfig --name dev-eks
kubectl create ns app
#ARGO_URL=$(kubectl get svc argocd-server -n argocd| grep argocd-server | awk '{print $4}')
ARGO_URL=argocd-${1}.rdevopsb79.online
ARGO_PASSWORD=$(kubectl get secrets -n argocd argocd-initial-admin-secret -o json  | jq '.data.password' | xargs | base64 --decode)

argocd login $ARGO_URL --username admin --password $ARGO_PASSWORD --grpc-web

argocd app list --app-namespace app | grep "argocd/${2}"
if [ $? -ne 0 ]; then
  argocd app create ${2} --repo https://github.com/raghudevopsb79/expense-helm --path . --dest-namespace default --dest-server https://kubernetes.default.svc --values ${1}/${2}.yaml --sync-policy auto --grpc-web --helm-set imageTag=$3 --app-namespace app --project expense
  argocd app wait ${2} --app-namespace app
fi

argocd app set ${2} --parameter imageTag=$3 --app-namespace app
argocd app wait ${2} --app-namespace app
