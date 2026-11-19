---
layout: post
title: "Back To Basics"
date: 2010-06-20T01:51:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/back-to-basics.html
---

Halfway through January I quit my current job. And after a short vacation I will start with my new job which is on cycling distance from my home ;). In my new job I will return to my programming roots: Basic. In high school I started programming on the Commodore 64 in Microsoft Basic 2.0. My first serious program was a vocabulary trainer that aided me in learning natural languages. I was not a star in French or German in high school. At my new job software development is done in Visual Basic 2008 (.NET). As a C# developer that cannot be too much of a problem. Since I do not want to look like an absolute beginner. I did buy a book and began to jot down the differences and check some assumptions. For fun I do my explorations not by using Visual Studio but by using MonoDevelop and the Mono 2.01 framework on Linux. First of all, does Goto still exist? Yes it does. However line numbers do not exist as with the original BASIC dialects. Instead of that there are labels. Some children, of course not me ;) , would consider it fun to run silly programs on the demo computers shown in the local department store (V&D) who had some C64/MSX and the like on display in the 1980s. The most popular was something like shown below:

```vb
Module Application
Public Shared Sub Main()
10: System.Console.WriteLine("Hello Hans Was Here!")
20: goto 10
End Sub
End Module
```

A sort of digital vandalism.

Ah, pity, Microsoft took Volta offline otherwise I would have shown a translated JavaScript version here. As far as I could discover, labels are local in scope. Jumping from one method to another is not possible. Trying this gave me an internal compiler error on Mono. After some shallow reading I concluded that Visual Basic provides you with enough rope to hang yourself. However you can program it as cleanly as C# or any other .NET framework languages. It differs mainly in syntax from C#. Besides obvious syntax differences I noticed the following differences:

* Legacy support for VB6;
* Casting is different. There are special type cast methods;
* Variable number of arguments in methods. This will be present in C# too for .NET 4.0;
* Better syntactical support for events and delegates. I need to reread this;
* Concept of modules. These provide a sort of container for global methods/variables.
* No yield keyword. This means you have to implement IEnumerable and IEnumerator yourself

Somehow I do not like modules. Modules are a bit like static classes but then without inheritance and when imported you do not have to provide the namespace name. I think I would rather not use them, because like static methods on classes, it makes your code explicitly dependent on the module implementation. I would prefer to add a property on my classes which accept an object which implements a certain interface. This would allow me to vary implementation and make unit testing possible without compiling all my code. As far as I know you can only do this with a separate testing implementation of the module for which the classes to be tested need to be recompiled.

As a preliminary conclusion I think VB .NET feels more verbose than C# whether that is a good or bad thing I am not certain about. I come back to that in later posts.
