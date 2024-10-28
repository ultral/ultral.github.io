# Протестируй меня если сможешь или мечтают ли YML программисты о тестирование Ansible?

![kitchen-ci schema](https://habrastorage.org/webt/ct/me/vo/ctmevotjzsrr0s-5_erinl_pedk.png)

*Date: 2019-01-22*

Это текстовая версия [выступления](https://cloud.mail.ru/public/DBuA/7sEMAMRyH) 2018-04-25 на [Saint-Petersburg Linux User Group](http://spblug.org/).

* [Slides](https://cloud.mail.ru/public/DBuA/7sEMAMRyH)
* [Russian version](test-ansible-roles-via-testkitchen-inside-hyperv-ru.md)
* [English version](test-ansible-roles-via-testkitchen-inside-hyperv-en.md)
* [Crosspost Russian version](https://habr.com/en/post/437004/)
* [Crosspost English version](https://habr.com/en/post/436960/)
* Пример кода: [github.com/ultral/ansible-role-testing](https://github.com/ultral/ansible-role-testing)

Полагаю что вы используете [configuration mangement, а не bash](make-cm-not-bash-ru.md). Т.е. ваша конфигурация это код. Если мы говорим, что инфраструктура это код, то к её созданию должна применяться та же философия, что и для разработки ПО. Вы задумывались об этом? Как у вас это сделано? А у других?

## Пререквизиты

В описываемом случае было множество вводных:

* Множество ansible ролей.
* Hyper-V как основной гипервизор.
* Приватное облако с ограниченными возможностями по созданию виртуальных машин на лету.
* Proxy для доступа к интернету.
* Невозможность запускать тестирование ansible ролей в docker, потому что роль это конфиг целой вм, в том числе сетевые настройки например.
* Желание использовать политику зеленого мастера для репозитория с ansible ролями.

Преждем чем делать своё, сравним существующие решения.

| Проект         | [Test Kitchen](https://kitchen.ci/) | [Molecule](https://molecule.readthedocs.io) | Свой |
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

Мы решили не [изобретать велосипед](how-to-test-custom-os-distr-ru.md) и взять готовое решение. Наша инфраструктурная команда умеет в ruby поэтому был выбран [Test Kitchen](https://kitchen.ci/) & [inspec](https://www.inspec.io/)

## Kitchen-CI

![kitchen-ci schema](assets/kitchen-ci-schema.png?raw=true "kitchen-ci schema")

Идея до безобразия простая. Создаем новую виртуальную машину, применяем роль, прогоняем smoke-test.

## Green Build Policy

![Green build policy schema](assets/Green-build-policy.png?raw=true "Green build policy schema")

Но решили идти дальше. Использовать аля github flow, т.е. роли в отдельных бранчах и после ревью мерджим в мастер. Если тесты ок, то накатываем роли на инфраструктуру.

## Вложенная виртуализация

Как вы помните, у нас были ограничения на создание виртуальных машин, по этому пришлось делать непритное решение в виде вложенной виртуализации.

![we need to go deeper](assets/we-need-to-go-deeper.jpeg?raw=true "we need to go deeper")

Изначально попробовали Virtualbox x32 что бы не включать поддержку nested. Это оказалось не очень идей из-за стабильныз kernel panic. Второй важный фактор, что мы сидим на x86_64, так что изыскания продолжились(привет libvirt), но остановились на virtualbox как более распространным по поддерживаемым ОС.

## Сложности

Во время запуска это всего добра был ряд сложностей

### Прокинуть настройки proxy с хоста в гостя гостя

В некоторых тестовых сценарияъ использовалась настройки proxy, при этому на хосте с testkitchen использовался прозрачный прокси и бонусом ansible не принимал extra variables с пустыми значениями.

*Решение:* банально - создаем ERB шаблон.

```ruby
<%= ENV['http_proxy'].to_s.empty? ? 'http://proxy.example.com:3128' : ENV['http_proxy'] %>
```

### Управление сетевыми настройками через ansible

В некоторых ролях настраивалась сеть, в тестах это выглядело так:

* Настраиваем сеть копированием файлика.
* Применяем настройки сети.
* Все плохо.

*Решение:* Добавить интерфейс к виртуальной машине

### Если тестовый набор содержи "_" все падает

Virtualbox не может пользовать "_" в имени виртуальной машины. А виртуальная машина использовала название сценария.

*Решение:* переименовать тестовые наборы "vm_" => "vm-"

### Тестовые сценарии с установкой Oracle без "." в конце имени виртуальной машины падают

Роль пользовалась в условном продашине, когда решили покрыть ее тестами. Когда раскатываешь на подготовленную вм - роль отрабатывает, через testkitchen падает.

Небольшая подсказка

```bash
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

Есть идеи что происходит?

Это был забавный сценарий:

1. У нас включался биндинг IPv4 только в настройках oracle listener.
2. oracle использует FQDN.
3. linux содержит специальную базу "myhostname" для разрешения доменных имен, она использовалась после /etc/hosts & dns серверов.
4. Vagrant создает VM & обновляет `/etc/hosts`.

Чуть поясню:

Что происходит в случае *vm-oracle*?

1. vagrant создает виртуальную машину.
2. vagrant обновляет `/etc/hosts`(*vm-oracle* x2)
3. oracle listener слушает IPv4.
4. oracle listeners разрешает доменное имя *vm-oracle.* & получает IPv6.
5. FAILED

Что происходит в случае *vm-oracle.*?

1. vagrant создает виртуальную машину.
2. vagrant обновляет /etc/hosts ( *vm-oracle* &  *vm-oracle.*).
3. oracle listener слушает IPv4.
4. oracle listeners разрешает доменное имя *vm-oracle.* & получает IPv4
5. OK

### OOM в гости к нам приходит

OOM случайным образом убивал виртуальные машину. Testkitchen при этому в логах своих давал всякие странные собщение.

*Решение:*  Увеличить колличество памяти.

### Медленные билды

Вся эта схма работала медленно, десятки минут, иногда и больше часа.

*Решения:*

* [Packer](https://www.packer.io/). Предсобирать образы виртуальных машин.
* Пускать несолько тестовых сценариев в параллель

## Заключение

Если мы говорим, что инфраструктура это код, то к её созданию должна применяться та же философия, что и для разработки ПО. С одной стороны получилось рабочее решение, но есть некоторые неприятные момент:

* Не дружелюбно оно все выглядит.
* Смесь ruby & python.
* Отсутсвует проверки иимутабельности ролей.
* Медленно работает.
* Сложно....

На выходе molecule с docker смотрится интересно и более нативно. Мы подумываем об этом.

## Ссылки

* [Slides](https://cloud.mail.ru/public/DBuA/7sEMAMRyH)
* [Russian version](test-ansible-roles-via-testkitchen-inside-hyperv-ru.md)
* [English version](test-ansible-roles-via-testkitchen-inside-hyperv-en.md)
* [Crosspost Russian version](https://habr.com/en/post/437004/)
* [Crosspost English version](https://habr.com/en/post/436960/)
* Пример кода: [github.com/ultral/ansible-role-testing](https://github.com/ultral/ansible-role-testing)
* [http://kitchen.ci/](http://kitchen.ci/)
* [https://github.com/chef/kitchen-inspec](https://github.com/chef/kitchen-inspec)
* [https://docs.chef.io/config_yml_kitchen.html](https://docs.chef.io/config_yml_kitchen.html)
* [https://docs.chef.io/ctl_kitchen.html](https://docs.chef.io/ctl_kitchen.html)
* [https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md](https://github.com/neillturner/kitchen-ansible/blob/master/provisioner_options.md)
* [How to test Ansible and don't go nuts](ansible-testing-en.md)