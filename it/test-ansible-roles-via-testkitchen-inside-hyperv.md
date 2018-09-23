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
![kitchen-ci schema](it/assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

# Green Build Policy
![Green build policy schema](it/assets/kitchen-ci-schema.png?raw=true "Green build policy schema")
