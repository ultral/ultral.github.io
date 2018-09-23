# Test me if you can. Do YML developers Dream of testing ansible?
It is text version of [presentation](https://cloud.mail.ru/public/2Rc8/EywUuHHp2) from [Saint-Petersburg Linux User Group](http://spblug.org/). Configuration example is located in [https://github.com/ultral/ansible-role-testing](https://github.com/ultral/ansible-role-testing)

# Introduction
Have you ever tested ansible roles? How do you do it? 

In my case we have:
* A lot of different ansible roles.
* Hyper-V hosts as hypervisor.
* A private cloud with limited possibility to create VMs on demand.
* A proxy for internet access.
* Inability test ansible roles inside docker, because of a role = whole VM configuration.
* Decision to implement green build policy for git repository with ansible roles.

# How to do it?

Let's compare solutions for testing.

|name          | [Test Kitchen](https://kitchen.ci/) | [Molecule](https://molecule.readthedocs.io) | Create new |
|--------------|-------------------------------------|---------------------------------------------|------------|
| language     | ruby                                | python                                      | bash/ruby  |
| Watchers     | 132                                 | 126                                         | 0          |
| Stars        | 1413                                | 1154                                        | 1          |
| Forks        | 502                                 | 174                                         | 2          |
| license      | Apache 2.0                          | MIT                                         | Any        |
| Commits      | 1929                                | 1264                                        | 0          |
| Celeases     | 101                                 | 121                                         | 0          |
| Contributors | 109                                 | 82                                          | 5          |

| name         | [testinfra](https://testinfra.readthedocs.io) | [serverspec](https://serverspec.org/) | [inspec](https://www.inspec.io/) | Goss |
|--------------|---|---|---|
| Github       | [philpep/testinfra](https://github.com/philpep/testinfra) | [mizzy/serverspec](https://github.com/mizzy/serverspec) | [chef/inspec](https://github.com/chef/inspec) | [aelsabbahy/goss](https://github.com/aelsabbahy/goss) |
| Language     | python     | ruby | ruby       | go   |
| Watchers     | 93         | 145  | 165        | 67   |
| Stars        | 997        | 2105 | 1167       | 2170 |
| Forks        | 138        | 361  | 330        | 156  |
| License      | Apache 2.0 | MIT  | Apache 2.0 | Apache 2.0 |
| Commits      | 380        | 1854 | 4609       | 309 |
| Releases     | 35         | 282  | 346        | 47 |
| Contributors | 43         | 110  | 159        | 31 |


We decided not to [reinvent the wheel](https://habr.com/post/342216/) & get production ready solution. Our infrastructure team had strong ruby skills & great experience with ruby, as a result we chose [Test Kitchen](https://kitchen.ci/) & [inspec](https://www.inspec.io/)

# Kitchen-CI
![kitchen-ci schema](assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

# Green Build Policy
![Green build policy schema](assets/Green-build-policy?raw=true "Green build policy schema")

# Nested virtualization
As you remember, we had a private cloud with limited possibility to create VMs on demand. We decided to create VMs inside VMs.

![we need to go deeper](assets/we-need-to-go-deeper.jpeg?raw=true "we need to go deeper")

First of all we tried to run Virtualbox x32 without nested. It was bad idea because of kernel panic. Also vast majority of our VMs in our infrastructure are x86_64, so we decided to continue research. As a result we decided to use nested virtualization. Hopefully it was supported by our our host servers.

# Faced issues
I was implementing testkitchen and faced with some issues. I'd like to describe them. 

## Pass proxy settings from host into testkitchen guest VM

In some test suits we setuped proxy client setings inside VMs created by testkitchen. However proxy wasn't configured on testkitchen host & ansible can't use extra vars with empty values

*Solution:* create erb template for setting default proxy if ENV vars is not set

```
<%= ENV['http_proxy'].to_s.empty? ? 'http://proxy.example.com:3128' : ENV['http_proxy'] %>
```

## Manage network settings via playbook

Some roles was configured network interfaces. Test suit was looked like:
* Deploy network settings to VMs
* Reload network
* It is failed

*Solution:* add interfaces to VMs

## Fail if suit cases contains "-" in name

Virtualbox can't use "_" in a vm name

*Solution:* rename suit cases "vm_" => "vm-"

## Oracle test fail without "." at the end of VM name
We use role in production, however when we decided to test it, it was failed. We reproduced it. 

I'd like to show clue. 

```
[root@vm-oracle vagrant]# getent ahosts vm-oracle
127.0.0.1 STREAM vm-oracle
127.0.0.1 DGRAM
127.0.0.1 RAW
[root@vm-oracle vagrant]# getent ahosts vm-oracle.
fe80::a00:27ff:febd:bd6a STREAM vm-oracle
fe80::a00:27ff:febd:bd6a DGRAM
fe80::a00:27ff:febd:bd6a RAW
10.0.2.15 STREAM
10.0.2.15 DGRAM
10.0.2.15 RAW
[root@oracle vagrant]# getent ahosts oracle.example.com.
192.168.128.182 STREAM oracle.example.local
192.168.128.182 DGRAM
192.168.128.182 RAW
```

Do you have any ideas what was happened? 

It is tricky bug:

1. we enabled listen IPv4 only in oracle listener settings
2. oracle used FQDN
3. linux contains special database "myhostname" for resolving hostname, it is uses after /etc/hosts & dns resolving
4. Vagrant created VM & updated `/etc/hosts`

I'd like to clarify it a bit more:
what's happened in case *vm-oracle*? 
1. vagrant created vm 
2. vagrant updated `/etc/hosts`(*vm-oracle* x2)
3. oracle listener listened IPv4
4. oracle listeners resolved *vm-oracle.* & geted IPv6
5. FAILED

what's happened in case *vm-oracle.*? 
1. vagrant created vm 
2. vagrant updated /etc/hosts ( *vm-oracle* &  *vm-oracle.*)
3. oracle listener listened IPv4
4. oracle listeners resolved *vm-oracle.* & geted IPv4
5. OK

## OOM is coming
OOM randomly was kiiling VMs. Testkitchen was failed with strange errors.

*Solution:*  increase RAM

## Slow builds
It was working slow

*Solutions:*
* [Packer](https://www.packer.io/). Prebuilded vagrant box with common tasks
* Concurrency

# Links
* [presentation](https://cloud.mail.ru/public/2Rc8/EywUuHHp2)
* [simple example](https://github.com/ultral/ansible-role-testing)
* [http://kitchen.ci/](http://kitchen.ci/)
* [https://t.me/pro_ansible](https://t.me/pro_ansible)
* [https://github.com/chef/kitchen-inspec](https://github.com/chef/kitchen-inspec)
* [https://docs.chef.io/config_yml_kitchen.html](https://docs.chef.io/config_yml_kitchen.html)
* [https://docs.chef.io/ctl_kitchen.html](https://docs.chef.io/ctl_kitchen.html)
* [https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md](https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md)



