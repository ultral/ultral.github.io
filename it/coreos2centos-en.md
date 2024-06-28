---
redirect_from:
    - /it/coreos2centos.html
    - /cca
---
# Ansible: CoreOS to CentOS, 18 months long journey

![intro](assets/c2a_map.png?raw=true "intro")

* [Russian Version](coreos2centos-ru.md)

It is text version of my speech at [DevopsConf 2019-10-01](https://devopsconf.io/moscow/2019/meetups#2331050) and [SPbLUG 2019-09-25](http://spblug.org/) [slides](https://cloud.mail.ru/public/UDCZ/WM4Y9Qv3j).

There was a custom configuration management solution.
*I would like to share the story about a project. The project used to use a custom configuration management solution. Migration lasted 18 months. You can ask me 'Why?'. There are some answers below about changing processes, agreements and workflows.*

## Day № -ХХХ: Before the beginning

![CFM 2 Ansible](assets/c2a_state_1.png?raw=true "CFM 2 Ansible")

The infrastructure looked like a bunch of standalone Hyper-V servers. In case of creating a VM we had to perform some actions:

* Put the VM hard drives to a special place.
* Create a DNS record.
* Create a DHCP reservation.
* Save the VM configuration to a git repo.

It was a partially automated process. Unfortunately, we had to manage used resources & VMs locations manually. Hopefully, developers were able to change VMs configuration in the git repo, reboot VM and, as a result, get VM with the desired configuration.

### Custom Configuration Management Solution

![CFM 2 Ansible](assets/c2a_vm_mgmt_workflow_1.png?raw=true "CFM 2 Ansible")

I guess the original approach was to have IaC. It had to be a bunch of stateless VMs. Those VMs had reset they state after reboot. How did it look like?

1. We create MAC address reservation.
2. We mount ISO & special bootable hard drive to a VM.
3. CoreOS starts OS customization: download the appropriate script(based on the IP) from a web server.
4. The script downloads the rest of configuration via SCP.
5. The rest of the configuration is a bunch of systemd units, compose files & bash scripts.

![CFM 2 Ansible](assets/c2a_kernel_panic.png?raw=true "CFM 2 Ansible")

There were some flaws:

1. ISO was CoreOS deprecated way of booting for CoreOS.
2. Too many manual actions.
3. Hard to update, tricky to maintain.
4. Nightmare in case of installing specific kernel modules.
5. State full VMs instead of original approach with stateless VMs.
6. From time to time people created broken dependencies across systemd unit files, as a result, CoreOS was not able to reboot without magic sys rq.
7. secret management.

It was possible to say that there was no CM. There was a pile of organized bash scripts & systemd unit files.

## Day №0: Ok. We have a problem

![CFM 2 Ansible](assets/c2a_map.png?raw=true "CFM 2 Ansible")

It was a standard environment for developing and testing: Jenkins, test environments, monitoring, registry, etc. CoreOS developes created it as a underlying OS for k8s or rancher. So, we had a problem what we used a good tool, in the wrong way. The first step was to determine the desired technologies stack. Our idea was:

1. **CentOS** as base OS, because it was close enough to a productions environments.
2. **Ansible** for configuration management, because we had enough expertise.
3. **Jenkins** as a framework for automating our workflow, agreements and process. We used it because we had it before as part release workflow.
4. **Hyper-V** virtualization platform. There were some reasons out of scope. To make a short story long: we were not allowed to use public clouds & we had to use MS in our infrastructure.

### Day №30: Agreements as Code

![CFM 2 Ansible](assets/c2a_vm_mgmt_workflow_2.png?raw=true "CFM 2 Ansible")

The next step was to put met requirements, to establish contracts or in other words to have **Agreements as Code**. It had to be *manual actions* -> *mechanization* -> *automatization*.

There were some processes. *Let us chat about them separately*

#### 1. Configure VMs

![CFM 2 Ansible](assets/c2a_flow_configure_vms.png?raw=true "CFM 2 Ansible")

1. Created a git repository.
2. Put VMs list into inventory; Configuration into playbooks & roles.
3. Configured a dedicated Jenkins slave for running Ansible playbooks.
4. Created & configured Jenkins pipeline.

#### 2. Create new VM

![CFM 2 Ansible](assets/c2a_flow_new_vm.png?raw=true "CFM 2 Ansible")

It was not a picnic. It was a bit tricky to create a VM at Hyper-V from Linux:

1. Ansible connected via WinRM to a windows host.
2. Ansible ran powershell script.
3. The PowerShell created a new VM.
4. The Hyper-V/ScVMM customized the VM i.e. hostname.
5. VM with DHCP request sent hostname.
6. Integration ddns & DHCP on Domain Controller side configured DNS record.
7. We added the VM into Ansible inventory & apply the configuration.

#### 3. Create VM template

![CFM 2 Ansible](assets/c2a_flow_template.png?raw=true "CFM 2 Ansible")

We decided not to reinvent the wheel and use the packer:

1. Put packer config & kickstart file into the git repository.
2. Configured Jenkins slave with hyper-v & Packer.
3. Created & configured Jenkins pipeline.

It worked really easy:

1. Packer created an empty VM & mounted an ISO.
2. VM booted, Packer typed a boot command into the grub
3. Grub got kickstart file from the packer web server or floppy drive provided by the packer.
4. Anaconda started with the kickstart file & installed base OS.
5. Packer was waiting for available SSH connection to the VM.
6. Packer ran Ansible in local mode inside the VM.
7. Ansible used exactly the same roles as in the use case №1.
8. Packer exported the template.

### Day №75: Refactor agreements & break nothing = Test Ansible roles

![CFM 2 Ansible](assets/at_review_1.png?raw=true "CFM 2 Ansible")

Agreements as Code was not enough for us. The amount of IaC was increasing, agreements were changing.We faced a problem about how to sync our knowledge about infrastructure across the team. The solution was to test Ansible roles. You can read the article about that process [Test me if you can. Do YML developers Dream of testing Ansible?](test-ansible-roles-via-testkitchen-inside-hyperv-en.md) or more general [How to test Ansible and don't go nuts](ansible-testing-en.md).

### Day №130: What is about Openshift? is it better then Ansible + CentOS?

As I mentioned our infrastructure was like a creature. It was alive. It was growing. It was changing. As a part of that process & development process, we had to research was it possible or not to run our application inside Openshift/k8s. *It is better to read* [Let's deploy to Openshift](deploy2openshift-en.md). Unfortunately, we were not able to re-use Openshift inside development infrastructure.

### Day №170: Let us try Windows Azure Pack

![CFM 2 Ansible](assets/c2a_cloud_azure_pack.png?raw=true "CFM 2 Ansible")

Hyper-V & SCVMM were not user friendly for us. There was much more interesting thing - Windows Azure Pack. It was an SCVMM extension. It looked like Windows Azure, it provided HTTP REST API. Unfortunately, in reality, it was an abandoned project. However, we spent time on research.

### Day №250: Windows Azure Pack is so so. SCVMM is our choice

![CFM 2 Ansible](assets/c2a_cloud_scvmm.png?raw=true "CFM 2 Ansible")

Windows Azure Pack looked interesting, but we decided it was too risky to use. We used SCVMM.

### Day №360: Yak shaving

![CFM 2 Ansible](assets/c2a_yac_shaving.png?raw=true "CFM 2 Ansible")

As you can see, a year later we had the foundation for starting the migration. The migration had to be *S.M.A.R.T.*. We created the list of VMs & started yak shaving. We were dealing one by one with each old VM, create Ansible roles & cover them by tests.

### Day №450: Migration

![CFM 2 Ansible](assets/tm-pareto-principle.png?raw=true "CFM 2 Ansible")

Migration was prune determined process. It followed the Pareto principle:

* 80% of the time was spent on preparation & 20% on migration.
* 80% VMs configuration rewriting took 20% of our time.

## Day №540: Lessons learned

![CFM 2 Ansible](assets/c2a_transform.png?raw=true "CFM 2 Ansible")

1. **Agreements as Code**.
2. **Manual actions** -> **mechanization** -> **automatization**.

## Links

* [Cross post](https://habr.com/en/post/500350/)
* [slides](https://cloud.mail.ru/public/UDCZ/WM4Y9Qv3j)
* [How to test Ansible and don't go nuts](ansible-testing-en.md)
* [Lessons learned from testing Over 200,000 lines of Infrastructure Code](200k-iac-en.md)
* [Let's deploy to Openshift](deploy2openshift-en.md)
* [Test me if you can. Do YML developers Dream of testing Ansible?](test-ansible-roles-via-testkitchen-inside-hyperv-en.md)
