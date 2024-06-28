# Как начать тестировать Ansible, отрефакторить проект за год и не слететь с катушек

![Ansible refactoring](assets/at_refactoring.png?raw=true "Ansible refactoring")

Это расшифровка моего [выступления](https://www.youtube.com/watch?v=GdrJv5oypfg) на [DevOps-40 2020-03-18](https://www.meetup.com/DevOps-40/events/269140089/):

* [Slides](https://cloud.mail.ru/public/266x/3hJ2mQBzf)
* [Video](https://www.youtube.com/watch?v=GdrJv5oypfg)
* [Russian version](http://www.goncharov.xyz/it/ansible-testing-ru.html)
* [English version](http://www.goncharov.xyz/it/ansible-testing.html)

Начиная со второго коммита любой код становится legacy, т.к. изначальные задумки начинают расходиться с суровой реальностью. Это не хорошо и не плохо, это данность с которой сложно спорить и необходимо уживаться. Частью этого процесса является рефакторинг. Рефакторинг Infrastructure as Code. Да начнется история как отрефакторить Ansible за год и не слететь с катушек.

## Зарождение Legacy

### День № 1: Нулевой пациент

![Ansible refactoring](assets/at_dev_ops.png?raw=true "Ansible refactoring")

Жил был условный проект. На нем была Dev команда разработки и Ops инженеры. Они решали одну и ту же задачу: как развернуть сервера и запустить приложение. Проблема была в том, что каждая команда решала эту задачу по своему. На проекте было принято решение использовать Ansible для синхронизации знаний между командами Dev и Ops.

### День № 89: Зарождение Legacy

![Ansible refactoring](assets/at_pasta_legacy.png?raw=true "Ansible refactoring")

Сами того не заметив, хотели сделать как можно лучше, а получилось legacy. Как так получается?

* У нас тут срочная таска, сделаем грязный хак - потом исправим.
* Документацию можно не писать и так всё понятно что тут происходит.
* Я знаю Ansible / Python / Bash / Terraform ! Смотрите как я могу извернуться!
* Я Full Stack Overflow Deveopler скопировал это со stackoverflow, не знаю как это работает, но выглядит прикольно и решает задачу.

В итоге можно получить код непонятного вида, на который нет документацци, непонятно что он делает, нужен ли он, но проблема в том, что вам необходимо его развивать, дорабатывать, добавлять костыли с подпорками, делая ситуацию только еше хуже.

```YAML
- hosts: localhost
  tasks:
    - shell: echo -n Z >> a.txt && cat a.txt
      register: output
      delay: 1
      retries: 5
      until: not output.stdout.find("ZZZ")
```

### День № 109: Осознание проблемы

![Ansible refactoring](assets/at_road_to_success.png?raw=true "Ansible refactoring")

Изначально задуманная и реализованная модель IaC перестаёт отвечать действительности с запросами пользователей / бизнеса / других команд, время внесение изменений в инфраструктуру перестаёт быть приемлимым. В этот момент приходит понимание, что пора принимать меры.

## Рефакторинг IaC

### День № 139: А вам точно нужен рефакторинг? 

![Ansible refactoring](assets/at_refactoring.png?raw=true "Ansible refactoring")

Прежде чем кидаться рефакторить вы должны ответить на ряд важных вопросов:

1. Зачем вам всё это?
2. Есть ли у вас время?
3. Достаточно ли знаний?

Если вы не значете как ответить на вопросы, то рефакторинг закончится так и не начавшись или может получиться только хуже. Т.к. был опыт полученный из [тестирования 200 000 строк инфраструктурного кода](http://www.goncharov.xyz/it/200k_iac_ru.html), то от описанного проекта пришел запрос стабилизировать код IaC и покрыть его тестами.

### День № 149: Подготовка реафкторинга

![Ansible refactoring](assets/at_main_concept.png?raw=true "Ansible refactoring")

Первоочердное это надо подготовиться. Определиться что будем делать. Для этого общаемся, находим проблемы точки и прикидываем их пути решения. Полученные концепты как-то фиксируем, например статья в confluence, что бы при появление вопроса "как лучше?" или "как правильнее?" мы не сбились с курса. В нашем случае мы придерживались идеи *разделяй и властвуй*: дробим инфраструктуру на маленькие кусочки / кирпичики. Такой подход позволяет взять изолированный кусок инфраструктуры, понять что он делает, покрыть его тестами и изменить не побоявшись что-нибудь сломать.

![Ansible refactoring](assets/200k_testing_pyramid.png?raw=true "Ansible refactoring")

Получается, что тестирование инфраструктуры становится краеугольным камнем и тут стоит упомянуть пирамиду тестирования ифраструктуры. Ровно таже идея, что в разработке, но для инфраструктуры: идем от дешевых быстрых тестов которые проверяют простые вещи, например отступы, к дорогим полноценным тестами разворачивающих цельную инфраструктуру.

#### Попытки тестирования Ansible

Прежде чем пойдем описывать как покрывали тестами Ansible на проекте, опишу попытки и подходы которые довелось использовать ранее, что бы понять контекст принимаемых решений.

##### День № -997: SDS provision

![Ansible refactoring](assets/at_ostest.png?raw=true "Ansible refactoring")

Первый раз тестировать Ansible довелось на проекте по разработке SDS (Software Defined Storage). Есть отдельная статья на эту тему
[Как наломать велосипедов поверх костылей при тестировании своего дистрибутива](http://www.goncharov.xyz/it/how-to-test-custom-os-distr-ru.html), но если кратко, то у нас получилась перевернутая пирамида тестирования и тестировние мы тратили 60-90 минут на одну роль, что есть долго. Основа была e2e тесты, т.е. мы разворачивали полноценную инсталляцию, и потом ее тестировали. Еще отягчающим было изобретение своего велосипеда. Но надо признаться это решение работало и позволяло стабильно релизиться.

##### День № -701: Ansible и test kitchen

![Ansible refactoring](assets/at_kitchen_1.png?raw=true "Ansible refactoring")

Развитием идеи тестирования Ansible стало использование готовых инструментов, а именно test kitchen / kitchen-ci и inspec. Выбор был обусловен знанием Ruby ( подробней: [Мечтают ли YML программисты о тестировании ansible?](http://www.goncharov.xyz/it/test-ansible-roles-via-testkitchen-inside-hyperv-ru.html)) работало быстрее порядка 40 минут на 10 ролей. Мы создавали пачку виртуальных машин и внутри гоняли тесты.

![Ansible refactoring](assets/at_kitchen_1.png?raw=true "Ansible refactoring")
В целом решение работало, но был осадочек из-за неоднородности. Когда же увеличили колличество тестируемых до 13 базовых ролей и 2 мета ролей комбинирующие более мелкие роли, то вдруг тесты стали бежать 70 минут, что почти в 2 раза дольше. Об XP (extreme programming) практиках было сложно говорить т.к. никто не захочет ждать 70 минут. Это стало подоводом для изменения подхода

##### День № -601: Ansible и molecule

![Ansible refactoring](assets/at_molecule_unit_1.png?raw=true "Ansible refactoring")

Концептуально это похоже на testkitchen, только мы перевели тестирование ролей в docker и сменили стэк. Итогом, время скоратилось до стабильных 20-25 минут для 7 ролей.

![Ansible refactoring](assets/at_molecule_unit_2.png?raw=true "Ansible refactoring")

Увеличив колличество тестирумых ролей до 17 и линтовку 45 ролей мы прогоняли это за 28 минут на 2 jenkins slave.

### День № 167: Добавляем на проект тесты Ansible

![Ansible refactoring](assets/at_yac_shaving_1.png?raw=true "Ansible refactoring")

С наскоку задачу рефакторинга, скорей всего сделать не получится. Задача должна быть измеримой, что бы вы могли ее разбить на мелкие кусочки и съесть слона по частям чайной ложкой. Должно быть понимание в правильном ли вы направление идет движение, долго ли еще идти.

![Ansible refactoring](assets/at_yac_shaving_2.png?raw=true "Ansible refactoring")

В целом не суть важно как это будет сделано, можно писать на бумажку, можно клеить стикеры на шкаф, можно создавать таски в jira, а можно завести google docs И туда записывать текущий статус. Ноги растут из того, что процесс не сиюминутный, он будет долгий и нудный. Маловероятно, что кто-то хочет, что бы за время рефакторинга вы перегорели идей, устали и забили.

Рефакторинг прост:

* Eat.
* Sleep.
* Code.
* IaC test.
* Repeat

и так повторяем пока не достигнем намеченной цели.

![Ansible refactoring](assets/at_lint.png?raw=true "Ansible refactoring")

Все сразу начать тестировать может не получится, поэтому у нас первой задачей было начать с линтовки и проверки синтаксиса. 

### День № 181: Green Build Master

![Ansible refactoring](assets/200k_int_code_gbm.png?raw=true "Ansible refactoring")

Линтовка это небольшой первый шаг к Green Build Master. Это почти ничего не сломает, но позволит отладить процессы и сделать зелененькие билды в jenkins. Идея в том, что бы вырабать привычки у команды:

* Красные тесты плохо.
* Пришёл исправить что-то заодно сделай код чуть лучше, чем он был до тебя.

### День № 193: От линтовки к unit тестам

![Ansible refactoring](assets/at_molecule_unit_3.png?raw=true "Ansible refactoring")

 Выстроив процесс попадания кода в мастер можно начинать процесс поэтапного улучшения - заменяя линтовку на запуск ролей, можно даже без идемпотентности. Необходимо поянть как применять роли, как они работают.

### День № 211: От unit к integration тестам

![Ansible refactoring](assets/at_integration_1.png?raw=true "Ansible refactoring")

Когда unit тестами покрыто большинство ролей и всё линтуется, можно переходит к добавление интеграционных тестов. Т.е. тестированию не отдельного кирпичика в инфраструктуре, а их комбинации, например полноценную конфигурацию инстанса.

![Ansible refactoring](assets/at_integration_2.png?raw=true "Ansible refactoring")

На jenkins мы гененировали множество стадий, которые в параллель линтовали роли / плэйбуки, потом юнит тесты в контейнерах и в конце интеграционные тесты.

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

### День № 271: Bus Factor

![Ansible refactoring](assets/at_review_1.png?raw=true "Ansible refactoring")

Первое время рефакторингом занималась небольшая группа людей в пару тройку человек. Они делали ревью кода в мастер. Со временем в команде вырабатолось знание как писать код и code review способствовало распространению знание об инфраструктуре и том как она устроена проходило.
Изюминкой здесь было, то что ревьюверы выбирались по очереди, по графику, т.е. с некоторой долей вероятности ты залезешь в новый участок инфраструктуры.

![Ansible refactoring](assets/at_review_2.png?raw=true "Ansible refactoring")

И здесь должно быть удобно. Удобно делать ревью, видеть в рамках какой задачи оно сделано, историю обсуждений. Мы интегрировали jenkins + bitbucket + jira.

Но как таковое ревью не панацея, у нас например пролез в мастер пролез код, который сделал нам флапающие тесты:

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

Потом это исправили, но осадочек остался.

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

### День № 311: Ускоряем тесты

![Ansible refactoring](assets/at_integration_4.png?raw=true "Ansible refactoring")

Со вренем тестов становилось больше, билды бежали медленее до часа в плохом случае. На одном из ретро была фраза по типу "хорошо что есть тесты, но они медленные".  В итоге мы отказались от интеграционных тестов на виртуальных машинах и адаптировали под docker, дабы было быстрее. Так же заменили testinfra на ansible verifier что бы уменьшить кол-во используемых инструментов.

![Ansible refactoring](assets/at_integration_5.png?raw=true "Ansible refactoring")

Строго говоря тут был комплекс мер:

1. Переход на docker.
2. Убрать тестирование ролей, которое дублируется за счет зависимостей.
3. Увеличить кол-во слэйвов.
4. Порядок запуска тестов.
5. Возможность линтовать **ВСЁ** локально одной командой.

![Ansible refactoring](assets/at_integration_6.png?raw=true "Ansible refactoring")

В итоге Pipeline на jenkins тоже унифицировался

1. Generate build stages.
2. Lint all in parallel.
3. Run test role stages in parallel.
4. Finish.

## Lessons learned

1. Avoid global variables.
2. Prefix role variables.
3. Use loop control variable.
4. Check input variables.
5. Avoid hashes dictionaries, use flat structure.
6. Create idempotent playbooks & roles.
7. Avoid using command shell modules.
8. Test your roles via molecule.
9. Put complex logic into modules & plugins.


## Links

* Slides [How to test Ansible and don't go nuts](https://cloud.mail.ru/public/266x/3hJ2mQBzf)
* Video [How to test Ansible and don't go nuts](https://www.youtube.com/watch?v=GdrJv5oypfg)
* [Lessons learned from testing Over 200,000 lines of Infrastructure Code](http://www.goncharov.xyz/iac)
* [A list of awesome IaC testing articles, speeches & links](https://github.com/ultral/awesome-iac-testing)
