# Как подготовиться к выступлению на технической коференции и не слететь с катушек?

*Date: 2024-08-09*

У меня [в копилке сотня технических выступлений](https://www.goncharov.xyz/) на английском и русском разной степени публичности. Вещал на международных конференциях, подкастах, делал с нуля курс по [Infrastructure as Code](https://gitlab.com/t-systems-devops-school/5-IAC), занимался [DevOps школой](https://habr.com/en/companies/deutschetelekomitsolutions/articles/521648/), подготовил несколько туторов. И знаете что? Я заметил некий паттерн в подготовке к техническим выступлениям. Вот, кстати, он:

![roadmap](assets/hms_roadmap.jpg?raw=true)

**P.S.** Сразу извиняюсь за англицизмы, но изначально это было выступление, которое было на английском, плюс статью пишу на двух языках. Так как это не является моей основной работой и мне жалко времени, то делаю так, чтобы проще синхронизировать было. Когда-нибудь, возможно, перепишу, заменив термины, но пока так.

## Why?

![why?](assets/hms_why.jpg?raw=true)

Прежде чем готовиться, вам надо ответить для себя на простой вопрос: **зачем оно мне?** Ответы могут быть разные, и они похожи на пирамиду Маслоу (холиварно, но всё же):

* **Structurize experience** — желание привести в порядок свои знания. Есть такая штука, что пока объяснишь — сам поймёшь. Например, выступить на митапе.
* **Knowledge** — формализация своего опыта, поисков ответов, почему было принято то или иное решение. Превращение опыта в знание. Обычно это уровень региональных конференций.
* **HR-brand** — в какой-то момент качество материала подрастает, что начинает помогать формировать HR-бренд: "Смотрите, у нас классные задачи, идите к нам работать". Как правило, это большие и международные конференции.
* **Meta** — это что-то на уровне devrel/евангелизм, когда несёте светлое людям, чтобы сделать мир лучше: ["Верите ли вы в Infrastructure as Code так, как в неё верю я?"](https://www.goncharov.xyz/it/idlc-ru.html).
Может быть множество других ответов:

* Хочу дороже продать себя на собеседовании.
* Начальник сказал надо сходить, иначе премии лишит
* Хочу съездить на конференцию бесплатно.
* ...

### Test

Ответ, кстати, может меняться со временем, и это нормально. Рефлексировать полезно в данной теме. Каждый шаг надо валидировать (это значок **Test** на схеме), чтобы иметь обратную связь и улучшать. Это будет применимо и ко всем последующим шагам:

* Появилась идея? Обсудите с коллегой за кофе.
* Не уверены в материале? Можно сделать звонок у себя в компании с коллегами, даже если их двое.
* Едете на конференцию? Сходить попробовать на митапе будет отличной идеей.

## Which topic should I choose?

Порой сложно выбрать готовую тему. У меня примерно такое деление:

### Хорошие темы

Это беспроигрышные варианты:

* **Problem solving** — у нас была проблема А (*хомячок полосатый, а заказчик попросил монотонного*), мы её решили так и сяк (*мелировали хомячка*). Хорошая, универсальная тема. Вероятно, к вам придут те, кто имеет схожую проблему, и либо вы ему расскажете решение, либо вам расскажут, как правильно.
* **Practical advises** — рассказать реальный опыт использования технологии, показать плюсы и минусы: *если попробовать мелировать светлых хомячков, то они становятся фиолетовыми. Не надо так*.
* **Digest / Top** — пощупали технологии, сравнили, пришли к выводам: *красить хомячков из пульверизатора быстрее, чем мелировать*.
* **Something painful** — люди ~~учатся на~~ слушать про чужие ошибки: *красить хомячков из пульверизатора быстро, но к нам пришли зоозащитники, и мы осознали глубину глубин. Так что мелирование наше всё*.
* **How does it work?** — как правило, никому не интересно слушать про свои велосипеды, которые не переносимы. Но если сделать разбор технологии, то как она работает под капотом, то будет ок: *как устроен пульверизатор?*
* **Technologies around us** — интересно выходят рассказы про технологии вокруг, которые обыватель не замечает, но там оказывается целый мир: *как устроен мир выращивания лабораторных хомячков*.
* **How-to for a viral topic** — взять хайповую тему и рассказать о ней, пока другие не успели.

### Спорные темы

Тут очень сильно зависит от автора и качества материала. Надо быть очень аккуратным. По первой, в эти темы лучше не лезть.

* **Tutorial** — это полезно, но очень сложно.
* **General theory** — теория всего и вся с момента большого взрыва у неопытного человека получится скучно и долго.
* **Overview of everything** — пересказ того, что есть в мире. Без центральной идеи/структуры обречен на провал.

### Плохие темы

* **Spam / Advertising** — открытая реклама, как правило, воспринимается в штыки.
* **Poor quality** — если плохой звук, картинка, материал, то закидают помидорами. Надеюсь, после этой статьи данный пункт не будет проблемой.

## Materials

![Materials](assets/hms_materials.jpg?raw=true)

Что видите на фото? Это куча несортированного непонятно чего. Это сырые заметки по теме, которую подумываете рассказать. Они могут быть совершенно разными:

* Images
* Links
* Ideas
* Messages
* Memes
* Code
* Test results
* Go live cases
* Benchmarks

Их задача — копиться, и когда вам надо будет пример: выдернуть, причесать и презентовать.

![Trello](assets/hms_trello.jpg?raw=true)

Где и как хранить, каждый решает сам. Нет готовых стандартов:

* Google Docs
* Trello / Jira / Your track
* Stickers on the wall
* Git repo
* OneNote / Evernote
* Dropbox / OneDrive
* Miro
* Obsidian

У меня изначально была связка Trello + Google Docs. В итоге пришёл к Obsidian + Git.

## Abstracts

![Abstracts](assets/hms_abstracts.jpg?raw=true)

На данном этапе задача сводится к тому, чтобы из той кучи сырых заметок вычленить главные тезисы. Они понадобятся для разного:

* Подача в оргкомитет.
* Понять, о чём рассказывать.
* Валидировать идеи.

Согласитесь, то, что на картинке выше, выглядит криво и замороченно, но это была подготовка к первой серьёзной конференции, и делал как мог. В следующей главе будет лучше, кстати. Ныне я так не заморачиваюсь. Накидал несколько тезисов/названий слайдов и хватит.

## Scenario

![Scenario](assets/hms_scenario.jpg?raw=true)

Готовим историю. Тут всё просто, так как основная работа была ранее сделана, и нам остается пройти по алгоритму:

* **State** — делаем утверждение. Зачастую это один из тезисов из предыдущей главы.
* **Explain** — подбираем слова, чтобы донести до слушателя/читателя, в чём суть нашего тезиса, может привести аналогию или пример (привет фактура с сырыми заметками).
* **Prove** — рыщем в фактуре, подбираем результаты тестов, историю из жизни. Что-то, что убедит аудиторию в тезисе.
* **Conclude** — делаем вывод из пруфов. Как правило, совпадает с утверждением, но не обязательно.

В качестве пруфа для этого утверждения привожу ссылку на расшифровку выступления [Что я узнал, протестировав 200 000 строк инфраструктурного кода](https://www.goncharov.xyz/it/200k-iac-ru.html) и предлагаю поискать матчинг между схемой для выступления и выступлением.

## Requisites

![Requisites](assets/hms_requisites.jpg?raw=true)

Готовим слайды на раз-два:

* 💬 **Empty slides & headers** — берём тезисы и делаем их заголовками для слайдов.
* 💩 **Put some raw data** — уже готовые пруфы с предыдущего шага накидываем на слайд как есть.
* 📝 **Create content** — сделать красивости можно попробовать делегировать, если есть кому. Но, как правило, самому.
* © **Copyright** — это важно, но лучше делегировать.

### Create content

* Extend the speech via slides
* Use simple code examples
* Add roadmaps
* 5±2

#### Extend the speech via slides

Так что же должно быть на слайдах? Есть прекрасная презентация [Death by PowerPoint](https://www.slideshare.net/thecroaker/death-by-powerpoint) — рекомендую к изучению.

##### Text on slides

![Bad](assets/hms_text_bad.jpg?raw=true)

Слайды с кучей мелкого текста смотрятся ужасно по многим причинам:

* Люди читают быстрее, чем вы говорите.
* Люди не могут и слушать, и читать одновременно (анимэшники молчать!).

Такое решение работает только как раздатка, но вы же не будете делать два варианта слайдов, правда?

![Good](assets/hms_text_good.jpg?raw=true)

Основные задачи слайда:

* Быть дополнением вашей речи.
* Визуализировать смыслы.
* Быть путеводной картой.

Я обычно делаю так:

* Выбираю первую попавшуюся картинку на [flaticon.com](https://www.flaticon.com/)
* Возможно комбинирую несколько
* Спустя какое-то время мб вернусь и заменю

Из бонусов — это копирайты: их достаточно указать на самом последнем слайде, и его даже можно не показывать (если ничего в условиях использования сервисом не поменялось).

##### Screenshots

Фото и скриншоты желательно подрезать/растягивать на весь слайд и не оставлять белых полей, так смотрится целостней.

![Screenshots 1](assets/hms_screenshots_1.jpg?raw=true)

Нормально заходят скриншоты известных тулов, чтобы человек быстро погрузился в контекст. Опционально можно подсветить лупой важный элемент.

![Screenshots 2](assets/hms_screenshots_2.jpg?raw=true)

А вот скриншоты неизвестных программ плохо — человек теряется. Вот многие из вас работали с [galaxy.ansible.com](https://galaxy.ansible.com)?

##### Text on screenshots

![Screenshots 3](assets/hms_screenshots_3.jpg?raw=true)

Текст без подложки трудно читаем.

![Screenshots 4](assets/hms_screenshots_4.jpg?raw=true)

Если же её подкрасить, то сразу более читаемо.

#### Code

![Code](assets/hms_code.jpg?raw=true)

Много кода не читаемо, так как человеку надо загрузить его в голову. Поэтому убираем всё лишнее:

* Подсветку синтаксиса.
* Нумерацию строк.
* Пишем псевдокод.
* Убираем ненужный синтаксический сахар.

Как надо:

* На слайде пара-тройка строк кода, и они показывают самую суть.
* Моноширинный шрифт
* Шрифт максимально большой, чтобы с последнего ряда было видно
* Если очень сильно хочется, то можно подсветить что-то одно конкретное на слайде другим цветом.

#### Roadmap

![roadmap](assets/hms_roadmap_partial.jpg?raw=true)

Хорошо себя показывают дорожные карты, они выступают напоминалкой, где мы, как долго ещё и склеивают части рассказа между собой.

#### 5±2

Есть [Магическое число семь плюс-минус два](https://ru.wikipedia.org/wiki/%D0%9C%D0%B0%D0%B3%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5_%D1%87%D0%B8%D1%81%D0%BB%D0%BE_%D1%81%D0%B5%D0%BC%D1%8C_%D0%BF%D0%BB%D1%8E%D1%81-%D0%BC%D0%B8%D0%BD%D1%83%D1%81_%D0%B4%D0%B2%D0%B0) — человек не может удержать в голове слишком много, поэтому:

1. Списки — наш друг.
2. На каждый слайд добавляем по 1, максимум 2 новых элемента. Их можно подсветить.
3. В целом не надо стараться больше 7 идей донести, а лучше 4.

### Presentation as Code

Немного технической стороны вопроса, это не обязательно, но не могу не поделиться.

Изначально я делал всё в PowerPoint и страдал:

* Версионировать это ад.
* Нет совместного редактирования.
* Формат отличается от Markdown, в котором все мои заметки.
* Объемные файлы.

В данный момент перехожу на подход **Presentation as Code**.

1. Создаю презентацию в синтаксисе Markdown: [marpit.marp.app](https://marpit.marp.app/markdown).
2. Рисую изображения через приложение draw.io в формате SVG.
3. Храню всё в Git.
4. Экспортирую презентацию в PDF.

Интеграция с VS Code:

* [marp-team.marp-vscode](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)
* [hediet.vscode-drawio](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)

У решения есть минусы:

* Выше порог входа.
* Нет режима презентера с подсказками.

Пример куска презентации:

```md
---
marp: true
theme: default
paginate: true
style: |
    section {
        justify-content: flex-start
    }
    h1,
    strong {
        color: #E20074;
    }
---
<style scoped>
    section {
        background-color: #E20074;
        justify-content: center;
    }
    h1,
    h3 {
        color: white;
    }
</style>
<!-- _paginate: skip !-->

## Terraform 4 VmWare in XXX

lev@xxxx
xx.xx.2023

---
<!-- _paginate: hide !-->
## IaC: use cases

![bg contain](./assets/IaC_usecases.svg)
```

## Show

Есть разные форматы мероприятий, но в общих чертах это:

* **Corporate events** — безопасная площадка для валидации идеи.
* **Meetups** — хорошее место накинуть на вентилятор в поисках решения проблемы. Можно валидировать материалы перед конференциями.
* **Conferences** — [есть разница между международными и СНГ](https://habr.com/en/articles/487432/), но как правило сюда сложнее попасть, поэтому опишу, как выглядит в среднем процесс.

### Interaction with organizers

#### 0. Apply

Ищем площадку, готовим тезисы и подаемся. Иногда есть готовые порталы, иногда нужно писать на почту. Стандартного нет. Полезно приложить ссылки на другие выступления, если есть, чтобы организаторы могли оценить уровень.

#### 1. Initial call

Крупные площадки могут захотеть созвониться, а может и переписки хватит.

#### 2. Demo

Это редкий зверь, у меня ни разу не было, но люди говорят, встречается в природе.

#### 3. Accept

В какой-то момент оргкомитет принимает решение брать или нет в программу. На серьёзных площадках прикрепляют ментора, который ведет человека до выступления.

#### 4. Dry-run

![Dry-run](assets/hms_dryrun.jpg?raw=true)

Это активная фаза подготовки, материал обкатывается/тестируется на аудитории. Фидбэк тщательно собирается, структурируется и рефлексируется.

#### 5. Show

Есть небольшая разница между офлайн и онлайн выступлениями, но есть общие советы:

1. Сконвертировать презентацию в PDF.
2. Разослать всем причастным:
    * Организаторам.
    * Положить на флэшку.
    * Выложить в публичный доступ.
3. Взять стакан воды или бутылку с водой.

Как-то был прекрасный опыт:

* За 5 минут до презентации узнал, что не та версия на ноутбуке организаторов.
* За 2 минуты до узнал, что в Dropbox и на флэшке лежит не та версия, помогло то, что на сайт выложил PDF.
* Во время выступления отказал экран презентера, и рассказывал по памяти.

##### Offline

![Offline](assets/hms_offline.jpg?raw=true)

Кстати, про экран презентера, на больших эвентах у вас может быть такое:

1. Беспроводной микрофон, возможно петличка.
2. Почти всегда есть кликер.
3. В ногах часы с таймером обратного отсчета.
4. В ногах или перед глазами дублирующий монитор с тем, что видят зрители.

А может этого всего и не быть, если мероприятие попроще. Обычно я с собой вожу:

* Переходники Type-C -> VGA, VGA -> HDMI, HDMI -> VGA и всякое такое разное.
* Флэшка, зарядка, ноутбук.
* Вместо кликера использую мышку или мини беспроводную клавиатуру.

Но это всё баловство. Из лайфхаков:

* Прийти чуть заранее в место проведения и побродить. Как бы "пометить" и освоиться.
* Во время выступления можно "выбрать жертву" и как бы рассказывать историю конкретному человеку, смотреть его реакцию.
* Не надо читать, представьте, что вы с другом в баре рассказываете захватывающую историю (но без перегибов).
* Если забудете что-то — не страшно.

#### Online

![Online](assets/hms_online.jpg?raw=true)

Основная проблема online — это беспроводные технологии и канал. Поэтому:

1. Подключаем интернет проводом и держим запасной вариант связи.
2. Используем проводную гарнитуру.
3. Заранее проверяем задний фон.
4. Искусственное освещение лучше дневного, так как зашло солнце — освещение поехало.

Но еще большая проблема — это сложность обратной связи в режиме реального времени; аудитория не чувствуется. Тут у меня только предложение просить людей кидать эмоджи, чтобы хоть как-то оценить, что с аудиторией.

## Results

![Results](assets/hms_results.jpg?raw=true)

Как ни странно, но выступление не заканчивается после выступления. Подумайте сами: вы уже структурировали материал, наклепали мемасиков — остается только написать текст, который и так знаете наизусть.

### Landing

![Landing](assets/hms_landing.jpg?raw=true)

Последний слайд выступления обычно самый фотографируемый. Поэтому на него выношу:

1. Основную идею / roadmap выступления.
2. Контакты, ссылку на **лэндинг**.

Где хостить **лэндинг**?

* [habr.com](https://habr.com)
* [reddit.com](https://reddit.com)
* [linkedin.com](https://linkedin.com)
* [medium.com](https://medium.com)
* [pages.github.com](https://pages.github.com)

Основная проблема здесь в том, что ссылка на лэндинг нужна в момент выступления, а расшифровка будет когда-то потом (про образ этого выступления я делал почти 5 лет назад, и вот только дошли руки напечатать...).

Поэтому у меня такая связка:

1. GitHub Pages — там в Markdown пишу посты всякие.
2. Купил домен за 2€.
3. Взял публичный бесплатный почтовый сервис.
4. Прикрутил Google Analytics.

То есть [www.goncharov.xyz](https://www.goncharov.xyz) хостится на [github.com/ultral/ultral.github.io](https://github.com/ultral/ultral.github.io) . Его также можно посмотреть через [github.com/ultral/ultral.github.io/blob/master/README.md](https://github.com/ultral/ultral.github.io/blob/master/README.md), и оно автоматически публикуется. Сплошные плюсы:

1. Есть прикольная почта.
2. Когда делаю презентацию, сразу делаю лэндинг на последней странице (последний слайд самый фотографируемый, не считая мемов) и перевожу аудиторию в онлайн. А так как есть Google Analytics, видно, сколько народу пришло.
3. После спича выкладываю расшифровку на лэндинг.

Получается win-win:

* **У меня** — понимание качества материала и возможность его улучшения.
* **У слушателей** — возможность уточнить упущенные моменты.
* **У пользователей интернета** — прочитать то, куда они не ходили.

### Writing

![Writing](assets/hms_writing.jpg?raw=true)

Есть неплохой [гайд от Хабра](https://habr.com/ru/docs/companies/design/), как писать, но если кратко:

* **Headline** — заголовок очень важен. Потратьте время, поищите продающее название. Можно добавить реальные цифры, чтобы человек примерил на себя.
* **Related pic** — выбираем лучший мемасик из фактуры, надо зацепить, чтобы не прошли мимо.
* **Lead** — самый сок, как правило это тезисы, но в интересных формулировках. А формулировки определяются через итеративное собирание обратной связи.
* **Main part** — собственно текст, ниже разбрем как его готовить.

![Writing](assets/hms_writing_draft_1.jpg?raw=true)

В целом все как со слайдами:

* 💬 **Empty slides & headers** — берем тезисы и делаем их заголовками для слайдов.
* 💩 **Put some raw data** — уже готовые пруфы с предыдущего шага накидываем на слайд как есть.
* 📝 **Create content** — сделать красивости можно попробовать делегировать, если есть кому. Но, как правило, самому.
* © **Copyright** — это важно, но лучше делегировать.

Вначале пишем драфт, он может быть кривым. Это нормально.

![Writing](assets/hms_writing_draft_2.jpg?raw=true)

На следующий день/неделю/месяц его перечитываем, причесываем и публикуем.

### PR

Если хочется заморочиться, то можно постить на разные площадки:

* Instagram / Facebook / LinkedIn / Twitter
* [reddit.com](https://reddit.com).
* [news.ycombinator.com](https://news.ycombinator.com).
* Telegram.

Но по моим наблюдениям, оно в итоге будет проиндексировано и люди будут приходить читать, говорить спасибо.

## Вместо заключения

![roadmap](assets/hms_roadmap.jpg?raw=true)

Не надо стесняться выступать, не надо накручивать себя и придумывать синдром самозванца. Горшки не боги обжигают, и выступления/писанина такой же скилл. Он помогает привести мысли в порядок и яснее доносить свои идеи.

## Links

* [Death by PowerPoint](https://www.slideshare.net/thecroaker/death-by-powerpoint)
* [How to create a post for a corporate blog](https://habr.com/ru/info/topics/toolkit/)
* [Пилим статью на Хабр](https://habr.com/en/post/473632/)
* [Конференции: начало пути](https://habr.com/en/company/tinkoff/blog/472046)
* [Хорошее публичное выступление: 11 простых советов](https://habr.com/en/post/476342/)
* [Авторам технических текстов: как писать о сложном и не быть занудой?](https://habr.com/en/article/478548/)
* [Cross post](https://vas3k.club/post/25231)
* [Russian version](how-to-make-speech-ru.md)
* [English version](how-to-make-speech-en.md)