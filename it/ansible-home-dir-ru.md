# Домашняя директория пользователя в ansible или что может быть проще? Как же вычисляется

*Date: 2021-09-02*

## ansible_user_dir как он получается?

Начнем с чтения сорцов и разберемся что такое `ansible_user_dir`

ansible использует https://github.com/ansible/ansible/blob/devel/lib/ansible/modules/setup.py для сбора фактов, это и так все знают. Внутри модуля импортятся коллекторы https://github.com/ansible/ansible/blob/devel/lib/ansible/modules/setup.py#L195

```python
fact_collector = ansible_collector.get_ansible_collector(all_collector_classes=all_collector_classes,
                                                         namespace=namespace,
                                                         filter_spec=filter_spec,
                                                         gather_subset=gather_subset,
                                                         gather_timeout=gather_timeout,
                                                         minimal_gather_subset=minimal_gather_subset)
```

Нас интересует `UserFactCollector` https://github.com/ansible/ansible/blob/devel/lib/ansible/module_utils/facts/default_collectors.py#L117

```python
_general = [
    PythonFactCollector,
    SystemCapabilitiesFactCollector,
    PkgMgrFactCollector,
    OpenBSDPkgMgrFactCollector,
    ServiceMgrFactCollector,
    CmdLineFactCollector,
    DateTimeFactCollector,
    EnvFactCollector,
    SshPubKeyFactCollector,
    UserFactCollector
]

...

collectors = _base + _restrictive + _general + _virtual + _hardware + _network + _extra_facts
```

Теперь смотрим код коллектора https://github.com/ansible/ansible/blob/9c2f44b8848a317a2304254eba0b9b348d5034ad/lib/ansible/module_utils/facts/system/user.py#L46

```python
class UserFactCollector(BaseFactCollector):
    name = 'user'
    _fact_ids = set(['user_id', 'user_uid', 'user_gid',
                     'user_gecos', 'user_dir', 'user_shell',
                     'real_user_id', 'effective_user_id',
                     'effective_group_ids'])

    def collect(self, module=None, collected_facts=None):
        user_facts = {}

        user_facts['user_id'] = getpass.getuser()

        try:
            pwent = pwd.getpwnam(getpass.getuser())
        except KeyError:
            pwent = pwd.getpwuid(os.getuid())

        user_facts['user_uid'] = pwent.pw_uid
        user_facts['user_gid'] = pwent.pw_gid
        user_facts['user_gecos'] = pwent.pw_gecos
        user_facts['user_dir'] = pwent.pw_dir
        user_facts['user_shell'] = pwent.pw_shell
        user_facts['real_user_id'] = os.getuid()
        user_facts['effective_user_id'] = os.geteuid()
        user_facts['real_group_id'] = os.getgid()
        user_facts['effective_group_id'] = os.getgid()

        return user_facts
```

видим 2 интересные вещи

* определение ID пользователя
  * `os.setegid` - [Set the current process’s effective group id](https://docs.python.org/3/library/os.html#os.getuid).
  * `getpass.getuser() ` - [Return the “login name” of the user](https://docs.python.org/3/library/getpass.html).
* `pwent.pw_dir` - [User home directory](https://docs.python.org/3/library/pwd.html)

Вроде понятно. получили пользователя и вернули его домашнюю директорию

## Есть же ~

Зачем так сложно? можно же просто взять `~`. Можно, но не всегда, Т.к. `~` это сущность shell и разворачивается им. Может выстрелить когда shell явно не используется и/или требуется абсолютный путь.

Но, давайте глянем пример, что `~` и `ansible_user_dir` иногда могут выдать разный результат.

```yml
- tasks:
    - shell: eval echo "~"
      register: stdout
    - name: ansible_user_dir - ~ without become in play
      debug:
        msg: "{{ ansible_user_dir }} - {{ stdout.stdout_lines | join(' ') }}"

    - shell: eval echo "~"
      become: true
      become_user: lgonchar
      register: stdout
    - name: ~ without become in play with become in task
      debug:
        msg: "{{ ansible_user_dir }} - {{ stdout.stdout_lines | join(' ') }}"
      become: true
      become_user: lgonchar

- become: true
  become_user: lgonchar
  tasks:
    - shell: eval echo "~"
      register: stdout
    - name: ansible_ansible_user_dir - ~ user_dir with become in task
      debug:
        msg: "{{ ansible_user_dir }} - {{ stdout.stdout_lines | join(' ') }}"
```

А вот и результат работы:

```conf
TASK [ansible_user_dir - ~ without become in play]
ok: [lindev-lgonchar2.imagemaster.local] => {
    "msg": "/home/deploy - /home/deploy"
}

TASK [~ without become in play with become in task]
changed: [lindev-lgonchar2.imagemaster.local]

TASK [ansible_ansible_user_dir - ~ user_dir with become in task]
ok: [lindev-lgonchar2.imagemaster.local] => {
    "msg": "/home/deploy - /home/ms/lgonchar"
}
```

поведение логичное. на момент сбора фактов у нас пользователь deploy поэтому он и сохраняется в `ansible_user_dir`

## Вместо выводов

Выводов не будет. Это просто рассказ, что даже простая задача может скрывать подводные камни.
