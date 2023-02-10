SHELL := /bin/bash

include .config
export

run-app-locally:
	npm run dev

build-dev:
	docker build -t ${DEV_IMG_NAME} .

run-dev:
	docker run --publish 3000:3000 ${DEV_IMG_NAME}

push-container:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECS_REGISTRY} ; \
	docker build -t ${DEV_IMG_NAME} . ; \
	docker tag ${DEV_IMG_NAME} ${ECS_REGISTRY}/${DEV_IMG_NAME} ; \
	docker push ${ECS_REGISTRY}/${DEV_IMG_NAME}

deploy-dev:
	kops export kubecfg --admin ; \
	kubectl apply -f deployment.yaml ; \
	kubectl apply -f loadbalancer.yaml

update-deployment-img:
	kubectl rollout restart deployment/${DEPLOYMENT_NAME}
	
clean-cluster:
	kubectl delete -n ${DEPLOYMENT_NAME} deployment ${DEPLOYMENT_NAME}
	kubectl delete -n ${DEPLOYMENT_NAME} job ${DEPLOYMENT_NAME}

restart-docker:
	sudo service docker restart


