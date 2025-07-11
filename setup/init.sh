#!/bin/bash
set -e -o pipefail

echo "Fetching IAM github-action-user ARN"
# userarn=$(aws iam get-user --user-name github-action-user | jq -r .User.Arn)
userarn="arn:aws:iam::180364491628:user/github-action-user"

# Download tool for manipulating aws-auth
echo "Downloading tool..."
curl -X GET -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_darwin_amd64 -o aws-iam-authenticator
chmod +x aws-iam-authenticator

echo "Updating permissions"
./aws-iam-authenticator add user --userarn="${userarn}" --username=github-action-role --groups=system:masters --kubeconfig="$HOME"/.kube/config --prompt=false

echo "Cleaning up"
rm aws-iam-authenticator
echo "Done!"