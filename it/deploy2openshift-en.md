---
redirect_from: "/d2o"
---

# Let's deploy to Openshift

*Date: 2019-02-27*

It is the transcription of my presentation at [kubernetes SPB meetup #3 (RU) 2019-02-25](https://www.meetup.com/kubernetes-spb/events/258970186/) & [ITGM #14 (ENG) 2019-03-23](https://piter-united.ru/#rec91713889).

* [Video(RU) from k8spb meetup at dell emc 2019-02-25](https://www.youtube.com/watch?v=mrTUo-k_jKg)
* [k8spb slides](https://cloud.mail.ru/public/AU1p/NPQFXfeMP)
* [ITGM slides](https://cloud.mail.ru/public/5aBL/6S2YQd5TU)
* [English version](deploy2openshift-en.md)
* [Russian version](deploy2openshift-ru.md)

## Our story

I'd like to share my story about migrating application to Openshift. Also, as a result, I will compare some of the most popular solutions and tools for managing your application inside Openshift.

### What should we do?

![This is fine](assets/deploy2openshift-this_is_fine.png?raw=true "This is fine")

First of all, let's talk about our application. It is an out of box enterprise solution, it supports different databases, application servers and integration interfaces with third-party systems. Usually, our clients were installing our application on dedicated servers, however, we faced the issue. We had to tun the application inside Openshift.

### Prerequisites

![Deploy](assets/deploy2openshift-deploy.png?raw=true "Deploy")

The application is the product with a long history, it should work out of the box in completely different environments. As a result, there are a lot of page in our installations guides. However, the top level schema is easy as pie, you just should:

* Apply DB schema.
* Prepare application server configuration.
* Install your license.
* Initialize the application.

![Deploy](assets/one-does-not-simply.png?raw=true "Deploy")

Unfortunately, the world is cruel, there were some important prerequisites.

* We could build the application only at a special Jenkins slave, because of security restrictions
* There was no access from the client's Openshift installation to the private developers' docker registry.
* We were not able to re-use existing docker images, because they were created for developing & testing needs only.
* There were ansible playbooks for application deployment on VMs.

### Ansible-container demo

![Ansible-container](assets/deploy2openshift-schema-ansible-container.png?raw=true "Ansible-container")

> Ansible Container is an open source project that aims to enable the automation of the entire container build, deployment and management process. Best of all, it uses the same simple, powerful and agentless Ansible automation language that you're already using, ensuring you can automate the entire application lifecycle.

We already had written some Ansible roles for installing the application at VMs, so we reused them with [ansible-container](https://blog.openshift.com/ansible-container/). Ansible container is a toolset for building containers. I’m not sure that it’s really good toolset, however it allows:

* Create containers the same way we deploy our servers.
* Stop chaining together shell commands in Dockerfiles.

There was no major issue with ansible-container because [Openshift creating images guidlines](https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html) is awesome. However, I'd like to notice:

* We modified our ansible roles, because `Docker + systemd = pain`.
* There is no ability to use chroot, sudo inside Openshift by default, because of security. Just read [CVE-2019-5736](https://seclists.org/oss-sec/2019/q1/119).
* For security reasons Openshift be default also generate random UID for each container, in other words openshift ignores the USER option from a Dockerfile.

The main point is that ansible-container helped us to create a demo very fast, because of reusing.

### Multiple containers demo

![Multiple containers](assets/deploy2openshift-schema-multiple-containers.png?raw=true "Multiple containers")

The first demo container was built via ansible-container. It was good enough for the demo, however, we decided not to use it. We split the monolith container into different:

1. We used the original Openshift PostgreSQL container without any modifications.
2. We built the application stateless container.

![Multiple containers](assets/deploy2openshift-schema-multiple-containers-db-init.png?raw=true "Multiple containers")

However, it wasn't clear to initialize the database? We found a great article about [PODs life](https://blog.openshift.com/kubernetes-pods-life/) inside kubernetes. So, we decided to use init container for database initialization.

### Initialize the application

![Multiple containers](assets/deploy2openshift-schema-multiple-containers-app-init.png?raw=true "Multiple containers")

As I mentioned before,  the application should work out of the box in completely different environments, support different application servers/databases and integration interfaces with third-party systems.

There are a lot of ways to initialize the application:

1. Pass configuration via environment variables. This means add all our documentation/knowledge about how to initialize the application for each use case into each container. It doesn't sound good.
2. Use start hook, this is approximately the same as the first one.
3. Initialize during provision to Openshift.
4. Use an external container with individual configuration for each use case.

We chose the last one, we created additional replication controller for initializing the application? Really?
![Multiple containers](assets/deploy2openshift-schema-multiple-containers-final.png?raw=true "Multiple containers")

We read the documentation again.

> A pod (as in a pod of whales or pea pod) is a group of one or more containers (such as Docker containers), with shared storage/network, and a specification for how to run the containers.

POD is a **group** of the containers. As a result, we decided to run 3 containers in an application POD

1. Init container for a PostgreSQL initialization.
2. The application container.
3. Application initialization container.

This approach allows to store our configuration as a code, there are two interesting results: the application configuration is testable and reproducible.

## Tools

There a lot of already exists for managing openshift.

* [Openshift templates](https://docs.openshift.com/container-platform/3.7/dev_guide/templates.html)
* bash/python/ruby + yml templates
* [Terraform k8s provider](https://www.terraform.io/docs/providers/kubernetes/index.html)
* [Ansible-container](https://blog.openshift.com/ansible-container/)
* [Ansible + k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html)
* [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle)
* [Ansible bender](https://blog.tomecek.net/post/road-to-ansible-bender-0-2-0/)
* [operator](https://blog.openshift.com/introducing-the-operator-framework/)
* [source2image](https://github.com/openshift/source-to-image)
* [kustomize](https://github.com/kubernetes-sigs/kustomize)
* [helm](https://github.com/helm/helm)
* [Automation broker](http://automationbroker.io/)

During the migration, I've tested some of them. I'd like to share my results.

### Openshift templates

![Openshift templates](assets/deploy2openshift-openshift-templates.png?raw=true "Openshift templates")

[Openshift templates](https://docs.openshift.com/container-platform/3.7/dev_guide/templates.html)

**Pros:**

* Native. It has awesome documentation.

**Cons:**

* Yet another YAML templates.
* Log horrible YAML file.
* You care about services dependencies.

### Scripts and template

![Custom scripts](assets/deploy2openshift-openshift-scripts.png?raw=true "Custom scrtipts")

**Pros:**

* Scripting.

**Cons:**

* Kludges.

### Terraform k8s provider

![Terraform k8s provider](assets/deploy2openshift-terraform.png?raw=true "Terraform k8s provider")

[Terraform k8s provider](https://www.terraform.io/docs/providers/kubernetes/index.html)

**Pros:**

* Don’t care about creating order.
* Re-use code as modules.
* You can add initialization logic.

**Cons:**

* No Openshift support, only k8s.
* Sometimes outdated.
* Yet another tool.

### Ansible-container

![Ansible-container](assets/deploy2openshift-ansible-container.png?raw=true "Ansible-container")

[Ansible-container](https://blog.openshift.com/ansible-container/)

**Pros:**

* One toolset for everything.

**Cons:**

* Looks abandon & out of date.

Ansible container was replaced by [Ansible bender](https://blog.tomecek.net/post/road-to-ansible-bender-0-2-0/).

### Ansible k8s module

![Ansible k8s module](assets/deploy2openshift-ansible.png?raw=true "Ansible k8s module")

[Ansible + k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html)

**Pros:**

* Single playbook for all.
* Re-use code as roles.
* You can add initialization logic.

**Cons:**

* No proxy support.
* You care about removing. If you want to remove something, then you must declare it.
* You care about creating order. You should deploy the application before initialization.

### Ansible Playbook Bundle

![Ansible Playbook Bundle](assets/deploy2openshift-apb.png?raw=true "Ansible Playbook Bundle")

> An Ansible Playbook Bundle (APB) is a lightweight application definition (meta-container). They are used to define and deploy complex groups of applications, deployment configs, deployments, and services to an OpenShift Origin cluster running the Ansible Service Broker. APBs offer more power and simple configuration by leveraging the power of Ansible. APBs have the following features:

![Ansible Playbook Bundle](assets/deploy2openshift-apb-descr.png?raw=true "Ansible Playbook Bundle")

The main idea is that you pack all needed thing into a container and run the container inside Openshift. [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle)

**Pros:**

* Bundles everything.
* Testable and reproducible.
* Service catalogue integration.

**Cons:**

* You need admin permissions.
* Documentation sometimes is out of date.

## Result

![Result](assets/deploy2openshift-result.png?raw=true "Result")

One one hand I don't want to be the final authority, but on the other hand, I'd like to share my point of view. There is no silver bullet exists.

* if you don't plan provide your application as a service then [Ansible k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html) is your choice.
* if you are going to provide your application as a service then you should go deeper in [automation broker](http://automationbroker.io/) and [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle).

## links

* [www.meetup.com/kubernetes-spb](https://www.meetup.com/kubernetes-spb)
* [t.me/k8spb](https://t.me/k8spb)
* [learn.openshift.com](https://learn.openshift.com/operatorframework)
* [Automate kubernetes with Ansible](http://ftp.belnet.be/mirror/FOSDEM/2019/UB2.252A/automate_kubernetes_ansible.mp4)
