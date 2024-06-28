# VScode & Vagrant

![VS code](assets/vscode_remote.png)

In our case it's the best option.  The key idea is to use local VS code as editor, but execute tests inside CDE. How to configure:

1. Install [VS code](https://code.visualstudio.com/)
2. Install the plugin Remote - SSH
3. Create your ssh key at the laptop and copy the target VM

```bash
vscode ssh configuration
Host localhost
  User core
  HostName localhost
  Port 10022
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/id_rsa
  GlobalKnownHostsFile /dev/null
  UserKnownHostsFile /dev/null
```

## Recommended plugins

* docker
* jinja
* language-ansible
* Ansible
* file Utils
* Git history
* GitLens
* markdownlint
* python
* shellcheck
* jenkinsFile support

## WSL

It’s not the case because too many kludges and limitations. I.e. it’s not possible to run docker & molecule inside WSL (because by nature, WSL is like wine)
