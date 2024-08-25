---
redirect_from:
    - /hms
    - /life/how-to-make-speech.html
---
# How to Make a Technical Speech and Not Go Nuts

I have made [100 technical speeches](https://www.goncharov.xyz/) in English, Russian, and Spanish at international conferences, meetups, podcasts, etc. I have created the [Infrastructure as Code](https://gitlab.com/t-systems-devops-school/5-IAC) course from scratch, pushed up [DevOps school](https://habr.com/en/companies/deutschetelekomitsolutions/articles/521648/), and mentored a couple of tutors. Believe it or not, I have spotted a pattern:

![roadmap](assets/hms_roadmap.jpg?raw=true)

## Why?

![why?](assets/hms_why.jpg?raw=true)

Before starting, you should have a clear answer to the question: **Why do I need it?** There are many possible answers, and there is no silver bullet. However, it's possible to organize them into something like [Maslow's hierarchy of needs](https://en.wikipedia.org/wiki/Maslow%27s_hierarchy_of_needs):

* **Structurize experience** — You want to structure and organize your experience.
* **Knowledge** — You transform your experience into something bigger, into fundamental knowledge.
* **HR-brand** — At some point, your knowledge and skills are cool enough to enhance the HR brand of your company. Speeches promote companies and help with staffing.
* **Meta** — You become a devrel or a technology advocate. You want to make a better world: ["Do you believe in IaC as your saviour?"](https://www.goncharov.xyz/it/idlc-ru.html).

There are many other possible answers:

* You want to earn more money.
* Your team lead told you to make a speech.
* You desire to visit another city.
* ...

### Test

Answers are not static. Time flies, and answers can change. It is crucial to reflect on them to create a feedback loop. This allows for improvement. Moreover, the **Test** idea is applicable to each step on the roadmap:

* Have a new idea? Grab a cup of coffee and discuss it with workmates.
* Not sure about materials? It's totally okay to schedule a call with colleagues (who also give speeches).
* Going to a conference? It makes sense to check local meetup communities and have a dry run.

## Which Topic Should I Choose?

There are no out-of-the-box solutions. However, there are some clues:

### Good

I am almost 100% sure that you will prepare good enough materials for:

* **Problem solving** — Business had problem **A**, we failed with approach **B**, however, approach **C** provided good enough numbers **D**. Usually, people with the same pain/problem will attend your speech. As a result, you will be able to look at your problem from a different perspective or help somebody solve the problem.
* **Practical advice** — Hands-on experience is crucial because people should not reinvent the wheel. It can be:
  * Lessons learned ...
  * Best practices for ...
* **Digest / Top** — If you compare different technologies/approaches and make some conclusions, it can simplify somebody's life.
* **Something painful** — People like to ~~learn from~~ listen about somebody else's ~~screw-ups~~ findings.
* **How does it work?** — If you are not FAANG / MANGA, almost nobody likes to listen about your kludges. However, a deep dive into the technologies and understanding the underlying foundations is interesting.
* **Technologies around us** — It is quite interesting to read about technologies in the real world and on the edge of different areas. But it also requires deep understanding, broad knowledge, and a non-standard perspective/angle of view.
* **How-to for a viral topic** — If you catch a hype wave, you can get a quite big audience.

### + / -

These topics really depend on the material quality and the author's expertise and soft skills. One must be very accurate and patient. If you are a beginner or not confident enough, then just avoid them:

* **Tutorials** are very much needed usually, but it is really hard to create them.
* **General theory** — It is quite tricky to create an interesting speech that is not boring.
* **Overview of everything** — A story without a concrete theme is interesting for a wide audience with completely different expectations. It will be almost impossible to meet all expectations.

### Bad

* **Spam / Advertising** — Nobody likes spam or advertising.
* **Poor quality** — If it can be googled in 5 minutes, it is not worth presenting. A bad mic, poor internet connection, and bad slides can also lead to bad feedback.

## Materials

![Materials](assets/hms_materials.jpg?raw=true)

What can you see in the picture? It is a huge unsorted pile of something. It represents raw notes about your theme. Here are some examples:

* Images
* Links
* Ideas
* Messages
* Memes
* Code
* Test results
* Go-live cases
* Benchmarks

The goal is to store factual information so that, when needed, you can find, organize, and present it.

![Trello](assets/hms_trello.jpg?raw=true)

There is no silver bullet for how to organize this information:

* Google Docs
* Trello / Jira / Your tracker
* Stickers on the wall
* Git repo
* OneNote / Evernote
* Dropbox / OneDrive
* Miro
* Obsidian

Originally, I used Trello + Google Docs. Nowadays, I use Obsidian + Git.

## Abstracts

![Abstracts](assets/hms_abstracts.jpg?raw=true)

At this stage, you should distill the essence from your notes and prepare good abstracts from it. They will be required later for:

* Calls for papers.
* Understanding your guiding line.
* Validating your idea.

You might agree that mind maps can look a bit ugly and unstructured. The one shown was preparation for my first big conference. I did my best. The idea is that it should not be perfect at this stage. Moreover, nowadays I no longer create mind maps. I just write down theses, and that's it.

## Scenario

![Scenario](assets/hms_scenario.jpg?raw=true)

At this stage, abstracts transform into a fully completed story. Hopefully, the vast majority of the work has been done previously. Just follow this algorithm:

* **State it** — Select one thesis from the previous stage.
* **Explain it** — Find the right words to simply explain your statement. Share an example. Check your factual information one more time; maybe you have something relevant.
* **Prove it** — Concrete facts, proofs, benchmarks, and stories from real life are required.
* **Conclude it** — Usually, you just repeat the initial statement, but it is not obligatory.

As proof, I provide a link to my speech [Lessons learned from testing Over 200,000 lines of Infrastructure Code](https://www.goncharov.xyz/it/200k-iac-en.html) and propose comparing it with the roadmap.

## Requisites

![Requisites](assets/hms_requisites.jpg?raw=true)

Preparing slides is as easy as pie:

* 💬 **Empty slides & headers** — Create headers for empty slides from theses.
* 💩 **Put some raw data** — Copy proofs from the previous step as is.
* 📝 **Create content** — Make something beautiful and readable. Delegate if you can.
* © **Copyright** — Important but not a blocker. Delegate if you can.

### Create Content

* Extend the speech via slides.
* Use simple code examples.
* Add roadmaps.
* 5±2.

#### Extend the Speech via Slides

What should be presented on the slides? I recommend going through [Death by PowerPoint](https://www.slideshare.net/thecroaker/death-by-powerpoint).

##### Text on Slides

![Bad](assets/hms_text_bad.jpg?raw=true)

Slides with an enormous amount of text are not participant-friendly:

* People read faster than you talk.
* People cannot read and listen simultaneously.

However, there are some important notes:

* It can make sense as printed-out material after meetings.
* For non-native listeners and speakers, it will be much easier to follow along.

![Good](assets/hms_text_good.jpg?raw=true)

The main goals of slides are:

* Extend your speech.
* Visualize ideas.
* Serve as the roadmap.

My algorithm:

* Select the first relevant picture on [flaticon.com](https://www.flaticon.com/). I do not spend more than 5 minutes on that.
* It is totally fine to combine different images together.
* Maybe later I will replace it.

##### Screenshots

Photos and screenshots look better if they are fitted to the slide size without white margins.

![Screenshots 1](assets/hms_screenshots_1.jpg?raw=true)

It is okay to make screenshots of well-known tools/websites because participants will be in the context. Optionally, you can emphasize something with arrows or a magnifying glass.

![Screenshots 2](assets/hms_screenshots_2.jpg?raw=true)

If you present screenshots of barely known programs/websites, you might lose the audience. For example, are you familiar with [galaxy.ansible.com](https://galaxy.ansible.com) shown on the screen?

##### Text on Screenshots

![Screenshots 3](assets/hms_screenshots_3.jpg?raw=true)

Text without underlying print can be hard to read.

![Screenshots 4](assets/hms_screenshots_4.jpg?raw=true)

If you colorize it, you can increase readability.

#### Code

![Code](assets/hms_code.jpg?raw=true)

A huge amount of code is not readable. People need to load it into their minds and understand the context. The solution is to cut down all unimportant parts. The piece of code might be uncompilable, but it must convey the gist. To sum up:

* Disable syntax highlighting.
* Remove line numbers.
* Write pseudocode.
* Drop syntax sugar.

Good:

* There are 3-10 lines of code.
* Monospaced font.
* The maximum size of the font.
* If it is really required, you can highlight the important words/strings.

#### Roadmap

![roadmap](assets/hms_roadmap_partial.jpg?raw=true)

Roadmaps are a really cool way to stay on the same page with the audience. They also help to glue different parts of your story together.

#### 5±2

There is [The Magical Number Seven, Plus or Minus Two](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two) — one cannot keep too much in the head, so:

1. Lists are our friends. The key benefit is that they are simple.
2. Only one new thing/idea should be introduced on each slide. It is okay to highlight it with another color.
3. One should not present more than 4-5 ideas in a speech.

### Presentation as Code

In the past, I used PowerPoint for presentations. There are some problems with it:

* Versioning.
* There is no collaborative mode.
* I have to convert my notes from Markdown to pptx somehow.
* Immense file size.

It looks like there is a pretty cool replacement for PowerPoint that allows having **Presentation as Code**.

1. Create a presentation in markdown syntax using [marpit.marp.app](https://marpit.marp.app/markdown).
2. Draw images via the draw.io app in SVG format.
3. Store it in git.
4. Export the presentation as a PDF.

It can also be easily integrated with VSCode:

* [marp-team.marp-vscode](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)
* [hediet.vscode-drawio](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)

There are some downsides:

* The entry level is much higher.
* There is no presenter mode.

*Slides sources example:*

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

## Terraform 4 VMware in XXX

lev@xxxx
xx.xx.2023

---
<!-- _paginate: hide !-->
## IaC: use cases

![bg contain](./assets/IaC_usecases.svg)
```

## Show

There are some common types of events:

* **Corporate events** — A very safe place to validate your ideas.
* **Meetups** — A good place for discussions. It makes sense to do a dry run before a conference.
* **Conferences** — It is not easy to get into these, so I would like to describe the algorithm.

### Interaction with Organizers

#### 0. Apply

Just search for an interesting conference, prepare abstracts, and apply. Sometimes, there is a web portal for applications. Other times, it is enough to send emails to the organizing team. There is no unique way. It makes sense to attach links to your previous speeches if you have them.

#### 1. Initial Call

Usually, a big conference's organizing team plans a warm-up call. However, sometimes an email conversation is sufficient.

#### 2. Demo

This is quite rare. I have only had to do this twice out of 100 speeches.

#### 3. Acceptance

At some point, the organizing team decides whether or not to include your speech in the program. A mentor may be assigned to help you prepare the speech.

#### 4. Dry Run

![Dry-run](assets/hms_dryrun.jpg?raw=true)

This is the crucial phase. The speech should be validated and tested in front of an audience. Feedback must be collected, processed, and reflected upon.

#### 5. Show

On one hand, there is a significant difference between online and offline presentations, but on the other hand, there are some commonalities:

1. Convert your presentation to a PDF.
2. The presentation should be:
    * Sent to the organizing team.
    * Uploaded to a USB stick.
    * Shared on the internet.
3. Get a bottle of water.

In the past, I had awkward experiences:

* 5 minutes before the speech, I realized that the organizing team uploaded the wrong version to the laptop.
* 2 minutes before the speech, I realized that the old version was uploaded to my USB stick. Fortunately, I downloaded the right version from my website.
* During the speech, the presenter's display went dead.

##### Offline

![Offline](assets/hms_offline.jpg?raw=true)

By the way, here are some notes about the presenter's display. At big conferences, you might also find:

1. Wireless mice to have free hands.
2. Clickers for changing slides.
3. Clocks somewhere at the bottom.
4. A display in mirror mode in front of you.

However, it is possible to make a speech without all these extensions. Usually, I bring:

* Type-C -> VGA, VGA -> HDMI, HDMI -> VGA, and other adapters.
* USB stick, chargers, laptop.
* Use a mouse or mini keyboard as a clicker.

Let me also share some useful life hacks:

* Come 10-30 minutes before the speech and walk around the audience area.
* During the speech, you can "select somebody" in the audience and track their feedback.
* Do not read; just imagine you are in a bar with your workmate and you are sharing a funny story.
* If you forget something, it is not the end of the world. The show must go on.

##### Online

![Online](assets/hms_online.jpg?raw=true)

The biggest headache of online events is wireless technologies, so:

1. Connect to the internet via a wired connection.
2. Use a wired headset.
3. Check your background.
4. Artificial lights are better than natural because they are predictable.

The most intriguing challenge is the real-time feedback from the audience. It is really hard to feel the audience. Usually, I ask them to share some emojis.

## Results

![Results](assets/hms_results.jpg?raw=true)

The fun fact is that the speech does not end after the last slide. Just think a little bit: you've already put things in order, prepared the materials, created the memes, and learned the text by heart. The only thing missing is transcribing the speech to text. It is as easy as pie.

### Landing

![Landing](assets/hms_landing.jpg?raw=true)

The last slide is the most valuable. Usually, participants take a picture of it. It would be nice to put on the last slide:

1. The main idea/roadmap.
2. Contacts, and the link to your **landing page**.

Where can I host my **landing page**?

* [habr.com](https://habr.com)
* [reddit.com](https://reddit.com)
* [linkedin.com](https://linkedin.com)
* [medium.com](https://medium.com)
* [pages.github.com](https://pages.github.com)

The main problem here is that the link must exist during the speech, but the transcription can be done 2 years later. In that case, I really advise:

1. Use GitHub Pages.
2. Buy a domain for approximately 2€.
3. As a benefit, you can have a useful email address and collect feedback via Google Analytics.

For example, [www.goncharov.xyz](https://www.goncharov.xyz) is hosted as [github.com/ultral/ultral.github.io](https://github.com/ultral/ultral.github.io). It is also reachable via [github.com/ultral/ultral.github.io/blob/master/README.md](https://github.com/ultral/ultral.github.io/blob/master/README.md):

The situation is win-win:

* **I** have feedback and measurable results.
* **Participants** have the ability to recap missed information.
* **Internet users** can read without attending the event.

### Writing

![Writing](assets/hms_writing.jpg?raw=true)

There is a [quite good guide](https://habr.com/en/docs/companies/design/) on how to write a good article. Let me share the gist:

* **Headline** is crucial. You have a couple of seconds while scrolling to catch the audience's attention. Think twice.
* **Related pic** is quite similar to the headline. You should catch the audience's attention. So select the best memes from the factual information and think twice.
* **Lead** is the gist of your speech/article. You can use your rephrased abstracts.
* **Main part** is the easiest part. Let me share the algorithm.

![Writing](assets/hms_writing_draft_1.jpg?raw=true)

It is quite similar to slide preparations:

* 💬 **Empty slides & headers** — Create headers for empty slides from theses.
* 💩 **Put some raw data** — Copy proofs from the previous step as is.
* 📝 **Create content** — Make something beautiful and readable. Delegate if you can.
* © **Copyright** — Important but not a blocker. Delegate if you can.

Just start writing a draft. It can be ugly, and that is totally okay.

![Writing](assets/hms_writing_draft_2.jpg?raw=true)

On the next day/week/month, reread, rephrase, rethink, and then publish.

### PR

If you have free time, you can promote your article on:

* Instagram / Facebook / LinkedIn / Twitter
* [reddit.com](https://reddit.com)
* [news.ycombinator.com](https://news.ycombinator.com)
* Telegram

From my experience, people will say *thank you* sooner or later.

## PS

![roadmap](assets/hms_roadmap.jpg?raw=true)

Do not be shy. Start writing and speaking. It is a skill like driving or reading.

## Links

* [Death by PowerPoint](https://www.slideshare.net/thecroaker/death-by-powerpoint)
* [How to create a post for a corporate blog](https://habr.com/en/info/topics/toolkit/)
* [Cross post](https://vas3k.club/post/25231)
* [Russian version](how-to-make-speech-ru.md)
* [English version](how-to-make-speech-en.md)
