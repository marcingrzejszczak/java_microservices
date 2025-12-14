#!/bin/bash


echo "Creating the config map"
kubectl apply -f ../k8s/config-map.yml

echo "Creating the secret"
kubectl create secret generic config-client-secret --from-literal=encrypted=mysecret

echo "Building and pushing the docker image"
cd ..
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=localhost:5000/config-client:latest
docker push localhost:5000/config-client:latest

echo "Deploying the app to Kubernetes"
kubectl apply -f ../k8s/deployment.yml

echo "Question: how to print more information about the <config-client> deployment"
kubectl describe deployment config-client

echo "Making the pod accessible locally on the same port 7654"
#  kubectl port-forward "${pod}" 7654:7654 > /dev/null 2>&1 &
kubectl port-forward deployment/config-client 7654:7654  > /dev/null 2>&1 &

echo "Testing if K8s configuration works fine"
curl localhost:7654/refreshed
curl localhost:7654/configprop
curl localhost:7654/encrypted

echo "Updating the config map"
kubectl apply -f ../k8s/config-map-changed.yml

echo "Checking if the config map got refreshed"
watch -n 1 kubectl exec deployment/config-client -- cat /etc/config/default/a

echo -e "\n\nRefresh the application\n\n"
curl -X POST localhost:7654/actuator/refresh

echo "Testing if K8s configuration was refreshed"
curl localhost:7654/refreshed
curl localhost:7654/configprop
curl localhost:7654/encrypted
