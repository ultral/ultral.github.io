---
redirect_from: 
    - /ymldev
    - /ymldev.html
    - /it/testkitchen-issues.html
    - /it/test-ansible-roles-via-testkitchen-inside-hyperv.html
---

# Test me if you can. Do YML developers Dream of testing ansible?

![kitchen-ci schema](assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

* [Russian version](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv-ru.html)

It is text version of [presentation 2018-04-25](https://cloud.mail.ru/public/DBuA/7sEMAMRyH) from [Saint-Petersburg Linux User Group](http://spblug.org/).

* [Slides](https://cloud.mail.ru/public/DBuA/7sEMAMRyH)
* [Russian version](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv-ru.html)
* [English version](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html)
* [Crosspost Russian version](https://habr.com/en/post/437004/)
* [Crosspost English version](https://habr.com/en/post/436960/)
* Configuration example: [github.com/ultral/ansible-role-testing](https://github.com/ultral/ansible-role-testing)

## Introduction

I suppose that that you [make configuration management, not bash](make-cm-not-bash-en.md). It means that you have to test it some how. Have you ever tested ansible roles? How do you do it?

In my case, we have:

* A lot of different ansible roles.
* Hyper-V hosts as hypervisor.
* A private cloud with limited possibility to create VMs on demand.
* A proxy for internet access.
* Inability test ansible roles inside docker, because of a role = whole VM configuration.
* Decision to implement green build policy for git repository with ansible roles.

## How to do it?

Let us compare solutions for testing.

| Name         | [Test Kitchen](https://kitchen.ci/) | [Molecule](https://molecule.readthedocs.io) | Create new |
|--------------|-------------------------------------|---------------------------------------------|------------|
| Language     | ruby                                | python                                      | bash/ruby  |
| Watchers     | 132                                 | 126                                         | 0          |
| Stars        | 1413                                | 1154                                        | 1          |
| Forks        | 502                                 | 174                                         | 2          |
| License      | Apache 2.0                          | MIT                                         | Any        |
| Commits      | 1929                                | 1264                                        | 0          |
| Releases     | 101                                 | 121                                         | 0          |
| Contributors | 109                                 | 82                                          | 5          |

| Name         | [testinfra](https://testinfra.readthedocs.io) | [serverspec](https://serverspec.org/) | [inspec](https://www.inspec.io/) | Goss |
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

We decided not to [reinvent the wheel](http://www.goncharov.xyz/it/how-to-test-custom-os-distr.html) & get production ready solution. Our infrastructure team had strong ruby skills & great experience with ruby, as a result we chose [Test Kitchen](https://kitchen.ci/) & [inspec](https://www.inspec.io/)

### Kitchen-CI

![kitchen-ci schema](assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

## Green Build Policy

![Green build policy schema](assets/Green-build-policy.png?raw=true "Green build policy schema")

## Nested virtualization

As you remember, we had a private cloud with limited possibility to create VMs on demand. We decided to create VMs inside VMs.

![we need to go deeper](assets/we-need-to-go-deeper.jpeg?raw=true "we need to go deeper")

First of all we tried to run Virtualbox x32 without nested. It was bad idea because of kernel panic. Also vast majority of our VMs in our infrastructure are x86_64, so we decided to continue research. As a result we decided to use nested virtualization. Hopefully it was supported by our host servers.

## Faced issues

I was implementing testkitchen and faced with some issues.

### Pass proxy settings from host into testkitchen guest VM

In some test suits, we configured proxy client settings inside VM created by testkitchen. However, proxy was not configured on testkitchen host & ansible cannot use extra variables with empty values

*Solution:* create erb template for setting default proxy if ENV variables is not set

```ruby
<%= ENV['http_proxy'].to_s.empty? ? 'http://proxy.example.com:3128' : ENV['http_proxy'] %>
```

#### Manage network settings via playbook

Some roles configure network interfaces. Test suit was looked like:

* Deploy network settings to VMs
* Reload network
* It is failed

*Solution:* add interfaces to VMs

### Fail if suit cases contains "-" in name

Virtualbox can't use "_" in a vm name

*Solution:* rename suitcases "vm_" => "vm-"

### Oracle test fails without "." at the end of VM name

We use role in production, however when we decided to test it, it was failed. We reproduced it. 

I would like to show clue.

```bash
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

Do you have any ideas what is happening?

It is tricky bug:

1. we enabled listen IPv4 only in oracle listener settings
2. oracle used FQDN
3. linux contains special database "myhostname" for resolving hostname, it is uses after /etc/hosts & dns resolving
4. Vagrant created VM & updated `/etc/hosts`

I'd like to clarify it a bit more:
What has happened in case *vm-oracle*?

1. vagrant created vm 
2. vagrant updated `/etc/hosts`(*vm-oracle* x2)
3. oracle listener listened IPv4
4. oracle listeners resolved *vm-oracle.* & geted IPv6
5. FAILED

What has happened in case *vm-oracle.*?

1. vagrant created vm 
2. vagrant updated /etc/hosts ( *vm-oracle* &  *vm-oracle.*)
3. oracle listener listened IPv4
4. oracle listeners resolved *vm-oracle.* & geted IPv4
5. OK

### OOM is coming
OOM randomly was killing VMs. Testkitchen was failed with strange errors.

*Solution:*  increase RAM

### Slow builds

It was working slowly

*Solutions:*

* [Packer](https://www.packer.io/). Prebuilded vagrant box with common tasks
* Concurrency

## Conclusion

![molecule](assets/molecule.png?raw=true "molecule")

On one hand, current implementation works, but on the other hand, there are some issues

* is not user friendly.
* we mix ruby & python.
* there is no indepotence check.
* it works slow.
* it is hard to trace logs at single job.

As a result, molecule & docker might be pretty interesting solution.

## Links

* [presentation](https://cloud.mail.ru/public/DBuA/7sEMAMRyH)
* [simple example](https://github.com/ultral/ansible-role-testing)
* [http://kitchen.ci/](http://kitchen.ci/)
* [https://t.me/pro_ansible](https://t.me/pro_ansible)
* [https://github.com/chef/kitchen-inspec](https://github.com/chef/kitchen-inspec)
* [https://docs.chef.io/config_yml_kitchen.html](https://docs.chef.io/config_yml_kitchen.html)
* [https://docs.chef.io/ctl_kitchen.html](https://docs.chef.io/ctl_kitchen.html)
* [https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md](https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md)
