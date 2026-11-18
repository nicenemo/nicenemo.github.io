---
layout: post
title: "Memento VB.NET"
date: 2010-06-20T02:04:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/memento-vbnet.html
---

In the past blog entries I played with an imperative IEnumerable wrapped implementation of the sequence. The Mathematical definition of the Fibonacci sequence is a recursive one. It is both compact and beautiful. However if you implement this literally in C# or VB.NET you will get a terrible slow program that may even crash due to stack overflow. An imperative implementation that calculates Fib(n) for any random n may be a bit faster but is still slow. The code would be less comprehensible.

It would be great to have a Fibonacci function that caches calculated results and in definition is close to the mathematical definition. Some smart brains generalized the Caching in a so called Memoize or Memento pattern.(Still wondering who invented it first.) The Memento function wraps a normal function and caches it's results. When the function is called again with the same arguments the cached results will be returned.

A very clean C# solution can be found on [Bart de Smet's Blog](http://community.bartdesmet.net/blogs/bart/archive/2008/10/21/memoization-for-dummies.aspx). Here a generic extension method is defined that allows for caching any function with one argument of whatever type. The result can also be of any type. I used his implementation as a basis for my VB exploration of Memoize.

* Lambda functions did not compile on Mono 2.01's VB.NET on Ubuntu jaunty. so I went back to Visual Studio and windows for the moment;\
   Extension methods are declared with an Extension attribute in VB.NET and not with the VB.NET equivalent of the C# this, Me;
* Extension methods can only be defined in Modules in VB.NET not in classes. Why?;
* I knew it but still, the assignment operator in VB.NET does not return a result. The requires an ugly extra function which is not required in C#.

```vb
Option Strict On
Option Explicit On
Imports System
Imports System.Collections.Generic
Imports System.Runtime.CompilerServices

Namespace EUNemopolis
    ' Yuck Extension methods are only valid in Modules in VB.NET
    Module Program
        <Extension()> _
        Public Function Memoize(Of T, R)(ByVal f As Func(Of T, R)) _
        As Func(Of T, R)
            Dim Cache As New Dictionary(Of T, R)
            Return Function(i) _
         (If( _
                Cache.ContainsKey(i), _
                Cache(i), _
                CacheItAndReturn(Cache, i, f(i)) _
            ) _
          )
        End Function
        ' I really hate doing this in VB.NET.
        ' In C# Assignment operator has a result type.
        ' The Add method of a list returns "void"
        ' Sofar the only option I see is creating
        ' a function that adds the value to the cache
        ' and returns the result
        Public Function CacheItAndReturn(Of T, R)( _
        ByVal cache As Dictionary(Of T, R), _
        ByVal i As T, _
        ByVal fresult As R) _
        As R
            cache(i) = fresult
            Return fresult
        End Function

        Public Sub Main()
            System.Console.WriteLine("Hello World")

            Dim Fib As Func(Of Int32, Int32) = Nothing
            Fib = Function(n) (If(n < 2, n, Fib(n - 1) + Fib(n - 2)))
            Fib = Fib.Memoize()

            Dim i As Integer
            For i = 0 To 45
                System.Console.WriteLine(String.Format("{0:d},{1:d}", i, Fib(i)))
            Next
            System.Console.WriteLine("Done")
            System.Console.ReadLine()
        End Sub

    End Module

End Namespace
```

First I define the Memoize function. It is pretty Close to the C# version. I use the VB.NET 2008 Ternary If() operator. This does short circuit evaluation. which the old IIF() function does not. in the false clause I unfortunately need to call the extra function mentioned before. If anyone knows a better solution in VB.NET for this please let me know. After that I define the Fib function in the Main method. I do this again using the ternary If() operator. As promised it is really close to the mathematical definition. Finally I call the Memoize extension method. And yes Memoize is really measurable.

Even after having implemented the VB.NET version and reading Bart de Smet's explanation I did not understand why this should work. After reading it three times I understood. Maybe this helps if you are as puzzled as I was:

* The Memoize function declares and initializes a dictionary;
* The Memoize function returns a function object that refers to that dictionary;
* Since there is a reference to the dictionary in the function object the dictionary will not be garbage collected after the call to Memoize returns;
* Every call to a Memoize object will use the same dictionary instance.
