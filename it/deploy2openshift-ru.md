# Let's deploy to Openshift

Это расшифровка выступления на [kubernetes SPB meetup #3](https://www.meetup.com/kubernetes-spb/events/258970186/).

* [slides](https://cloud.mail.ru/public/3VkE/F2H78LtZw).
* [English version](deploy2openshift-en.md)
* [Russian version](deploy2openshift-ru.md)

# Предыстория

Я хочу рассказать история, как запускали приложение в Openshift. Так же по ходу пьесы рассмотрим утилиты для управления приложением внутри Openshift. 

## Цель

![This is fine](assets/deploy2openshift-this_is_fine.png?raw=true "This is fine")

Обычно клиенты разворачивают на отдельных серверах, но тут пришла задача, прощупать возможность запуска в openshift и пособирать граблей. 

Для начала надо поговорить про наше приложение. Проект с богатой историей. Используется в больших организациях и вероятно каждый из вас косвенно пересекался. Приложение поддерживает множество баз данных, интеграций итд итп.

## Пререквизиты

![Deploy](assets/deploy2openshift-deploy.png?raw=true "Deploy")

Приложение должно работать в совершенно разных окружениях. Как результат наша документация по установке, весьма, обширная. Но если посмотреть свысока, то ничего сложного:
* Применить схему БД.
* Настроить сервер приложений.
* Установить лицензию.
* Настроить приложение и интеграции с внешними системами.

![Deploy](assets/one-does-not-simply.png?raw=true "Deploy")

Но мир жесток, у нас был ряд ограничений:
* Приложение можно собирать только на специально Jenkins, который занимается подписанием. И только там.
* Нет доступа из клиентского Openshift в окружение для разработки.
* По ряду идеологических причин Не было возможности переиспользовать существующие Docker образы для разработки.
* У нас есть ansible playbooks для установки и настройки приложения на серверах.

## Ansible-container demo

![Ansible-container](assets/deploy2openshift-schema-ansible-container.png?raw=true "Ansible-container")

[Ansible container](https://blog.openshift.com/ansible-container/) это открытое программное обеспечение, которое преследует цель автоматизации сборки контейнеров, деплоя и управления процессом. Как можно догадаться из названия. для сборки контейнеров используется Ansible. У нас уже были написано Ansible роли для инсталляции  и развертывания приложения поверх серверов, так что мы решили не изобретать велосипед и переиспользовать их. Не то что бы это идеальный инструмент, но быстрое переиспользование существующих ролей оказалось решающим фактором для демо.

По большому счету, что бы сделать сделать демо мы взяли существующие роли, настраивающие всё и вся, и сделали "монолитный контейнер". Что собрать контейнер не было особых проблем, т.к. у [Openshift есть замечательные рекомендации](https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html), но отдельно отмечу:
* Роли было необходимо было доработать, т.к. мы используем systemd.
* По умолчанию, в целях безопасности в openshift запрещено использовать некоторые syscall. Как следствие будут нюансы с chroot, sudo. Привет [CVE-2019-5736](https://seclists.org/oss-sec/2019/q1/119).
* Аналогично из соображений безопасности контейнер запускается из под пользователя со случайным ID, это так же настраиваемое поведение.

Основная идея в этом пункте, что мы сделали демо ооочень быстро.

## Multiple containers demo

![Multiple containers](assets/deploy2openshift-schema-multiple-containers.png?raw=true "Multiple containers")

Демо контейнер выполнил свою роль и мы распилили его на отдельные составляющие:

1. Наше приложение.
2. База данных. 
3. Внешние сервисы итд...

![Multiple containers](assets/deploy2openshift-schema-multiple-containers-db-init.png?raw=true "Multiple containers")

Первое с чем столкнулись, как инициализировать базу данных? Понятно что используем миграции, но когда и как их применять? Тут стоит дать ссылку на замечательную статью описывающие устройство POD: [PODs life](https://blog.openshift.com/kubernetes-pods-life/). По большому счету есть несколько подходом:
* Использовать init-container
* Использовать системы оркестрации, которые определят порядок развертывания сервисов и накатят миграции когда надо.

Мы решили пойти по пути Init-container. Т.е. в POD нашего приложение, до старта нашего приложения, стартует контейнер, который катит миграции. Но как сконфигурировать само приложение и внешние интеграции?

## Initialize the application 

![Multiple containers](assets/deploy2openshift-schema-multiple-containers-app-init.png?raw=true "Multiple containers")

Как я уже упоминал, наше приложение может и должно работать совершенно в разных окружениях, с разными БД и интеграциями. Опять же вопрос, как это все настраивать?
* Использовать системы оркестрации, которые определят порядок развертывания сервисов и применять конфигурацию после старта приложения.
* Передавать через переменные окружения контейнеру как настроиться.
* Использовать start hook.
* Сделать отдельный контейнер, который содержит конфигурацию и применит ее к приложению. Грубо аналог миграция для БД.

Мы выбрали последний подход, т.к. он позволяет делать конфигурацию воспроизводимой и самодостаточной. Только зачем-то изначально сделали этот контейнер в отдельном replication controller с фактором 1.

![Multiple containers](assets/deploy2openshift-schema-multiple-containers-final.png?raw=true "Multiple containers")

Ок, почитаем документацию снова.

> A pod (as in a pod of whales or pea pod) is a group of one or more containers (such as Docker containers), with shared storage/network, and a specification for how to run the containers.

POD это **группа** контейнеров. В итоге наш под состоял из 3 контейнеров 
1. Init container для инициализации a PostgreSQL.
2. Контейнер с приложение.
3. Контейнер с конфигурацией приложения. 

# Инструментарий

У нас получилась схема как выглядит приложение развернутое. Теперь настало время обсудить инструментарий в природе существует много уже готового, я рассмотрю некоторые из списка ниже и сделаю субъективные выводы.
* [Openshift templates](https://docs.openshift.com/container-platform/3.7/dev_guide/templates.html)
* bash/python/ruby + yml templates
* [Terraform k8s provider](https://www.terraform.io/docs/providers/kubernetes/index.html)
* [Ansible-container](https://blog.openshift.com/ansible-container/)
* [Ansible + k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html)
* [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle)
* [Ansible bender](https://blog.tomecek.net/post/road-to-ansible-bender-0-2-0/)
* [operator](https://blog.openshift.com/introducing-the-operator-framework/)
* [source2image](https://github.com/openshift/source-to-image)
* [kustomize](https://github.com/kubernetes-sigs/kustomize)
* [helm](https://github.com/helm/helm)
* [Automation broker](http://automationbroker.io/)

## Openshift templates

![Openshift templates](assets/deploy2openshift-openshift-templates.png?raw=true "Openshift templates")

[Openshift templates](https://docs.openshift.com/container-platform/3.7/dev_guide/templates.html)

**Плюсы:**
* Нативно и у них отличная документация.

**Минусы:**
* Еще один шаблонизатор.
* Длинные и ужасные YAML файлы.
* Если у вас есть зависимости между сервисами и их очередностью старта, то будет сложно.


## Scripts and template

![Custom scripts](assets/deploy2openshift-openshift-scripts.png?raw=true "Custom scrtipts")

**Плюсы:**
* Можете использовать отличные инструменты и всю мощь ООП.

**Минусы:**
* Костыли, которые поддерживать. И не только вам.

## Terraform k8s provider

![Terraform k8s provider](assets/deploy2openshift-terraform.png?raw=true "Terraform k8s provider")

[Terraform k8s provider](https://www.terraform.io/docs/providers/kubernetes/index.html)

**Плюсы:**
* Вы не беспокоитесь об очередности создания элементов инфраструктуры.
* Можно переиспользовать код инфраструктуры как модули.
* Можно добавить логику инициализации приложения.

**Минусы:**
* Нет поддержки Openshift, только k8s.
* Иногда устаревшая дока и модули.
* Еще одна тула в вашей команде.

## Ansible-container

![Ansible-container](assets/deploy2openshift-ansible-container.png?raw=true "Ansible-container")

[Ansible-container](https://blog.openshift.com/ansible-container/)

**Плюсы:**
* [Make CM, no bash](http://www.goncharov.xyz/it/make-cm-not-bash-en.html)
* Можно переиспользовать код в виде ролей.
* В нашем случае один инструмент для всего.

**Минусы:**
* Огромные образы, т.к. идут одним слоем.
* Выглядит покинутым и не поддерживаемым. Был заменен [Ansible bender](https://blog.tomecek.net/post/road-to-ansible-bender-0-2-0/).

## Ansible k8s module

![Ansible k8s module](assets/deploy2openshift-ansible.png?raw=true "Ansible k8s module")

[Ansible + k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html)

**Плюсы:**
* Один плэйбук для описания все инфраструктуры проекта внутри Openshift.
* Переиспользование кода в виде ролей.
* Можно добавить логику инициализации приложения.

**Минусы:**
* Нет поддержки прокси.
* Вы заботитесь об удаление. Если объект больше не нужен надо описать его удаление.
* Вы сами описываете очередность создания элементов инфраструктуры.

## Ansible Playbook Bundle

![Ansible Playbook Bundle](assets/deploy2openshift-apb.png?raw=true "Ansible Playbook Bundle")

Утилита [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle) (APB) предлагает подход: а давайте запакуем ansible роли для развертывания приложения внутри k8s/openshift в контейнер и будем запускать внутри k8s/openshift.

**Плюсы:**
* Всё свое ношу с собой.
* Тестируемо и воспроизводимо.
* Интеграция с Service catalogue(дружелюбный веб интерфейс для запуска приложений).


**Минусы:**
* Вам нужны привилегии уровня администратора.
* Документация иногда оставляет желать лучшего.

## Result

![Result](assets/deploy2openshift-result.png?raw=true "Result")

Не хочется быть последний инстанцией, но поделюсь своими умозаключениями:
* Если не планируете предоставлять приложение как сервис то [Ansible k8s module](https://docs.ansible.com/ansible/latest/modules/k8s_module.html) ваш выбор.
* Но если оно вам надо, то надо копать про [automation broker](http://automationbroker.io/) и [Ansible Playbook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle).

# links

* [www.meetup.com/kubernetes-spb](https://www.meetup.com/kubernetes-spb)
* [t.me/k8spb](https://t.me/k8spb)
* [learn.openshift.com](https://learn.openshift.com/operatorframework)
* [Automate kubernetes with Ansible](http://ftp.belnet.be/mirror/FOSDEM/2019/UB2.252A/automate_kubernetes_ansible.mp4)
