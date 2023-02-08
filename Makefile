include .env

create-k8s-backend:
	aws s3api create-bucket \
    --bucket $(KOPS_STATE_STORE) \
    --region us-east-1

create-aws-cluster:
	kops create cluster \
	--name ${NAME} \
	--state s3://${KOPS_STATE_STORE} \
	--node-count ${NODE_COUNT} \
	--zones ${ZONES} \
	--node-size ${NODE_SIZE} \
	--master-size ${NODE_SIZE} \
	--yes

create-test-cluster:
	kops create cluster \
	--name=${NAME} \
	--cloud=aws \
	--zones=us-east-1a

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


