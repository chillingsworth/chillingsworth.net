SHELL := /bin/bash

#Docker
DEV_IMG_NAME=personal-website:developement

#Aws
KOPS_GROUP_NAME=kops-group
KOPS_USER_NAME=kops-user

#Kops
export NAME=k8s.chillingsworth.net
export KOPS_STATE_STORE=personal-website-ks-bucket
ZONES=us-east-1a
CONTROL_PANE_SIZE=t2.micro
NODE_SIZE=t2.micro
NODE_COUNT=3
MASTER_ZONE=us-east-1a

#Kubernetes
DEPLOYMENT_NAME=personal-website
ECS_REGISTRY=954447000905.dkr.ecr.us-east-1.amazonaws.com

run-app-locally:
	npm run dev

create-kops-group:
	aws iam create-group --group-name ${KOPS_GROUP_NAME}

attach-group-permissions:
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --group-name ${KOPS_GROUP_NAME}
	aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess --group-name ${KOPS_GROUP_NAME}

create-kops-user:
	aws iam create-user --user-name ${KOPS_USER_NAME}
	aws iam add-user-to-group --user-name ${KOPS_USER_NAME} --group-name ${KOPS_GROUP_NAME}

create-kops-access-keys:
	AWS_CREDS_FILE=~/.aws/credentials; \
	aws iam create-access-key --user-name ${KOPS_USER_NAME} | jq -r '.[]' | \
	tee >(echo aws_secret_access_key = $$(jq -r '.SecretAccessKey') >> $$AWS_CREDS_FILE) \
	tee >(echo aws_access_key_id = $$(jq -r '.AccessKeyId') >> $$AWS_CREDS_FILE) \
	tee >(echo [$$(jq -r '.UserName')] >> $$AWS_CREDS_FILE)

create-k8s-backend:
	aws s3api create-bucket \
	--bucket $(KOPS_STATE_STORE) \
	--region us-east-1

create-aws-cluster:
	kops create cluster \
	--name ${NAME} \
	--cloud aws \
	--state s3://${KOPS_STATE_STORE} \
	--node-count ${NODE_COUNT} \
	--zones ${ZONES}

delete-aws-cluster:
	kops delete cluster \
	--name ${NAME} \
	--yes

configure-cluster:
	kops edit cluster --name ${NAME}

deploy-aws-cluster:
	kops update cluster --name ${NAME} --yes --admin

set-k8s-context:
	kops export kubecfg --name ${NAME} \
	--state s3://${KOPS_STATE_STORE} \
	--admin ;





delete-test-cluster:
	kops delete cluster --name ${NAME} --yes

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

start-cluster:
	minikube start
	kubectl create namespace ${DEPLOYMENT_NAME}
	kubectl config set-context --current --namespace=${DEPLOYMENT_NAME}
	minikube dashboard

stop-cluster:
	minikube stop
	
clean-cluster:
	kubectl delete -n ${DEPLOYMENT_NAME} deployment ${DEPLOYMENT_NAME}
	kubectl delete -n ${DEPLOYMENT_NAME} job ${DEPLOYMENT_NAME}

restart-docker:
	sudo service docker restart


