# translator-deploy
Deploy the containers translator-go and translator-ui to minikube(K8S) using Terraform

## How to use 
### minikube
* Install the minikube follwing the [instruction](https://kubernetes.io/docs/tutorials/hello-minikube/) and start it;
* Build the Dockers containers of [translator-go](https://github.com/taleksandrv/translator-go) and [translator-ui](https://github.com/taleksandrv/translator-go) application:
```
eval $(minikube docker-env)

#In the translator-ui directory
docker build -t translator-ui:v2 .

#In the translator-go directory
docker build -t translator:v2 .
```

### Terraform

* Get the Terraform https://www.terraform.io/downloads.html (the Terraform manifest tested for 0.11.8 version);
* Deploy using Terraform

```
terraform init

terraform apply -var yandex_token="you_yandex_token"
```
