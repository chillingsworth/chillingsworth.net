DEV_IMG_NAME=personal-website:developement
DEPLOYMENT_NAME=personal-website

build-dev:
	docker build -t ${DEV_IMG_NAME} .

run-dev:
	docker run --publish 3000:3000 ${DEV_IMG_NAME}

start-cluster:
	minikube start
	kubectl create namespace ${DEPLOYMENT_NAME}
	kubectl config set-context --current --namespace=${DEPLOYMENT_NAME}
	minikube dashboard

stop-cluster:
	minikube stop

deploy-dev:
	kubectl apply -f deployment.yaml
	kubectl apply -f loadbalancer.yaml
	

clean-cluster:
	kubectl delete -n ${DEPLOYMENT_NAME} deployment ${DEPLOYMENT_NAME}
	kubectl delete -n ${DEPLOYMENT_NAME} job ${DEPLOYMENT_NAME}

push-container:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/j0l2f7n2
	docker tag ${DEV_IMG_NAME} public.ecr.aws/j0l2f7n2/${DEV_IMG_NAME}
	docker push public.ecr.aws/j0l2f7n2/${DEV_IMG_NAME}