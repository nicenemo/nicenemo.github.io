---
layout: post
title: "SDC Conference 2009 Day 1"
date: 2010-06-20T02:22:00-07:00
lastmod: 2016-08-25T23:37:57-07:00
draft: false
aliases:
 - /2010/06/sdc-conference-2009-day-1.html
---

Just a quick note, I am sleepy. I tidy this up later. Today I visited the first day of SDN's SDC conference. I mainly followed the architecture track on this conference.

Keywords:

* (Domain Specific) Languages
* Full Stack code generation
* Separation of Concerns

I followed two presentations by Udi Dahan which were on separation of concerns. He did some interesting trickery with generics to make the Roles a domain object is in explicit. (I need to check this out when I am less sleepy.) He also pointed out that business objects should not have dependencies whatsoever. This allows for reuse all over your stack, makes your stuff less complex. Business Objects are just POCOs. Another presentation by Sander Hoogendoorn did exactly the same as far as the Business Objects are concerned. His focus is on code generation and he uses some interesting tool which I also should check the name for in my notes and figure out.

The Keynote was about the history of programming Languages and how knowledge transfer from academia to business picked up speed from 20 years for O.O. to 2 years for AOP. Also a remark about how every few years someone picks up cool stuff from Lisp and sticks it into Java .NET or whatever and that is then new and Cool. Now we have DSLs, dynamically typed languages. (Ruby,Python JavaScript.)
