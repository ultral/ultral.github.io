---
redirect_from: "/iac"
---
# Lessons learned from testiting Over 200 000 lines of Infrastructure Code
![Infrastructure as Code](assets/200k_iac.png?raw=true "Infrastructure as Code")

It is the translation of my speech ([video RU](https://www.youtube.com/watch?v=W53jMaebVJw)) at [DevopsConf 2019-05-28](http://devopsconf.io/moscow-rit/2019/abstracts/4906). 

**IaC** (Infrastructure as Code) is a modern approach and I believe that infrastructure is code. It means that we should use the same philosophy for infrastructure as for software development. If we are talking that infrastructure is code, then we should reuse  practices from development for infrastructure, i.e. unit testing, pair programming, code review. Please keep in mind this idea during reading the article.

* [English version](http://www.goncharov.xyz/iac)
* [Russian version](http://www.goncharov.xyz/it/200k_iac_ru.html)
* [Video(RU) from DevopsConf 2019-05-28](https://www.youtube.com/watch?v=W53jMaebVJw)
* [Video(RU) from DINS DevOps EVENING 2019-06-20](https://www.youtube.com/watch?v=kIGVTaTqnXI)
* [Slides](https://cloud.mail.ru/public/4GHk/3ig7qKCCr)

# Infrastructure as bash history

![Infrastructure as bash history](assets/200k_iabh.png?raw=true "Infrastructure as bash history")

Let us imagine that you are onboarding on a project and you hear something like: "We use *Infrastructure as Code* approach". Unfortunately, sometimes it means *Infrastructure as bash history* or *Documentation as bash history*. It is almost a real situation, i.e. Denis Lysenko described this situation at his speech [How to replace infrastructure and stop worrying(RU)](https://www.youtube.com/watch?v=Qf5xHuiYgN4). Denis shared the story how to convert bash history into upscale infrastructure. 

Let us check source code definition: `a text listing of commands to be compiled or assembled into an executable computer program`. If we want we can present *Infrastructure as bash history* like code. It is a text & it is a list of commands, it describes how a server was configured, moreover, it is: 
1. *Reproducible*: you can get bash history, execute commands and probably get working infrastructure.
2. *Versioning*: you know who logged in, when and what was done.
Unfotunately, if you lost server you will be able to do nothing because there is no bash history, you lot it with the server.

What is to be done?

# Infrastructure as Code

![Infrastructure as Code](assets/200k_iac_code.png?raw=true "Infrastructure as Code")

On the one hand, this abnormal case *Infrastructure as bash history* can be presented as *Infrastructure as Code*, but on the other hand, if you want to do something more complex than LAMP server, you have to manage, maintain, modify the code. Let us chat about parallels between *Infrastructure as Code* development and software development.

## D.R.Y.

![DRY](assets/200k_iac_code_dry_1.png?raw=true "DRY")

We were developing SDS (software-defined storage). The SDS consists of custom OS distributive, upscale servers, a lot of business logic, as a result, it has to use real hardware. There was sub-task periodically [install SDS](http://www.goncharov.xyz/it/how-to-test-custom-os-distr.html): before publishing new release we had to install it and check. At first look it is a very simple task:
* SSH to host and run command.
* SCP a file.
* Modify a config.
* Run a service.
* ...
* PROFIT!

I was believing [Make CM, not bash](http://www.goncharov.xyz/it/make-cm-not-bash-en.html) is a good point of view, however, there was no complex logic, so bash was a pretty good and reasonable choice.  Time was ticking, we were facing different requests to create new installations in a slightly different configuration. We were SSHing into installations,  and running the commands to install all needed software, editing the configuration files by scripts, and finally configuring SDS via Web HTTP rest API. After all that the installation was configured and working. This was pretty common practice, but there is a lot of bash scripts. 

Unfortunately, each script was like a little snowflake depending on who was copy-pasted it. It was also a real pain when we were creating or recreating installation.

I hope you have got the main idea, that at this stage we had to constantly tweak scripts logic until the service is ok. There is a solution for that. It is D.R.Y

![DRY](assets/200k_iac_code_dry_2.png?raw=true "DRY")
There is D.R.Y. (Do not Repeat Yourself) approach. The main idea is to reuse already existing code. It sounds extremely simple. In our case, D.R.Y. was meaning: split configs and scripts.

## S.O.L.I.D. for CFM

![SOLID](assets/200k_iac_solid.png?raw=true "SOLID")

The project was growing, as a result, we decided to use Ansible. There were reasons for that:
1. [Bash should not contain complex logic](http://www.goncharov.xyz/it/make-cm-not-bash-en.html).
2. We had some amount of expertise in Ansible.

There was an amount of business logic inside Ansible code. There is an approach for putting things in source code during the software development process. It is called *S.O.L.I.D.*. From my point of view, we can re-use *S.O.L.I.D.* for *Infrastructure as Code*. Let me explain step by step.

### The Single Responsibility Principle

![SOLID](assets/200k_iac_solid_s.png?raw=true "SOLID")

*A class should only have a single responsibility, that is, only changes to one part of the software's specification should be able to affect the specification of the class.*

You should not create a Spaghetti Code inside your infrastructure code. Your infrastructure should be made from simple predictable bricks. In other words, it might be a good idea to split immense Ansible playbook into independent Ansible roles. It will be easier to maintain.

### The Open-Closed Principle

![SOLID](assets/200k_iac_solid_o.png?raw=true "SOLID")

*Software entities ... should be open for extension, but closed for modification.*

In the beginning, we were deploying the SDS at virtual machines, a bit later we added deploy to bare metal servers. We had done it was as easy as pie for us because we just added an implementation for bare metal specific parts without modifying the SDS installation logic.

### The Liskov Substitution Principle

![SOLID](assets/200k_iac_solid_l.png?raw=true "SOLID")

*Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.*

Let us look wilder. *S.O.L.I.D.* it is possible to use in CFM in general, it was not a lucky project. I would like to describe another project. It is an out of box enterprise solution, it supports different databases, application servers and integration interfaces with third-party systems. I am going to use this example for describing the rest of *S.O.L.I.D.*.

I.e. in our case, inside infrastructure team there is an agreement: if you deploy ibm java role or oracle java or openjdk, you will have executable java binary. We need  it because top*level Ansible roles depend on that. Also, it allows us to swap java implementation without modifying application installing logic.

Unfortunately, there is no syntax sugar for that in Ansible playbooks it means that you must keep it in mind during developing Ansible roles. 

### The Interface Segregation Principle

![SOLID](assets/200k_iac_solid_i.png?raw=true "SOLID")

*Many client-specific interfaces are better than one general-purpose interface.*

In the beginning, we were putting application installation logic into the single playbook, we were trying to cover all cases and cutting edges. We had faced the issue that it is hard to maintain, so we changed our approach. We understood that a client needs an interface from us(i.e. https at 443 port) and we were able to combine our Ansible roles for each specific environment.

### The Dependency Inversion Principle

![SOLID](assets/200k_iac_solid_d.png?raw=true "SOLID")

*One should "depend upon abstractions, \[not\] concretions."*

* *High-level modules should not depend on low-level modules. Both should depend on abstractions (e.g. interfaces).*
* *Abstractions should not depend on details. Details (concrete implementations) should depend on abstractions.*

I would like to describe this principle via anti-pattern.

1. There was a customer with a private cloud.
2. We were requesting VMs in the cloud.
3. Our deploying logic was depending on which hypervisor a VM was located.

In other words, we were not able to reuse our IaC in another cloud because top-level deploying logic was depending on the lower-level implementation. **Please, don't do it**

# Interaction

![Interaction](assets/200k_int.png?raw=true "Interaction")

Infrastructure it is not only code, it is also about interaction code <-> DevOps, DevOps <-> DevOps, IaC <-> people.

## Bus factor

![Bus factor](assets/200k_int_bus.png?raw=true "Bus factor")

Let us imagine, there is DevOps engineer John. John knows everything about your infrastructure. If John got hit by a bus, what would happen? Unfortunately, it is almost a real case. Some time things happen. If it has happened and you do not share knowledge about IaC, Infrastructure among your team members you will face a lot of unpredictable & awkward consequences. There are some approaches for dealing with that. Let us chat about them.

## Pair DevOpsing

![Pair DevOpsing](assets/200k_int_pair.png?raw=true "Pair DevOpsing")

It is like pair programming. In other words, there are two DevOps engineers and they use single laptop\keyboard for configuring infrastructure: configuring a server, creating Ansible role, etc. It sounds great, however, it did not work for us. There were some custom cases then it partially worked.
* *Onboarding*: mentor & new person get a real task from a backlog and work together - transfer knowledge from mentor to the person.
* *incident call*: During troubleshooting, there is a group of engineers, they are looking for a solution. The key point is that there is a person who leads this incident. The person shares screen & ideas. Other people are carefully following him and noticing bash tricks, mistakes, logs parsing etc.

## Code Review

![Code review](assets/200k_int_code_review.png?raw=true "Code review")

From my point of view, *Code review* is one of the most efficient ways to share knowledge inside a team about your infrastructure. How does it work?
* There is a repository which contains your infrastructure description.
* Everyone is doing his changes in a dedicated branch.
* During merge request, you are able to review delta of changes your infrastructure.

The most interesting thing is that we were rotating a reviewer. It means that every couple of days we elected a new reviewer and the reviewer was looking through all merge request. As a result theoretically, every person had to touch a new part of the infrastructure and have average knowledge about our infrastructure in general.

### Code Style

![Code style](assets/200k_int_code_style.png?raw=true "Code style")

Time was going, we were arguing during review sometimes because reviewer and committer might use different code style: 2 spaces or 4, camelCase or snake_case. We implemented it, however, it was not a picnic.
* The first idea was to recommend to use linters. Everyone had his own development environment: IDE, OS.. it was tricky to sync & unify everything
* The idea evolved into a slack bot. After each commit the bot was checking source code & pushing into slack messages with a list of problems, unfortunately, in the vast majority of cases, there were no changes after messages.

### Green Build Master

![Green Build Master](assets/200k_int_code_gbm.png?raw=true "Green Build Master")

Next, the most painful step was to restrict commits into the master for everyone, only via merge requests & tests have to be ok. It is called *Green Build Master*. In other words, you are 100% sure that you can deploy your infrastructure from the master branch. It is a pretty common practice in software development:
* There is a repository which contains your infrastructure description.
* Everyone is doing his changes in a dedicated branch.
* For each branch, we are running tests.
* You are not able to merge into the master branch if tests are failing.

It was a tough decision, hopefully, as a result at review there was no arguing about code style and amount of smelling code was decreasing.

# IaC Testing

![IaC testing](assets/200k_testing.png?raw=true "IaC testing")

Besides code style checking, you are able to check that you can deploy or recreate your infrastructure in a sandbox. What's for? It is a sophisticated question and I would like to share a story instead of an answer. Were was a custom auto-scaler for AWS written in Powershell. The auto-scaler did not check cutting edges for input params, as a result, it created tons of virtual machines and the customer was unhappy. It is an awkward situation, hopefully, it is possible to catch it on the earliest stages.

On the one hand, it is possible to test the script & infrastructure, but on the other hand, you are an increasing amount of code and making infrastructure more complex. However, the real reason under the hood for that is that you are putting your knowledge about infrastructure into tests, you are describing how things should work together.

## IaC Testing Pyramid

![IaC testing pyramid](assets/200k_testing_pyramid.png?raw=true "IaC testing pyramid")

### IaC Testing: Static Analysis

You can create the whole infrastructure from scratch for each commit, but usually, there are some obstacles:
* The price is stratospheric.
* It requires a lot of time.

Hopefully, there are some tricks. You should have a lot of simple, rapid, primitive tests in your foundation.

#### Bash is tricky 

Let us take a look at an extremely simple example. I would like to create a backup script:
* Get all files from the current directory.
* Copy the files into another directory with a modified name.

The first idea is:
```
for i in * ; do 
    cp $i /some/path/$i.bak
done
```

Pretty good. However, what if the filename contains _space_? We are clever guys, we use quotes:
```
for i in * ; do 
    cp "$i" "/some/path/$i.bak"
done
```

Are we finished? Nope! What if the directory is empty? Globing fails in this case.
```
find . -type f -exec mv -v {} dst/{}.bak \;
```

Have we finished? Not yet... We forgot that filename might contain `\n` character.
```
touch x
mv x  "$(printf "foo\nbar")"
find . -type f -print0 | xargs -0 mv -t /path/to/target-dir
```

#### Static analysis tools

You can catch some issues from the previous example via [Shellcheck](https://www.shellcheck.net/). There are a lot of tools like that, they call linters and you can find out the most suitable for you IDE, stack, environment

| Language | Tool |
| --- | --- |
| bash | [Shellcheck](https://www.shellcheck.net/) |
| Ruby | [RuboCop](https://github.com/rubocop-hq/rubocop) |
| python | [Pylint](https://www.pylint.org/) |
| ansible  | [Ansible Lint](https://github.com/ansible/ansible-lint) |

### IaC Testing: Unit Tests

![IaC unit tests](assets/200k_testing_unit.png?raw=true "IaC unit tests")

As you can see linters can not catch everything, they can only predict. If we continue to think about parallels between software development and Infrastructure as Code we should mention unit tests. There are a lot of unit tests systems like [shunit](https://github.com/kward/shunit2), [JUnit](https://junit.org), [RSpec](https://rspec.info/), [pytest](https://docs.pytest.org). But have you ever heard about unit tests for Ansible, Chef, Saltstack, CFengine?

When we were talking about *S.O.L.I.D.* for CFM, I mentioned that our infrastructure should be made from simple bricks/modules. Now the time has come:
1. Split infrastructure into simple modules/breaks, i.e. Ansible roles.
2. Create an environment i.e. Docker or VM.
3. Apply your one simple break/module to the environment.
4. Check that everything is ok or not.
...
6. PROFIT!

#### IaC Testing: Unit Testing tools

What is the test for CFM and your infrastructure? i.e. you can just run a script or you can use production-ready solution like:

| CFM | Tool |
| --- | --- |
| Ansible | [Testinfra](https://testinfra.readthedocs.io/en/latest/) |
| Chef | [Inspec](https://www.inspec.io/) |
| Chef | [Serverspec](https://serverspec.org/) |
| saltstack | [Goss](https://github.com/aelsabbahy/goss) |

Let us take a look at testinfra, I would like to check that users `test1`, `test2` exist and their are part of `sshusers` group:
```
def test_default_users(host):
    users = ['test1', 'test2' ]
    for login in users:
        assert host.user(login).exists
        assert 'sshusers' in host.user(login).groups
```

What is the best solution? There is no single answer for that question, however, I created the heat map and compared changes in this  projects during 2018-2019:

![IaC unit tests](assets/200k_testing_unit_compare.png?raw=true "IaC unit tests tools")

#### IaC Testing frameworks

After that, you can face a question how to run it all together? On the one hand, you can [do everything on your own](http://www.goncharov.xyz/it/how-to-test-custom-os-distr.html) if you have enough great engineers, but on the other hand, you can use opensource production-ready solutions:

| CFM | Tool |
| --- | --- |
| Ansible | [Molecule](https://molecule.readthedocs.io) |
| Chef | [Test Kitchen](https://docs.chef.io/kitchen.html) |
| Terraform | [Terratest](https://github.com/gruntwork-io/terratest) |

I created the heat map and compared changes in this  projects during 2018-2019:

![IaC unit tests](assets/200k_testing_framework_compare.png?raw=true "IaC testing frameworks")

#### Molecule vs. Testkitchen

![Molecule vs. Testkitchen](assets/200k_testing_unit_kitchen.png?raw=true "Molecule vs. Testkitchen")

In the beginning, we tried to [test ansible roles via testkitchen inside hyper-v](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html):
1. Create VMs.
2. Apply Ansible roles.
3. Run Inspec.
 
It took 40-70 minutes for 25-35 Ansible roles. It was too long for us.

![Molecule vs. Testkitchen](assets/200k_testing_unit_molecule.png?raw=true "Molecule vs. Testkitchen")

The next step was use Jenkins / docker / Ansible / molecule. It is approximately the same idea:
1. Lint Ansible playbooks.
2. Lint Ansible roles.
3. Run a docker container.
4. Apply Ansible roles.
5. Run testinfra.
6. Check idempotency.

![Molecule](assets/molecule.png?raw=true "molecule")

Linting for 40 roles and testing for ten of them took about 15 minutes.

![Molecule vs. Testkitchen](assets/200k_testing_molecule_vs_testkitchen.png?raw=true "Molecule vs. Testkitchen")

What is the best solution? On the one hand, I do not want to be the final authority, but on the other hand, I would like to share my point of view. There is no silver bullet exists, however, in case of Ansible molecule is a more suitable solution then testkitchen. 

### IaC Testing: Integration Tests

![IaC Integration Tests](assets/200k_testing_integration.png?raw=true "IaC Integration Tests")

On the next level of *IaC testing pyramid*, there are *integration tests*. Integration tests for infrastructure look like unit tests:
1. Split infrastructure into simple modules/breaks, i.e. Ansible roles.
2. Create an environment i.e. Docker or VM.
3. Apply *a combination* of simple break/module to the environment.
4. Check that everything is ok or not.
...
6. PROFIT!

In other words, during unit tests, we check one simple module(i.e. Ansible role, python script, Ansible module, etc) of an infrastructure, but in the case of integration tests, we check the whole server configuration.

### IaC Testing: End to End Tests

![IaC testing pyramid](assets/200k_testing_pyramid.png?raw=true "IaC testing pyramid")

On top of the *IaC testing pyramid*, there are *End to End Tests*. In this case, we do not check dedicated server, script, module of our infrastructure; We check the whole infrastructure together works properly. Unfortunately, there is no out of the box solution for that or I have not heard about them(please, flag me if you know about them). Usually, people reinvent the wheel, because, there is demand on end to end tests for infrastructure. So, I would like to share my experience, hope it will be useful for somebody.

![IaC End to End Tests](assets/200k_testing_e2e_1.png?raw=true "IaC End to End Tests")

First of all, I would like to describe the context. It is an out of box enterprise solution, it supports different databases, application servers and integration interfaces with third-party systems. Usually, our clients are an immense enterprise with a completely different environment. We have knowledge about different environments combinations and we store it as different docker-compose files. Also, there matching between docker-compose files and tests, we store it as Jenkins jobs.

![IaC End to End Tests](assets/200k_testing_e2e_2.png?raw=true "IaC End to End Tests")

This scheme had been working quiet log period of time when during [openshift research](http://www.goncharov.xyz/it/deploy2openshift-en.html) we tried to migrate it into Openshift. We used approximately the same containers (hell  D.R.Y. again) and change the surrounding environment only.

![IaC End to End Tests](assets/200k_testing_e2e_3.png?raw=true "IaC End to End Tests")

We continue to research and found [APB](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle) (Ansible Playbook Bundle). The main idea is that you pack all needed things into a container and run the container inside Openshift. It means that you have a reproducible and testable solution.

![IaC End to End Tests](assets/200k_testing_e2e_4.png?raw=true "IaC End to End Tests")

Everything was fine until we faced one more issue: we had to maintain heterogeneous infrastructure for testing environments. As a result, we store our knowledge of how to create infrastructure and run tests in the Jenkins jobs.

# Conclusion

![Infrastructure as Code](assets/200k_iac.png?raw=true "Infrastructure as Code")
Infrastructure as Code it is a combination of: 
* Code.
* People interaction.
* Infrastructure testing.

# Links
* [English version](http://www.goncharov.xyz/iac)
* [Russian version](http://www.goncharov.xyz/it/200k_iac_ru.html)
* [Video(RU) from DevopsConf 2019-05-28](https://www.youtube.com/watch?v=W53jMaebVJw)
* [Video(RU) from DINS DevOps EVENING 2019-06-20](https://www.youtube.com/watch?v=kIGVTaTqnXI)
* [Let us deploy to openshift](http://www.goncharov.xyz/it/deploy2openshift-en.html)
* [Test me if you can. Do YML developers Dream of testing ansible?](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html)
* [How-to test your own OS distribution](http://www.goncharov.xyz/it/how-to-test-custom-os-distr.html)
* [Lessons Learned From Writing Over 300,000 Lines of Infrastructure Code](https://www.youtube.com/watch?v=RTEgE2lcyk4) & [text version](https://www.hashicorp.com/resources/lessons-learned-300000-lines-code)
* [Integrating Infrastructure as Code into a Continuous Delivery Pipeline](https://www.youtube.com/watch?v=wTunI1mZyp8)
* [Тестируем инфраструктуру как код](http://rootconf.ru/2015/abstracts/1761)
* [Эффективная разработка и сопровождение Ansible-ролей](https://www.youtube.com/watch?v=IzJsBUPXfkE)
* [Ansible — это вам не bash!](https://www.youtube.com/watch?v=LApKSi5tUYo)
