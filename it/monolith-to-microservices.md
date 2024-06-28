# Monolith to microservices

I'd like to share my story about migration monolith application into microsevices. Please, keep in mind that it was during 2012 - 2014. It is transcription of my presentation at [dotnetconf(RU)](http://dotnetconf.ru/materialy/monitoringandalerting).
* [Slides (RU)](https://cloud.mail.ru/public/AQgP/pJKNrcbp2)
* [Video (RU)](https://www.youtube.com/watch?v=IrAgn8YPm2Y)

# Project description

![project description](assets/mmonolith2microservices_02.png?raw=true "Project description")

The main project idea was to crawl articles from the internet, analyze it, save & create user feed. On one hand, our infrastructure had to be reliable, but in the other hand, we were on budget. As a result, we agreed that:
* System performance degradation is allowed.
* Some parts of our infrastructure might be down for 30 min.
* In case of disaster, downtime might be some days.

I'm going to share story about changing every part of the infrastructure.

![infrastructure](assets/mmonolith2microservices_41.png?raw=true "infrastructure")

## Crawlers

![Crawlers](assets/mmonolith2microservices_06.png?raw=true "Crawlers")

It was a simple part of the infrastructure. Crawlers should download, analyze & save. The first one implementation was single crawler, however, world was changing & a lot different crawlers were appeared. Crawlers were communicating with each other by MsSQL.

Downtime wasn't a problem for crawlers, so it was really easy to scale them:
* Automate provision.
* Add business metrics.
* Collect errors.

## MsSQL

![MsSQL](assets/mmonolith2microservices_08.png?raw=true "MsSQL")

Our database was about 1TB.

### MsSQL cluster

There were different ways how to create a cluster:
1. SQL mirroring.
2. Windows failover cluster - it wasn't a case because there were no san/nas.
3. AlwaysOn - it was completly new for us and there was no expertise in it, so, it wasn't a case for us.

As a result, we decided to use the 1th. I'd like to notice that we didn't use witness because of async mode, so we created scripts for auto switch master -> slave & manual slave -> master.

### MsSQL perfomance

![MsSQL](assets/mmonolith2microservices_12.png?raw=true "MsSQL")

The clock was ticking, a performance were degrading, we were searching bottlenecks. Sometimes, it wasn't easy, i.e. were optimizing sql queries by disk io, when, we found that the performance was low because of lack of RAM. However it was not enough, as a temporary solution we migrated from HDD to SSD. On one hand, it increased the performance dramatically, but on the other hand, it wasn't a long term solution.

## Message Queue

![Message Queue](assets/mmonolith2microservices_15.png?raw=true "Message Queue")

Our application had been migrated to a message queue. We were writing only results into the database. As a result, we reduced database load. But we faced a problem: how to organize a message queue cluster? At the first we created cold standby.

## WEB

![WEB](assets/mmonolith2microservices_20.png?raw=true "WEB")

A web part consisted of two parts: static content & user dynamic content.

### WEB static

![WEB static](assets/mmonolith2microservices_23.png?raw=true "WEB static")

WEB static part of the infrastructure was about 2TB, it had to:
* Store images.
* Convert images.
* Crawl origin image & crop if needed.

![WEB static](assets/mmonolith2microservices_26.png?raw=true "WEB static")

There were 2 major issue: how to sync files & how to create web cluster. There were some ways how to sync files: buy a storage, use DFS & save files at each server. It was tough decision, however, we decided to choose the 3rd way. For the web cluster we decided to use NLB & CDN.

### WEB Balancer
