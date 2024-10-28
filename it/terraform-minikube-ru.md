# Нет времени объяснять! или как подружить terraform с minikube и kubernetes

![](assets/tf_minikube.png)

*Date: 2017-10-24*

Как начать пользоваться [terraform](https://www.terraform.io/), развернув локально приложение поверх [minikube](https://github.com/kubernetes/minikube), и потом запустить его поверх [kubernetes](https://kubernetes.io/) в [cloud.google.com](https://cloud.google.com)

## Minikube

Для начала настроим [minikube](https://github.com/kubernetes/minikube) и при помощи [terraform](https://www.terraform.io/) развернем наше приложение, для этого уже [подготовил](https://github.com/ultral/terraform-example) проект. Остается только:

1. Установить [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Установить [Vagrant](https://www.vagrantup.com/downloads.html)
3. Сделать копию репозитория  [ultral/terraform-example](https://github.com/ultral/terraform-example)
4. Сделать

```bash
vagrant up
```

На выходе у нас есть виртуальная машина по адресу 192.168.56.123 c логином/паролем vagrant/vagrant и/или вашим публичным ключом для пользователей root и vagrant.

## Google cloud

Тут все становится интересней, будем подключаться к [cloud.google.com](https://cloud.google.com) и запускать там наше приложение.

1. Регистрируемся [https://cloud.google.com](https://cloud.google.com) что бы получить $ 300
2. На развернутой VM делаем `gcloud init` и следуем инструкции

```bash
gcloud init
```

3. [По инструкции](https://www.terraform.io/docs/providers/google/#authentication-json-file) получаем ключ в [консоли разработчика](https://console.developers.google.com) и складываем в **/root/.gcloud/terraform.json** на виртуальную машину
4. Создаем кластер в [cloud.google.com](https://cloud.google.com)

```bash
gcloud container clusters create gke-cluster
gcloud container clusters list
```

5. Получаем явки/пароли для подключения kubectl к [cloud.google.com](https://cloud.google.com)

```bash
[root@terraform-adm terraform]# gcloud container clusters get-credentials gke-cluster
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke-cluster.
```

6. Переключаем контекст kubectl

```bash
[root@terraform-adm terraform]# kubectl config use-context gke_tutorial-project-183818_europe-west1-d_gke-cluster
Switched to context "gke_tutorial-project-183818_europe-west1-d_gke-cluster".
```

7. Переименовываем контекст kubectl (он у нас указан в terraform)

```bash
[root@terraform-adm terraform]# kubectl config rename-context gke_tutorial-project-183818_europe-west1-d_gke-cluster gke_tutorial
Context "gke_tutorial-project-183818_europe-west1-d_gke-cluster" was renamed to "gke_tutorial".
```

8. Готовим переменные по образу и подобию для terraform

```bash
cp /vagrant/terraform/terraform.tfvars.example /vagrant/terraform/terraform.tfvars
vi /vagrant/terraform/terraform.tfvars
```

9. Подготавливаем и применяем terraform

```bash
terraform workspace new prod
terraform init
terraform plan
terraform apply
```

10. Теперь можно получить адрес нашего приложения и зайти через браузер. Мы молодцы.

```bash
terraform output lb_ingress
```

11. Подчищаем хвосты за собой

```bash
terraform destroy
gcloud container clusters delete gke-cluster
```

## Заключение

Terraform оказался не так страшен. Terraform открывает простор для структурирования и поддержания окружений в идентичном состоянии.
