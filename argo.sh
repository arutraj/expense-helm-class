ARGO_URL=$(kubectl get svc argocd-server -n argocd| grep argocd-server | awk '{print $4}')
ARGO_PASSWORD=$(kubectl get secrets -n argocd argocd-initial-admin-secret -o json  | jq '.data.password' | xargs | base64 --decode)

argocd login $ARGO_URL --username admin --password $ARGO_PASSWORD --insecure

argocd app create backend --repo https://github.com/raghudevopsb79/expense-helm --path . --dest-namespace default --dest-server https://kubernetes.default.svc --values dev/backend.yaml --sync-policy auto