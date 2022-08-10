# README #

Deployment pipelines for Acuant Go environments.


## Automated Service Deployment (Kubernetes)

### Scripts

- `deployment.sh` : Deploy the containers specified in `environments.bash`. Deployment parameters are specfied by environment variables. 

- `setup_local.sh` : Set up environment variables for deployment to a local Kubernetes cluster, using namespace `acuant-go`. 

- `tools/generate_ecr_credentials.sh <AWS account #> <AWS region>` : Generate AWS ECR registry access credentials for use in Kubernetes deployments/secrets.

- kafka: https://bitbucket.org/acuant/hub-instance-design-studio-acountgo/pull-requests/18

### Components

1. config service  (5888)
2. provisioning service (5003)
3. instance (5005)
4. design (8006)

## Infrastructure as Code (IaC)

### Teraform (TODO)

- Needs state

### CloudFormation (TODO)

- For APIGateway, Lambdas, Postgres, and the EC2 that runs ChargeBees PHP client

### Scripts (TODO)

TODO - this should be automated!!!

- `infrastructure.sh [ 'test' | 'staging' | 'production']` :  set up the infrastructure for the specified environment

## Pipeline Resources
The follow are the links to Azure DevOps pipeline & the associated Github repository.
- [Azure DevOps](https://dev.azure.com/gbgplc/Acuant%20GO)
- [Github Repository](https://github.com/gbgplc-internal/identity-acuantgo-infrastructure)

## Testing in your local machine

In order to test this locally you can follow the following steps
### Set up repository & local docker registry with the required image/images 
- Set up a local docker registry (`docker run -d -p 5001:5000 --restart=always --name registry registry:2`).

  **NOTE** Using port 5001 as shown avoids conflict with AirPlay on MacOs.
- Check out `acuantgo-infrastructure` locally

#### Prepare Image - Option I
The below steps build a "dummy" test image and tag it as though it were an application image.
- Navigate to the `test` folder of `acuantgo-infrastructure` in your local workspace.
- `docker build -t localhost:5001/<IMAGE_NAME>:<VERSION> .`

#### Prepare Image - Option II
- `docker tag <ALREADY_EXISTING_IMAGE> localhost:5001/<IMAGE_NAME>:<VERSION>`
- `ALREADY_EXISTING_IMAGE` as the name suggests is an already existing image of the application that you want to deploy locally using this infrastructure. 

#### What does the tag signify?
- The first part of the tag, the text before `/`, signifies the registry name. For local testing it is localhost:port. For ECR it will be the corresponding domain name.
- `IMAGE_NAME` should be the value represented by any of the ENVs in (DESIGN_IMAGE_REPO, INSTANCE_IMAGE_REPO, PROVISIONING_IMAGE_REPO, WEBSTORE_IMAGE_REPO). Refer to `environments.bash`.
- `VERSION` should be the value represented by any of the ENVs in (DESIGN_VERSION, INSTANCE_VERSION, PROVISIONING_VERSION, WEBSTORE_VERSION). It should be selected based on the selection of `IMAGE_NAME`. Refer to `environments.bash`.
- Ex. If the `IMAGE_NAME` selected is the value of `DESIGN_IMAGE_REPO` ENV (default value is `hub-design-studio-acuantgo`) then the `VERSION` should be `DESIGN_VERSION`(default value is `v0.0.9`)

#### Publish the image to the local registry
- `docker push localhost:5001/<IMAGE_NAME>:<VERSION>`
- `docker images` - List images

#### Remove image if you want to 
- `docker image remove localhost:5001/<IMAGE_NAME>:<VERSION>`

### Setting Up Kubernetes Contexts (For first time users)
- `aws eks --region us-east-1 update-kubeconfig --name eks-studio-stg-us-east-1 --profile YOUR_STG_PROFILE`
- `YOUR_STG_PROFILE` should be setup to assume the role that has access to the STG environment. (You would have received the details at the on-boarding time. You can always ask the tribe for more information)
- `eks-studio-stg-us-east-1` is one of the EKS clusters we use. For the time being the secrets that are shared among developers are stored there.
- The above `aws eks` command will set the current context to the one that can access the cluster. If you are not a first time user then set the appropriate context before executing the below step. The context setting is explained right after this section. Please note that instead of `docker-desktop` you will have to specify the context that can access the `eks-studio-stg-us-east-1` cluster. Ex: `kubectl config set current-context arn:aws:eks:us-east-1:xxxxxxxxx:cluster/eks-studio-stg-us-east-1` (replace 'xxxxxxxxx' with the AWS account ID of your Acuant Studio Staging role, ex '122132312'). 
- `kubectl get secret SECRET_NAME --namespace acuant-go -o go-template='{{range $k,$v := .data}}{{printf "%s=" $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}' > .env`
- `SECRET_NAME` is the secret name currently in use. Ask the team to get the latest one.

#### Update
- Use the following command to download the cluster secrets in to a yml file 
- `kubectl get secret SECRET_NAME --namespace acuant-go -o yaml > secret.yml`

### Setting the context to docker-desktop
- `kubectl config get-contexts` - Check the current context
- `kubectl config set current-context docker-desktop` - Switch context to docker-desktop if it is not the current context
- `kubectl config get-contexts` - Verify
- You can also use the Docker Icon on the top-bar (MacOs) to switch the context. Hover on Kubernetes and select the required context.

### Note: You are expected to run the rest of the steps in the `docker-desktop` context.

### Create namespace
- `kubectl create namespace acuant-go` - You need to do this step only once
- `kubectl get namespace` - Verify

### Set up secrets locally
- The below step uses the `secret.yml` downloaded from `eks-studio-stg-us-east-1` cluster to set up the local secrets. 
- You can create your own `secret.yml` file skipping the download from cluster and create the local secrets. 
- Another option is to download the secrets and override the required values.
- Please make sure that you have modified the secret name (this is the default value in the local `app-secret-unknown-v0.0-latest`) and that you have removed the annotations in the `secret.yml` file.
- `kubectl apply -f secret.yml`
- Remove the secrets if you face any errors and re-run the above command
- `kubectl get secrets -n acuant-go` - Verify

### Setting Up ENVs
- You can choose at least one from the two options to setup ENVs. If you are choosing both, please note that `.env` files have preference over shell ENVs.

#### .env file
- You can add the ENVs to the `.env` file present at the root of acuantgo-infrastructure repository.
- `AWS_ECR_REGISTRY` is the minimum required ENV. The value is mentioned below with export.
#### Update
- You can run `bash setup_local.sh` to initialise the `.env` file with a set of ENVs that are useful for local testing.

#### Export ENV to shell
- If you don't want to use the `.env` file you can always export the values to the shell.
- `export AWS_ECR_REGISTRY="localhost:5001"`

### Generate deployment configuration files
- Navigate to the `acuantgo-infrastructure` repository and do `rm -rf target`
- Execute `bash deployment.sh`

### Deploy locally
- Navigate to the `target` folder and follow the option that suits your testing context.

#### Option I
- `kubectl apply -f ./config-map.yml`
- `kubectl get configmap -n acuant-go` - Verify
- `kubectl apply -f NAME.yaml ` - The name depends on the selection of `<IMAGE_NAME>`. See `target` folder for reference. See folders inside `services` to get the source of truth.

#### Option II
- `kubectl apply -f .` - This will deploy every thing

#### Verify deployments and ENVs
- `kubectl get deploy -n acuant-go` | `kubectl get deployments -n acuant-go`
- `kubectl get services -n acuant-go`
- `kubectl get configmap -n acuant-go` - Verify
- `Kubectl get pods -n acuant-go`
- `kubectl -n acuant-go exec <POD_NAME> -- env` - Verify env values

#### Cleanup
- `kubectl delete deployment <DEPLOYMENT_NAME> -n acuant-go` - Do this for all deployments
- `kubectl delete service <DEPLOYMENT_NAME> -n acuant-go` - Do this for all services
- `kubectl delete secret <SECRET_NAME> -n acuant-go`
- `kubectl delete configmap <CONFIGMAP_NAME> -n acuant-go`
- `kubectl scale --replicas=0 deployment/<DEPLOYMENT_NAME> -n acuant-go` - Scale


# Roadmap
This should eventually be converted to an Operator that reads configuration
from a CRD (see https://github.com/flant/shell-operator)

Discussion - We should probably be using:
- Sealed Secrets : https://github.com/bitnami-labs/sealed-secrets
- Flux for deployments : https://fluxcd.io/docs/cheatsheets/bootstrap/
