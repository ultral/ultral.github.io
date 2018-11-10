# Test me if you can. Do YML developers Dream of testing ansible?
It is text version of [presentation](https://cloud.mail.ru/public/2Rc8/EywUuHHp2) from [Saint-Petersburg Linux User Group](http://spblug.org/). Configuration example locates at [https://github.com/ultral/ansible-role-testing](https://github.com/ultral/ansible-role-testing)

# Introduction
I suppose that that you [make configuration management, not bash](it/make-cm-not-bash-en.md). It means that you have to test it some how. Have you ever tested ansible roles? How do you do it? 

In my case, we have:
* A lot of different ansible roles.
* Hyper-V hosts as hypervisor.
* A private cloud with limited possibility to create VMs on demand.
* A proxy for internet access.
* Inability test ansible roles inside docker, because of a role = whole VM configuration.
* Decision to implement green build policy for git repository with ansible roles.

# How to do it?

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


We decided not to [reinvent the wheel](https://habr.com/post/342216/) & get production ready solution. Our infrastructure team had strong ruby skills & great experience with ruby, as a result we chose [Test Kitchen](https://kitchen.ci/) & [inspec](https://www.inspec.io/)

# Kitchen-CI
![kitchen-ci schema](assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

# Green Build Policy
![Green build policy schema](assets/Green-build-policy.png?raw=true "Green build policy schema")

# Nested virtualization
As you remember, we had a private cloud with limited possibility to create VMs on demand. We decided to create VMs inside VMs.

![we need to go deeper](assets/we-need-to-go-deeper.jpeg?raw=true "we need to go deeper")

First of all we tried to run Virtualbox x32 without nested. It was bad idea because of kernel panic. Also vast majority of our VMs in our infrastructure are x86_64, so we decided to continue research. As a result we decided to use nested virtualization. Hopefully it was supported by our host servers.

# Faced issues
I was implementing testkitchen and faced with some issues. You can read it [here](testkitchen-issues.md)

# Links
* [presentation](https://cloud.mail.ru/public/2Rc8/EywUuHHp2)
* [simple example](https://github.com/ultral/ansible-role-testing)
* [http://kitchen.ci/](http://kitchen.ci/)
* [https://t.me/pro_ansible](https://t.me/pro_ansible)
* [https://github.com/chef/kitchen-inspec](https://github.com/chef/kitchen-inspec)
* [https://docs.chef.io/config_yml_kitchen.html](https://docs.chef.io/config_yml_kitchen.html)
* [https://docs.chef.io/ctl_kitchen.html](https://docs.chef.io/ctl_kitchen.html)
* [https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md](https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md)



