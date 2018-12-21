# Docker testing

Sometimes, I should rebuild docker containers, however, I don't know how the container should work. The sentence "The resulting image should behave like the current one" sounds clear, however, it is not a measurable goal.
From my point of view, we have to write "tests" for our containers. I believe that infrastructure is code & we must use the same philosophy for infrastructure as for software development, i.e, testing

# Ansible-container

One of the interesting ways is to use ansible-container & molecule:
1. Build a container via ansible-container.
2. Test the [ansible](http://www.goncharov.xyz/it/ansible.html) role inside docker via molecule.

what do you think about it? "build container via ansible-container" sounds like a cleaner way than the [bash](http://www.goncharov.xyz/it/make-cm-not-bash-en.html) stuff that has accumulated over the years. However, we should always consider the advantages that it brings: 
1. Rewriting stuff that already works more cleanly in a better way can be fun, but doing it just for the sake of it does not benefit us. 
2. If there is something tangible to gain from it, then it may make sense.

So, the main point is cover by tests existing containers, not just rewrite to ansible-containers for fun. There is 2 framework already exist testkitchen and molecule framework. Everyone can use it. Also, you can create & support your own framework.

# Test framework

From my point of view the framework means:
1. Get something that describes target infrastructure (dockerfile, ansible role, bash script, whatever).
2. Lint it(code style, mistypes, idempotency etc).
3. Provision it onto some platform(VM/docker).
4. Run some infrastructure tests. 
 
Where are a lot of tools for that: testinfra, inspec, serverspec. I'd like to share  some examples of tests:
1. Files have correct permissions.
2. Users exist.
3. Certificates are valid.
4. Java works properly.
5. Service works properly.

# Conclusion

You can read about coherent [issue about ansible roles testing](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv.html)
