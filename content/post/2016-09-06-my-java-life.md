---
layout: post
title: "My Java Life"
date: 2016-09-06T00:05:00-07:00
lastmod: 2018-08-17T03:32:09-07:00
draft: false
aliases:
 - /2016/09/my-java-life.html
---

This first blogpost on this now new blog, is a trip to memory lane about my first encounters with the Java programming language. I spent the last ten years developing in .NET but before that did use Java. At the end of 2015 I got a Job offer I could not refuse but... It included Java EE and Android development. Ok.. while teaching others about .NET LINQ, lambda's Monads, OData and JavaScript I started relearning myself Java, Java EE and Android. I also peeked into Scala, Akka, Play, Kotlin and Ceylon again.

### First encounters

I was introduced to Java in early 1995 at the ACM European programming contest. We lost but there were great talks by Sun and Andrew Tanenbaum. I still have some Duke pins somewhere. During an internship and my master thesis I used Java. For .NET heads. Duke, a funny figure with a red nose is Java's Mascotte since at least 1995.

### Second encounter

To get up to speed with Java again, I read some books on what has Changed in Java 7 & 8 first and then focused on learning Java EE and Android development. A lot has changed since 2005. IDEs have improved a lot. J2EE got rebranded Java EE. Why didn't anybody tell me that??? Search books for J2EE gets you ancient stuff. If you search for Java EE you get less ancient stuff. I carefully consulted coworkers and the online Java community whether I was learning the right stuff. I teached C# 3.5 once. Some of my students came to me with ancient 1.0 solutions. That was not something I want for my wanderings in the world of the Duke.

### Duke's candy store or stuff to use

On the library part, there is more useful stuff In Maven Central than in Nuget.org. Like .NET, Java has a community with a lot of great awesome people that helped me learning to do the Java walk again.

Only the language, the Java language sadly did not change much. Some of the features I was used to in .NET did not exist in 2000 but do exist now:

* Decorators ocured when I left the Java world. In .NET we know them as Attributes.
* Streams\* LINQ in .NET but without the syntactic sugar.\
   Something that deserves a closer look.
* Autocloseable with try/catch Using in .NET
* Lambdas The same concept in .NET. I have to investigate the differences.

\*Yes I am aware of RX.

### Java Beans

Sadly the most important thing is missing. Java does not have is have syntactic sugar for properties.

To Java programmers I say: try another language, C#, F#, Scala and see for yourself what is missing.

Back in In 1998 I did an internship at a large defence contractor in the Netherlands investigating the then new concept Java Beans. Core parts of Bean definition:

* Have default constructor,
* have a getter function to get a property, e.g. `'String getName();'`
* have a 'void' setter function to set a property, e.g. `'void setName(String value);'`

To make it more interesting there were PropertyChangeListener en VetoableChangelistener.

At that time we had a beta of IBM Visual Age, the predecessor of Eclipse. It allowed graphical construction of your application with beans by drawing lines between them. It was a great tool to demonstrate the concept. However drawing lines does not scale well with realistic applications with many relations. Today's IDEs Like Eclipse, Android Studio or Visual Studio still allow the composition of GUI and non GUI components but drawing lines to express relations is not used anymore. Short conclusion: Using beans is beautiful.

### My first Bean Generator

At the the end of 1998 I started with my master thesis at the same company. With that thesis came writing a prototype compiler for a specification language I designed. The language is not important. I used a Java based compiler generator to get the Abstract Syntax Tree(AST) of my language. For analyzing/compiling the tree into a result I used a lot of Java Beans. At the end I used a Sed based script that generated the beans for me from a text file:

* First line is the class
* next lines are properties .
* First word is the type.
* Second word is the name.
* New line separates current from the next bean.

I used a few variations of the script to generate both simple beans and beans with PropertChangeListener and VetoableChangeListener interfaces.

Writing/generating this many beans seeded my dislike of the Java programming language.

I come back to beans in another blogpost

### Java EE

I missed the start of Java EE or J2EE as it was called in the early 2000's. when SOA, XML and SOAP were hot items. At that time I was doing a lot of quick prototyping and Java EE and SOAP were complex beasts I did not need. I used XML for configuration files and messaging. That saved time writing parsers.

Now 2016 I am developing with Java EE. Java EE has changed from an ugly duck to a mature beautiful swan. Some say it is already legacy but I consider it useful proven technology. It provides you with: security, scalability, persistence, logging,caching, dependency injection, REST/SOAP based web services and more stuff application programmers often get wrong when they do it themselves. It provides you with the tools to write business logic in AOP untangled style: Readable, Maintainable and Reliable.

I Really like the Context and Dependency Injection(CDI) framework in in Java EE and will come back to that in a later post.

### Other Stuff

Recently I also assisted in Android development. Android used the Java language but it has it's own set of rules I am still discovering the exciting world of app development. At the moment Consider myself to be not knowledgeable to say much about it. Maybe in a later post.

In .NET the Visual Studio IDE is dominant. Some hipsters use vi, emacs or whatever but most professionals use Visual Studio which imho is a good but BIG IDE. In the Java world there is not a dominant IDE. Well for Android you have Android Studio, but for Java EE development people use Eclipse, IntelliJ, Netbeans or their favorite programmer's editor. I am still in a 'who moved my cheese phase' rediscovering Eclipse and discovering Android Studio. For know I think Visual Studio is still the better IDE. I am aware that Microsoft 'supports' Java coding with Visual Studio but they enforce an old JDK on you.

If you have questions or remarks please do contact me.
