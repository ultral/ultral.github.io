# Иcтория про Алёну которая не любила писать тесты

*Date: 2019-03-29*

Есть у меня коллега Алёна. Она родился 30 лет назад в городе на болоте и оранжевой толстовке. Вошла в айти еще до института, основное хобби – поиск выхода. В поисках немного научилась про администрирование Linux и чуть больше про Microsoft.  Пришла заниматься DevOps, потому что модно, хоть никто и не знает, что это. Готова холиварить на любую тему, но считает, что не существует идеального инструмента для всех задач. Хобби: Варит борщи, читает книги, ломает и чинит оба автомобиля, катается на горных лыжах вниз.

## Отрицание

Алёна была очень грамотным системным администратором (до того, как это стали называть девопсом) и понимала, что от мониторинга нет толка, если бизнес не видит важные для себя метрики. Поэтому в zabbix был мониторинг количества обработанных документов в системе. Для бизнеса было важно, чтобы величина очереди была минимальной. Поэтому Алена настроила триггер в zabbix, который после превышения порогового значения создавал ее скриптом новые обработчики документов.
Алена не любила писать тесты на инфраструктурный код, т.к. код нужно нормально писать; не надо усложнять и без того сложную предметную область.  Это позволило сделать кошелек клиента тоньше на нескромную сумму вечнозеленых долларов. А всего-то надо было проверить пограничные условия в функции вычисления сколько ВМ создавать.

## Гнев

Алену, это мало чему научило, он думала добавить в резюме список технологий с которыми принципиально не работает. Ну вот 1С например. написание тестов - туда же. все что может сломаться критично - замокано, потому что не проверишь,  остальное проверяет что в случае ошибки - вываливается ошибка.

## Торг

Время идет, тик-так, тик-так. Алена поменяла множество работ. И почти везде надо было писать тесты, это ее раздражало и она их писала нехотя, лишь бы были.

## Депрессия

У Алены был коллега, которые верил и умел в тесты инфраструктурного кода. Однажды Алене стало завидно... Стараешься, собеседования проходишь и получаешь вроде хорошее предложение на Кипре... А потом узнаешь что Сергею больше предлагают, причем в соседней подворотне буквально... Нужно было научиться тесты писать только.

## Принятие

В итоге Алена перешла в крупного аутсорсера из белоруссии  и её отправили писать тесты на powershell. Алена, признается, что это помогает ему спастись от клиентского гуру однострочников.
