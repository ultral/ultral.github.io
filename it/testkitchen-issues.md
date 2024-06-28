# Pass proxy settings from host into testkitchen guest VM

In some test suits, we configured proxy client settings inside VM created by testkitchen. However, proxy was not configured on testkitchen host & ansible cannot use extra variables with empty values

*Solution:* create erb template for setting default proxy if ENV variables is not set

```
<%= ENV['http_proxy'].to_s.empty? ? 'http://proxy.example.com:3128' : ENV['http_proxy'] %>
```


# Manage network settings via playbook

Some roles configure network interfaces. Test suit was looked like:
* Deploy network settings to VMs
* Reload network
* It is failed

*Solution:* add interfaces to VMs

# Fail if suit cases contains "-" in name

Virtualbox can't use "_" in a vm name

*Solution:* rename suitcases "vm_" => "vm-"

# Oracle test fails without "." at the end of VM name
We use role in production, however when we decided to test it, it was failed. We reproduced it. 

I would like to show clue. 

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

# OOM is coming
OOM randomly was killing VMs. Testkitchen was failed with strange errors.

*Solution:*  increase RAM

# Slow builds
It was working slowly

*Solutions:*
* [Packer](https://www.packer.io/). Prebuilded vagrant box with common tasks
* Concurrency
