---
redirect_from:
  - /ar
  - /it/ansible-testing.html
  - /it/ansible-testing.md
---
# How to test Ansible and don't go nuts

![Ansible refactoring](assets/at_intro.png?raw=true "Ansible refactoring")

It is the translation of my [speech](https://www.youtube.com/watch?v=GdrJv5oypfg) at [DevOps-40 2020-03-18](https://www.meetup.com/DevOps-40/events/269140089/):

* [Slides](https://cloud.mail.ru/public/266x/3hJ2mQBzf)
* [Video](https://www.youtube.com/watch?v=GdrJv5oypfg)
* [Russian version](http://www.goncharov.xyz/it/ansible-testing-ru.html)
* [English version](http://www.goncharov.xyz/it/ansible-testing-en.html)

After the second commit, each code becomes legacy. It happens because the original ideas do not meet actual requirements for the system. It is not a bad or good thing. It is the nature of infrastructure & agreements between people. Refactoring should align requirements & actual state. Let me call it Infrastructure as Code refactoring.

## Legacy interception

### Day № 1: Patient zero

![Ansible refactoring](assets/at_dev_ops.png?raw=true "Ansible refactoring")

There was a project. It was a casual project, nothing special. There were operations engineers and developers. They were dealing with exactly the same task: how to provision an application. However, there was a  problem: each team tried to it do in a unique way. They had decided to deal with it & use Ansible as the source of the truth.

### Day № 89: Legacy arise

![Ansible refactoring](assets/at_pasta_legacy.png?raw=true "Ansible refactoring")

Time was ticking. They were doing as much as possible. Unfortunately, they got legacy. How did this happen?

* There was a bunch of ASAP tasks.
* It was ok not to write the documentation.
* They didn't have enough knowledge about Ansible.
* Maybe, there were some Full Stack Overflow Developers - it was ok to copy-paste a solution from the StackOverflow.
* There was lack communication.

The reasons were well known. There was nothing special. It was a standard process. IaC was behaving like code: it was becoming outdatedж it had to be maintained & actualized.

### Day № 109: Ok, we have the problem. What's next?

![Ansible refactoring](assets/at_road_to_success.png?raw=true "Ansible refactoring")

Original idea / model of IaC became outdated & stuck. IaC did not meet business / customers / users requirements. It became hard to maintain the IaCж they were wasting time struggling with kludges. It was an epiphany moment.

## Refactoring IaC

### Day № 139: Do you really need IaC refactoring?

![Ansible refactoring](assets/at_refactoring.png?raw=true "Ansible refactoring")

*First of all before refactoring you must answer three simple questions:*

1. *Do I have a reason?*
2. *Do I have enough time?*
3. *Do I have enough knowledge about it?*

*If your answers are no, then refactoring might be a problem or a challenge for you. You can do things worse.*

In our case, the project knew that our infrastructure team had a pretty good experience in the IaC refactoring ([Lessons learned from testing Over 200,000 lines of Infrastructure Code](http://www.goncharov.xyz/it/200k_iac_en.html)), so our infrastructure team kindly agreed to help with refactoring. It was part of our daily routine to refactor the project.

### Day № 149: Prepare to refactor

![Ansible refactoring](assets/at_main_concept.png?raw=true "Ansible refactoring")

First of all, we had to determine the goal. We were talking, delve deep into the processes & researching how to deal with the problems. After researches, we made & presented the main concept. The main idea was to split infrastructure code into small parts and deal with each part separately. It allowed us to cover by tests each piece of the infrastructure and understood the functionality of that piece of infrastructure. As a result, we were able to refactor infrastructure little by little without breaking the agreements.

![Ansible refactoring](assets/200k_testing_pyramid.png?raw=true "Ansible refactoring")

*Let me mention about the IaC testing pyramid. If we are talking that Infrastructure is Code, then we should reuse practices from development for infrastructure, i.e. unit testing, pair DevOpsing, code review.. etc.. One of these approaches is a software testing & using testing pyramid for that. My idea is:*

* *__static__ - shellcheck/ansible lint*
* *__unit__ - molecule/kitchen + testinfra/inspec for basic blocks: modules, roles, etc*
* *__integration__ - check whole server configuration - group of roles. again molecule/kitchen*
* *__e2e(end to end)__ - check that group of servers work correctly as an infrastructure*

#### How to test Ansible?

*Before the other part of the story let me share my attempts to test Ansible before that project. It is important because I want to share the context.*

##### Day № -997: SDS provision

![Ansible refactoring](assets/at_ostest.png?raw=true "Ansible refactoring")

It was a couple of projects before. We were developing SDS (Software Defined Storage). That was software and hardware appliance. The appliance consisted of custom OS distributive, upscale servers, a lot of business logic. As part of SDS, we had a bunch of processes i.e. how to provision the SDS installation. For provisioning we used Ansible. To make a short story long: we had reverted IaC testing pyramid. We had an e2e test and they lasted 60-90 minutes. It was too slow. The main idea was to create the installation & emulate an user activity(i.e. mount iSCSI & write something). We created the IaC testing solution.

*You can read a bit more:* [How to test your own OS distribution](how-to-test-custom-os-distr-en.md).

##### Day № -701: Ansible & test kitchen

![Ansible refactoring](assets/at_kitchen_1.png?raw=true "Ansible refactoring")

The next idea was not to reinvent the wheel & use production-ready solution, i.e. test kitchen / kitchen-ci & inspec. We decided to use it because we had enough expertise in the Ruby world. We were creating VMs inside a VM. It was working more or less fine: 40 minutes for 10 roles.

*You can read a bit more:* [Test me if you can. Do YML developers Dream of testing ansible?](test-ansible-roles-via-testkitchen-inside-hyperv-en.md).

![Ansible refactoring](assets/at_kitchen_2.png?raw=true "Ansible refactoring")

In general, it was a stable solution. However, when we increased the number of tested roles to 15(13 base roles + 2 meta roles) we faced an issue. The speed of tests felt down dramatically to 70 minutes. It was to slow. We were not able to think about XP (extreme programming) practices.

##### Day № -601: Ansible & molecule

![Ansible refactoring](assets/at_molecule_unit_1.png?raw=true "Ansible refactoring")

It triggered us to use *molecule* & *docker*. As a result, we had 20-25 minutes for 7 roles.

![Ansible refactoring](assets/at_molecule_unit_2.png?raw=true "Ansible refactoring")

We increased the number of tested roles to 17 & linted playbooks to 45. It lasted about 28 minutes with 2 Jenkins slaves.

### Day № 167: Introduce tests to the project

![Ansible refactoring](assets/at_yac_shaving_1.png?raw=true "Ansible refactoring")

It was a bad idea to test all roles from the very beginning. Because it was an immense change. We wanted to change the project little by little and avoid problems. So, we arranged the S.M.A.R.T. goal lint all roles. We were enabling linting roles/playbooks one by one. It was yak shaving: we were slowly improving the project and creating the culture.

![Ansible refactoring](assets/at_yac_shaving_2.png?raw=true "Ansible refactoring")

*It is not really important how to shave the yak. It might be stickers on the wardrobe, tasks in the Jira or spreadsheet in the google docs. The main idea you should track current status & understand how it is going. You should not burn out during refactoring, because it is a long boring journey.*

*Refactoring is easy as pie:*

* *Eat.*
* *Sleep.*
* *Code.*
* *IaC test.*
* *Repeat*

![Ansible refactoring](assets/at_lint.png?raw=true "Ansible refactoring")

So, we with started from the linting. It was a good start point.

### Day № 181: Green Build Master

![Ansible refactoring](assets/200k_int_code_gbm.png?raw=true "Ansible refactoring")

Linting was the very first step to the Green Build Master. I costed almost nothing, but it created good habits & processes inside the team:

* Red test is bad, you should fix it.
* If you see code smell - improve it.
* Code must be better after you.

### Day № 193: Linting -> Unit tests

![Ansible refactoring](assets/at_molecule_unit_3.png?raw=true "Ansible refactoring")

We had processes how to change the master branch. The next step was to replace linting via real roles applying. We had to understand how roles were implemented and why.

### Day № 211: Unit tests -> Integration tests

![Ansible refactoring](assets/at_integration_1.png?raw=true "Ansible refactoring")

We finished with unit tests. The vas majority of roles were tested after each commit. The next step was the integration tests. We had to test the combination of simple bricks which creates the building - whole server configuration.

![Ansible refactoring](assets/at_integration_2.png?raw=true "Ansible refactoring")

We were generating bunch of stages. The stages were executing simultaneously.

#### Jenkins + Docker + Ansible = Tests

![Ansible refactoring](assets/at_integration_3.png?raw=true "Ansible refactoring")

1. Checkout repo and generate build stages.
2. Run lint playbook stages in parallel.
3. Run lint role stages in parallel.
4. Run syntax check role stages in parallel.
5. Run test role stages in parallel.
    1. Lint role.
    2. Check dependency on other roles.
    3. Check syntax.
    4. Create docker instance
    5. Run molecule/default/playbook.yml.
    6. Check idempotency.
6. Run integration tests
7. Finish

### Day № 271: Bus Factor

![Ansible refactoring](assets/at_review_1.png?raw=true "Ansible refactoring")

At the beginning of the project, there were a small amount of people. They were reviewers. Time was ticking and knowledge on how to write ansible roles were spread across all teams members. The interesting thing was that we were rotating reviewer on the 2 weeks basis.

![Ansible refactoring](assets/at_review_2.png?raw=true "Ansible refactoring")

The review had to be simple & reviewer friendly. So, we integrated Jenkins + bitbucket + Jira for that. Unfortunately, the review is not a silver bullet. I.e. we missed bad code to the master and had flapped unstable tests.

```YML
- get_url:
    url: "{{ actk_certs }}/{{ item.1 }}"
    dest: "{{ actk_src_tmp }}/"
    username: "{{ actk_mvn_user }}"
    password: "{{ actk_mvn_pass }}"
  with_subelements:
    - "{{ actk_cert_list }}"
    - "{{ actk_certs }}"
  delegate_to: localhost

- copy:
    src: "{{ actk_src_tmp }}/{{ item.1 }}"
    dest: "{{ actk_dst_tmp }}"
  with_subelements:
    - "{{ actk_cert_list }}"
    - "{{ actk_certs }}"
```

Fortunately, we fixed that:

```YAML
get_url:
    url: "{{ actk_certs }}/{{ actk_item }}"
    dest: "{{ actk_src_tmp }}/{{ actk_item }}"
    username: "{{ actk_mvn_user }}"
    password: "{{ actk_mvn_pass }}"
  loop_control:
    loop_var: actk_item
  with_items: "{{ actk_cert_list }}"
  delegate_to: localhost

- copy:
    src: "{{ actk_src_tmp }}/{{ actk_item }}"
    dest: "{{ actk_dst_tmp }}"
  loop_control:
    loop_var: actk_item
  with_items: "{{ actk_cert_list }}"
```

### Day № 311: Speed up tests

![Ansible refactoring](assets/at_integration_4.png?raw=true "Ansible refactoring")

Amount of tests was increasing, the project was growing. As a result, in the bad case out tests were executing for 60 minutes. For dealing with that we decided to remove integration tests via VMs & use the only docker. Also, we replaced testinfra via ansible verifier for unifying toolset.

![Ansible refactoring](assets/at_integration_5.png?raw=true "Ansible refactoring")

We made some changes:

1. Migrated to the docker.
2. Removed duplicated tests & simplified dependencies.
3. Increased amount of Jenkins slaves.
4. Changed test execution order.
5. Added ability lint all via a single command, it helped to lint all locally via 1 command.

![Ansible refactoring](assets/at_integration_6.png?raw=true "Ansible refactoring")

As a result, of that changes, the Jenkins pipeline also was changed

1. Generate build stages.
2. Lint all in parallel.
3. Run test role stages in parallel.
4. Finish.

## Lessons learned

Let me share some lessons learned

### Avoid global variables

Ansible uses the global variable namespace. I know about workaround via [private_role_vars](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-private-role-vars), but it is not a silver bullet.

Let us create two roles `role_a` & `role_b`

```YAML
# cat role_a/defaults/main.yml
---
msg: a

# cat role_a/tasks/main.yml
---
- debug:
    msg: role_a={{ msg }}
```

```YAML
# cat role_b/defaults/main.yml
---
msg: b

# cat role_b/tasks/main.yml
---
- set_fact:
    msg: b
- debug:
    msg: role_b={{ msg }}
```

```YAML
- hosts: localhost
  vars:
    msg: hello
  roles:
    - role: role_a
    - role: role_b
  tasks:
    - debug:
        msg: play={{msg}}
```

![Ansible refactoring](assets/at_global_vars.png?raw=true "Ansible refactoring")

We often need some variables to be accessible globally and shared between different role. One obvious example is JAVA_HOME. Ansible has a flat namespace, and this can lead to variable names collisions. For example, two roles (say, webserver and mailserver) may use the same variable named 'port'; such a variable may be accidentally overwritten with the same value in both roles. It's better to prefix variable names in your roles either by a role name, or some short form of it.

**BAD**: use a global variable.

```YAML
# cat roles/some_role/tasks/main.yml
---
debug:
  var: java_home
```

**GOOD**: In this case, it's a good idea to define such a variable in the inventory, and use a local variable in your role with a default value of the global one. This way the roles are kind of self-contained, and it's easy to see what variables the role uses just by looking into the defaults.

```YAML
# cat roles/some_role/defaults/main.yml
---
r__java_home:
 "{{ java_home | default('/path') }}"

# cat roles/some_role/tasks/main.yml
---
debug:
  var: r__java_home

```

### Prefix role variables

It makes sense to use the role name as the prefix for a variable. it helps to understand the source inventory easier.

**BAD**: use a global variable.

```YAML
# cat roles/some_role/defaults/main.yml
---
db_port: 5432
```

**GOOD**: Prefix variable.

```YAML
# cat roles/some_role/defaults/main.yml
---
some_role__db_port: 5432
```

### Use the loop control variable

**BAD**: If you use standard `item` and somebody decides to loop your role you can face unpredictable issues.

```YAML
---
- hosts: localhost
  tasks:
    - debug:
        msg: "{{ item }}"
      loop:
        - item1
        - item2

```

**GOOD**: Override the default variable via `loop_var`.

```YAML
---
- hosts: localhost
  tasks:
    - debug:
        msg: "{{ item_name }}"
      loop:
        - item1
        - item2
      loop_control:
        loop_var: item_name

```

### Check input variables

If your role requires input roles it makes sense to raise if they are not presented.

**GOOD**: Check variables.

```YAML
- name: "Verify that required string variables are defined"
  assert:
    that: ahs_var is defined and ahs_var | length > 0 and ahs_var != None
    fail_msg: "{{ ahs_var }} needs to be set for the role to work "
    success_msg: "Required variables {{ ahs_var }} is defined"
  loop_control:
    loop_var: ahs_var
  with_items:
    - ahs_item1
    - ahs_item2
    - ahs_item3
```

### Avoid hashes dictionaries, use a flat structure

While dictionaries may seem like a good fit for your variables, you should minimize their usage due to the following:

* It's not possible for a user to change only one element of a dictionary.
* Dictionary elements cannot take values from other elements.
Example: A dictionary that stores some OS user:

**BAD**: Use hash/dictionary.

```YAML
---
user:
  name: admin
  group: admin
```

Downsides: you cannot set the default group name to the user name; if a person using your role wants to customize only the name, they must also supply the group. With regular variables, those issues are gone: Both variables can be changed independently, and the default group name matches the user name.

**GOOD**: Use flatten structure & prefix variable.

```YAML
---
user_name: admin
user_group: "{{ user_name }}"
```

### Create idempotent playbooks & roles

Roles and playbooks have to be idempotent. It decreases your fear to run a role. As a resul, configuration drift is a minimum as possible.

### Avoid using command shell modules

Imperative approach via command / shell modules is instead of declarative ansible nature. 

### Test your roles via molecule

The molecule is pretty flexible, let me show some examples:

#### Molecule Multiple instances

In the `molecule.yml` in the `platforms` you can describe a bunch of instances:

```YAML
---
    driver:
      name: docker
    platforms:
      - name: postgresql-instance
        hostname: postgresql-instance
        image: registry.example.com/postgres10:latest
        pre_build_image: true
        override_command: false
        network_mode: host
      - name: app-instance
        hostname: app-instance
        pre_build_image: true
        image: registry.example.com/docker_centos_ansible_tests
        network_mode: host
```

After that you can use the instances in the `converge.yml`:

```YAML
---
- name: Converge all
  hosts: all
  vars:
    ansible_user: root
  roles:
    - role: some_role

- name: Converge db
  hosts: db-instance
  roles:
    - role: some_db_role

- name: Converge app
  hosts: app-instance
  roles:
    - role: some_app_role
```

#### Ansible verifier

Molecule allows you to use ansible verifier instead of inspec / testinfra / serverspec. It's the default from the 3.0 version.

You can check that file contains expected body:

```YAML
---
- name: Verify
  hosts: all
  tasks:
    - name: copy config
      copy:
        src: expected_standalone.conf
        dest: /root/wildfly/bin/standalone.conf
        mode: "0644"
        owner: root
        group: root
      register: config_copy_result

    - name: Certify that standalone.conf changed
      assert:
        that: not config_copy_result.changed
```

Or you can start the service & perform a smoke test:

```YAML
---
  - name: Verify
    hosts: solr
    tasks:
      - command: /blah/solr/bin/solr start -s /solr_home -p 8983 -force
      - uri:
          url: http://127.0.0.1:8983/solr
          method: GET
          status_code: 200
        register: uri_result
        until: uri_result is not failed
        retries: 12
        delay: 10
      - name: Post documents to solr
        command: /blah/solr/bin/post -c master /exampledocs/books.csv
```

### Put complex logic into modules & plugins

Ansible nature is a declarative approach & YAML. It is extremely hard to use standard developers patterns as is because there is no syntax sugar for that. If you want to implement complex not straight logic in a playbook usually it will be ugly. Fortunately, you can customize ansible via creating your own modules & plugins.

### Summarize Tips & Tricks

1. Avoid global variables.
2. Prefix role variables.
3. Use the loop control variable.
4. Check input variables.
5. Avoid hashes dictionaries, use a flat structure.
6. Create idempotent playbooks & roles.
7. Avoid using command shell modules.
8. Test your roles via molecule.
9. Put complex logic into modules & plugins.

## Conclusion

![Ansible refactoring](assets/at_refactoring.png?raw=true "Ansible refactoring")

One does not simply refactor agreements & infrastructure. It is a long interesting journey.

## Links

* [Кросс пост](https://habr.com/en/post/500058/)
* Slides [How to test Ansible and don't go nuts](https://cloud.mail.ru/public/266x/3hJ2mQBzf)
* Video [How to test Ansible and don't go nuts](https://www.youtube.com/watch?v=GdrJv5oypfg)
* [Lessons learned from testing Over 200,000 lines of Infrastructure Code](http://www.goncharov.xyz/it/200k_iac_en.html)
* [How to test your own OS distribution](http://www.goncharov.xyz/it/how-to-test-custom-os-distr-en.html)
* [Test me if you can. Do YML developers Dream of testing ansible?](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv-en.html)
* [Ansible: Coreos to centos, 18 months long journey](http://www.goncharov.xyz/it/coreos2centos-en.html)
* [A list of awesome IaC testing articles, speeches & links](https://github.com/ultral/awesome-iac-testing)
