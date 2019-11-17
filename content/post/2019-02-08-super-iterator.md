---
layout: post
title: "The super lazy iterator in C# and Java"
date: 2019-02-08T08:56:38+01:00
draft: true
---
A *super lazy iterator* is known by functional programmers as the [List Monad](https://www.schoolofhaskell.com/school/starting-with-haskell/basics-of-haskell/13-the-list-monad).  This is not another Monad tutorial but focusses on what was added to C# and Java to allow retrofitting this *super lazy iterator* to C# and Java.

With this *super* iterator you can:

* Iterate over a collection skipping elements by predicate. *where clause* or *filter*.
* Project the elements in a collection into something different *select clause*, *project* or *map*. This is done using a function reference or lambda expression.
* Flatten a collection of collections of items into a collection of items *select many* or *flatmap*.
* Aggregate, reduce or collect a collection items into a single value

Except for aggregation, the operation of this *super iterator* are lazy and chainable. Only when you aggregate or transform the iterator in a collection again, the *filter*, *map* and *flatmap* operations are executed for real.

The benefit of this iterator is that provides a set of useful composable operations with a mathematical foundation. You can proof that your code is correct (as long as it is side effect free). The code is usually more succinct and readable than more traditional imperative code. However I can imagine that it may take some time to getting used to reading it.

Debugging this kind of code is a bit harder but hardly necessary. You debug the parts, not the composition.

The *super lazy iterator* was retrofitted to .NET in 2007, version 3.5 as Language Integrated query, [LINQ](https://en.wikipedia.org/wiki/Language_Integrated_Query). Both a library and extended syntax in C# and and VB.NET were added. Existing collection APIs can be used with LINQ. To be more acceptable a syntax with SQL like keywords was used. LINQ is build on top of Lambda expressions and [Extension methods](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods) that were added in .NET 3.0. The `Enumaration` extension class provides enables the use of LINQ with the existing .NET collection classes. Extension methods allow you to define methods in a separate class and use them as if they were part of an existing class or interface. This will also work with `sealed` classes.

The *super lazy iterator* was introduced to Java in 2014 with Java 8. In Java 8 you can find it in the `java.util.streams.*` API.  This has no relation to IO streams. Also in Java support for Lambda expressions was added to support the new `streams` API. The Java collections interfaces were retrofitted with an additional `.stream()` method. Adding extra methods to existing interfaces would break your code. This is because you do not have implementations for these new methods. This problem was tackled by addding the new language feature, [default method](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html). This allows you to provide a default implementation for those newly added methods within the interface.

In Java there is no further sytactical sugar to support the *super iterator*. Special Stream classes exists for Java primitives. In .NET additional support for meta programming in LINQ using expression trees is available. In VB.NET special LINQ support for XML files is added at the language level. The *foreach* statement in C# and VB.NET act different when using LINQ. With LINQ you can do list comprehension using the language support. This gets translated into *flatmap* calls.

Extension methods in .NET and default interface implementations in Java are used for refactoring code by providing tested utility methods within existing code bases.
I used both for writing utility libraries. In Java well known libraries that use default methods are [Mockito](https://site.mockito.org/) and [QuickTheories](https://github.com/quicktheories/QuickTheories). Besides my own code I have not used third party .NET libraries that provide functionality in the form of extension methods.

I am a LINQ and streams fan and also like extension methods and default methods What do you think about Java Streams or LINQ? How are you using it? What about extension methods and default methods?
