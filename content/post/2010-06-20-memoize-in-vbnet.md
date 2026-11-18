---
layout: post
title: "Memento without lambdas"
date: 2010-06-20T02:08:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/memoize-in-vbnet.html
---

I am pleased with the idea of a generalised Memoize Function. However my current implementation works from .NET 3.0 upwards because Lambda expressions are available from version 3.0. In .NET 2.0 there are no Lambda expressions. In C# lambda functions can be easily replaced with anonymous delegate implementations. In VB.NET there is no such thing as anonymous delegate implementations. That does not mean we cannot do implement Memoize in VB.NET. We have to simulate what the compiler does when compiling lambda functions with closure. We Make a class that has three things:

* A Dictionary to serve as cache
* A member to store a reference to the original Function
* The Caching functionality
* A function that gives a Caching function given a function as argument

In our original main program we also used a lambda function to define Fibonacci recursively in terms of itself. We need to convert that to a normal function. However we cannot let that function call itself because then there would be no way to insert the caching functionality. We do the following:

* We define a "Function Pointer" Fib as Func(Of Integer,Integer);
* We define a new Function RFib that call the Fib "function pointer" in case n>=2;
* We set Fib to the Adress of RFib;
* We instantiate a Memoizer m;
* We reassign Fib as Fib=m.Memoize(Fib).

This allowed me to create a working memoized Fibonacci generator for a 2.0ish VB. Actually I tried this on Mono 2.01. Unfortunately Mono somehow did not like a generalized Memoize. A Generalized version probably will work on Microsoft.NET. We use the Func(Of integer,integer) generic type. If that is not present in your version of .NET or Mono then it can be replaced with a custom delegate doing the same thing.

### Source using Generic Function Pointer

```vb
Option Strict On
Option Explicit On
Imports System
Imports System.Collections.Generic
Imports System.Runtime.CompilerServices

Namespace EUNemopolis

  Public Class Memoizer
   Private cache as IDictionary(Of Integer,Integer)
   Private _f as Func(Of Integer,Integer)
   Public Sub New()
    MyBase.New()
     cache=new Dictionary(Of Integer,Integer)()
   End Sub
 Public Function M(i as Integer) as Integer
      Dim result as Integer
      If cache.Containskey(i)then
       result=Cache(i)
      Else
       result=_f(i)
       cache(i)=result
      End If
    return result

   End Function
 Public Function Memoize(f as Func(Of integer,integer)) _
      as Func(Of integer,integer)
        _f=f
        Return new Func(Of Integer,Integer) (AddressOf M)
     End Function
 End Class
 Module Program
   Public Fib As Func(Of Int32,Int32)
         Public Function RFib(n as Int32) as int32
         Dim result as Integer
         If(n<2) then
          result=n
         Else
          result=Fib(n-1)+Fib(n-2)
         End If
         return result
        End Function
 Public Sub Main()
            System.Console.WriteLine("Hello World")
            Fib = new Func(Of Integer,Integer)(AddressOf rfib)
            Dim m as New Memoizer()
      Fib=m.Memoize(Fib)

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

### Source using custom delegate

```vb
Option Strict On
Option Explicit On
Imports System
Imports System.Collections.Generic
Imports System.Runtime.CompilerServices

Namespace EUNemopolis
  Public Delegate Function FPointer(i as Integer) As Integer
  Public Class Memoizer
   Private cache as IDictionary(Of Integer,Integer)
   Private _f as FPointer
   Public Sub New()
    MyBase.New()
     cache=new Dictionary(Of Integer,Integer)()
   End Sub
 Public Function M(i as Integer) as Integer
      Dim result as Integer
      If cache.Containskey(i)then
       result=Cache(i)
      Else
       result=_f(i)
       cache(i)=result
      End If
    return result

   End Function
 Public Function Memoize(f as FPointer) _
      as FPointer
        _f=f
        Return new FPointer (AddressOf M)
     End Function
 End Class
 Module Program
   Public Fib As FPointer
         Public Function RFib(n as Int32) as int32
         Dim result as Integer
         If(n<2) then
          result=n
         Else
          result=Fib(n-1)+Fib(n-2)
         End If
         return result
        End Function
 Public Sub Main()
            System.Console.WriteLine("Hello World")
            Fib = new FPointer(AddressOf rfib)
            Dim m as New Memoizer()
      Fib=m.Memoize(Fib)

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

### Memoize in C# using anonymous delegates

```csharp
// Main.cs created with MonoDevelop
// User: kruse at 15:18 26-1-2009
//
// To change standard headers go to Edit->Preferences->Coding->Standard Headers
//
using System;
using System.Collections;
using System.Collections.Generic;
namespace MemoizeFibCSharp
{
 public class Memoizer
 {
  public static  Func<T,R> Memoize<T,R>(Func<T, R> func)
  {
   Dictionary<T, R> cache = new Dictionary<T, R>();
   return delegate(T key)
   {
    R result;
    if (cache.TryGetValue(key, out result))
     return result;
    cache[key] = result = func(key);
    return result;
   };
  }
 }

 class MainClass
 {

  public static void Main(string[] args)
  {
   Console.WriteLine("Hello World!");
   Func<Int32, Int32> fib = null;
   fib = delegate(int n){ return n > 1 ? fib(n - 1) + fib(n - 2) : n;};
   fib = Memoizer.Memoize<Int32,Int32>(fib);

   for(int i=0;i<46;i++)
   {
    Console.WriteLine(String.Format("{0:d},{1:d}",i,fib(i)));
   }

  }
 }
}
```
