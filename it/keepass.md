# Keepass & SSH

*Date: 2021-10-16*

I use ssh keys & have forgotten about typing passwords & accidental locking of my account.

my scheme is:

1. The ssh private key is stored in the [keepass](https://keepass.info/).
2. Keepass works as ssh-agent. It exports the ssh-key via [keeagent plugin](https://keepass.info/plugins.html#keeagent)
3. In the plugin I've configured "*enable agent for windows openssh*"
4. in the vscode I set *Remote.SSH.path*  to *C:\Windows\System32\OpenSSH\ssh.exe*
5. installed public ssh key at AWS, github, etc
