---
redirect_from: "/gce4vpn.html"
---
# Openvpn inside kubernetes inside google cloud platform

![gce4vpn](assets/gce4vpn-intro.png?raw=true "gce4vpn")

It is text version of my [presentation](https://cloud.mail.ru/public/MK6G/DgNtrv5x5) at [chaos constructions 2018-08-26](https://chaosconstructions.ru/) & [Hashicorp meetup 2018-08-29](https://www.meetup.com/St-Petersburg-Russia-HashiCorp-User-Group/events/253644141/). This project was created just for luls:

* [video(RU) from hashicorp meetup](https://www.youtube.com/watch?v=BgOvc3pIJXo).
* [slides for chaos constructions](https://cloud.mail.ru/public/MK6G/DgNtrv5x5).
* [slides for hashicorp meetup](https://cloud.mail.ru/public/F193/yjoC7irob).
* [github.com/ultral/gce4vpn](https://github.com/ultral/gce4vpn).

## Main idea

![idea](assets/gce4vpn-idea.png?raw=true "idea")

I was using a network with a proxy server when I faced the issue that I should connect to a MySQL port. An application didn't support proxy. Eventually, I got a coupon for google cloud. As the result, I decided to create proof of concept: try OpenVPN inside kubernetes and connect to the MySQL through google cloud.

## Preparation

### Vagrant

![vagrant](assets/gce4vpn-vagrant.png?raw=true "vagrant")

First of all, I created a VM via vagrant with all needed tools. Vagrant is an infrastructure as code software by HashiCorp. Vagrant is a wrapper around hypervisors. It is cross-platform solutions, it might help you to unify your workflow in a team & create identical environments. There were docker, gcloud, terraform inside the VM, it was provisioned by [ansible](ansible.md)

### PKI

![pki](assets/gce4vpn-pki.png?raw=true "pki")

I decided to create a PKI infrastructure for my VPN solution. A public key infrastructure (PKI) is a set of roles, policies, and procedures needed to create, manage, distribute, use, store & revoke digital certificates and manage public-key encryption.

A PKI consists of some ideas:

* *Private key* - only the owner knows it.
* *Certificate Authority* - CA stores, issues and signs the digital certificates
* *Registration Authority* - RA verifies the identity of entities.
* Everyone doesn't trust anyone.
* Everyone trusts CA.
* Everyone has private & public keys.

### Terraform

![terraform](assets/gce4vpn-terraform.png?raw=true "terraform")

Terraform is an infrastructure as code software by HashiCorp. It might prevent you from vendor locking. It allows users to define a data centre infrastructure in a high-level configuration language. It supports clouds such as AWS, Google Cloud Platform, Microsoft Azure.

### Kubernetes

![k8s](assets/gce4vpn-k8s.png?raw=true "k8s")

Kubernetes is an open-source container-orchestration system for automating deployment, scaling and management of containerized applications. It aims to provide a "platform for automating deployment, scaling, and operations of application containers across clusters of hosts". A vast majority of cloud providers allows creating k8s installations as a service.

## Top level schema

![schema](assets/gce4vpn-schema.png?raw=true "schema")

I built the OpenVPN container. It allows to generate a PKI infrastructure, client/servers configs & run inside k8s. After that, I described the whole OpenVPN infrastructure in the Google Cloud Platform. The infrastructure consists of a PKI, a k8s and an OpenVPN server. I did some assumptions: the PKI infrastructure is stored at the VM & we don't use self-hosted k8s.

## Conclusion

![Conclusion](assets/gce4vpn-conclusion.png?raw=true "Conclusion")

As a result, it works. On one hand, there are some kludges, but on the other hand, it'had been helped to connect to the MySQL & is good enough as a Proof of Concept.

## Links

* [video from hashicorp meetup](https://www.youtube.com/watch?v=BgOvc3pIJXo).
* [slides for chaos constructions](https://cloud.mail.ru/public/MK6G/DgNtrv5x5).
* [slides for hashicorp meetup](https://cloud.mail.ru/public/F193/yjoC7irob).
* [github.com/ultral/gce4vpn](https://github.com/ultral/gce4vpn).
* [$500 for google cloud platform](https://about.gitlab.com/2018/04/05/gke-gitlab-integration/)
* [t.me/ru_hashicorp](https://t.me/ru_hashicorp)
* [t.me/k8spb](https://t.me/k8spb)
* [pieterlange/kube-openvpn](https://github.com/pieterlange/kube-openvpn)
* [zambien/terraform-gcp-gke-openvpn](https://github.com/zambien/terraform-gcp-gke-openvpn)
* [Hashicorp user group](https://www.meetup.com/St-Petersburg-Russia-HashiCorp-User-Group/events/253644141/)
* [chaos constructions](https://chaosconstructions.ru/)

### GCP

* [understanding service accounts](https://cloud.google.com/iam/docs/understanding-service-accounts)
* [understanding roles](https://cloud.google.com/iam/docs/understanding-roles)
* [Managing GCP projects via terraform](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform)
* [Bucket naming](https://cloud.google.com/storage/docs/naming)
* [control api callers](https://cloud.google.com/endpoints/docs/openapi/control-api-callers)
* [granting roles to service account](https://cloud.google.com/iam/docs/granting-roles-to-service-accounts)
* [control api access](https://cloud.google.com/endpoints/docs/openapi/control-api-access)
* [service management access control](https://cloud.google.com/service-infrastructure/docs/service-management/access-control)
