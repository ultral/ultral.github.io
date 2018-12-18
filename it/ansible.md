# Ansible
As an ansible follower, I'd like to present the ansible. 

First of all, what is it the ansible? Have you ever heard about it? It is open source software for configuration management & applications deployment. It allows automating existing processes. 

Why I chose ansible? It's a sophisticated question, there are some points:
1. Infrastructure As Code.
2. Easy to understand.
3. Reduce bus factor.
4. Production ready/maturity.
5. Popular.
6. Agentless.

# Go deeper

![we need to go deeper](assets/we-need-to-go-deeper.jpeg?raw=true "we need to go deeper")

As you could have noticed at the previous sentence ansible is agentless configuration management solution. It means that you have to have a management node with installed ansible.

How does it work?
1. Ansible gets hosts from the inventory.
2. Ansible gets tasks from the playbook (playbook it is a list of tasks in declarative YML format).
3. Ansible generates executable code for each task.
4. Ansible copies executable python code to the target hosts via SCP.
5. Ansible executes python code at the target hosts.

![ansible schema](assets/ansible_inside.png?raw=true "kitchen-ci schema")

# Use cases

## Manage VMs
I hope you've received basic knowledge about the ansible and we can continue. Let's describe some use cases.

The first one use case is [Linux virtual machines configuration management](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html).

![Green build policy schema](assets/Green-build-policy.png?raw=true "Green build policy schema") 

You have a git repo & it contains some playbooks. You can implement [a green build policy](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html) for the repository. It means that for each commit to master your CI/CD runs ansible roles tests. If the tests are ok, CI/CD will apply ansible playbooks.

## Create VM templates

The next one use case is new Linux virtual machine creation.

In general, it is based on the previous workflow. For example, you can create a Linux virtual machine template via [the packer](https://www.packer.io/) & the ansible. The packer is the tool from the hashicorp stack for building VM images.

# Conclusion

On one hand, it is possible to use bash for described purpose, but on the other hand, [it is a sophisticated question](http://www.goncharov.xyz/it/make-cm-not-bash-en.html). I hope it was interesting for you and you have received some new knowledge about the ansible.

