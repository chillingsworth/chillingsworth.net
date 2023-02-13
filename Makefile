SHELL := /bin/bash

include .config
include ./simple-kubernetes-cluster/aws/.config
export

run-app-locally:
	npm run dev

build:
	docker build -t ${DEV_IMG_NAME} .

run:
	docker run --publish 3000:3000 ${DEV_IMG_NAME}

push-container:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECS_REGISTRY} ; \
	docker build -t ${DEV_IMG_NAME} . ; \
	docker tag ${DEV_IMG_NAME} ${ECS_REGISTRY}/${DEV_IMG_NAME} ; \
	docker push ${ECS_REGISTRY}/${DEV_IMG_NAME}

deploy:
	kops export kubecfg --admin ; \
	kubectl apply -f deployment.yaml ; \
	kubectl apply -f loadbalancer.yaml

get-deployment:
	kubectl get deployment

delete:
	kops export kubecfg --admin ; \
	kubectl delete -f deployment.yaml ; \
	kubectl delete -f loadbalancer.yaml

get-svc:
	kubectl get svc

update-deployment-img:
	kubectl rollout restart deployment/${DEPLOYMENT_NAME}

restart-docker:
	sudo service docker restart


