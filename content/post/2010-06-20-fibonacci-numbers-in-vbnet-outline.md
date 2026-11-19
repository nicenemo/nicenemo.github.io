---
layout: post
title: "Fibonacci numbers in VB.NET an outline"
date: 2010-06-20T01:53:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - VB.NET
aliases:
 - /2010/06/fibonacci-numbers-in-vbnet-outline.html
---

In order to get more familiar with VB.NET I wanted to do some more programming in VB.NET. Nothing serious but a bit more serious than Hello World. I went for implementing the Fibonacci sequence([See Wikipedia](http://en.wikipedia.org/wiki/Fibonacci_number)) in VB.NET. This provides me with a vehicle to test all kinds of .NET/VB.NET plumbing code. An elaborate discussion on implementing the Fibonacci sequence using various languages and techniques can be found on [(Scott Hanselman's blog)](http://www.hanselman.com/blog/TheWeeklySourceCode13FibonacciEdition.aspx). However in this discussion VB is only used marginally. I Want to combine the best solutions offered into one or more VB.NET implementations. The first implementation should have the following characteristics:

* No recursive implementation since this does not scale in vb.net;
* Using IEnumerable(Of Integer);
* Do not care about overflow;

After this basic implementation I can explore .NET and VB.NET in many directions:

* Add caching to normal fib function using 'Memento' pattern;
* Do caching using aspect oriented programming
* Make a suitable Fibonacci function for datalist and paging
* Generalise so that I can do Fibonacci for other types such as byte, ulong and even strings. Here we can also add different "seed" values for the sequence;
* Add exception handling;
* Knowing the range of the type used, one can stop calculating Fibonacci early because an exception will be thrown. We can test this but can also guess it and put limits on it using these guesses;
* Play with lambda functions;
* Play with WPF, e.g. draw a nice shell figure using my fib function;
* Play with WCF, e.g. make a Fibonacci JSON web service. I wonder what to do with the sequence in JavaScript;
* Play with workflow and Fibonacci, this must be something silly. I have no idea how to use Fibonacci in a workflow;
* There is an alternative implementation for calculating the Fibonacci sequence involving mathematical functions such as x^n etc. These will go wrong somewhere. The normal and alternative solution can be run side by side in a unit test. Also this alternative implementation can be used with the IEnumerable by using an Inversion of Control Container such as Castle Windsor(Unity cannot be done on Mono for technical and legal reasons). Mocking can be done using Rhino Mocks. For Unit testing I probably need NUnit. MSTest is not available on the Linux platform.
