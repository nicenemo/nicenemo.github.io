---
layout: post
title: "Alternative Fibonacci implementation"
date: 2010-06-20T02:03:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/alternative-fibonacci-implementation.html
---

On Scott Hanselman's blog there was another formula for Fibonacci that uses the golden ratio and some Mathemagic to calculate Fib(n). This formula is more useful if you want to calculate Fib(n) for a certain n and if you are not interested in the sequence. I used this formula in an alternative implementation of my FibEnumerable just to test for correctness.

```vb
' Fibonacci.vb created with MonoDevelop
' User: kruse at 14:10 22-1-2009
'
' To change standard headers go to Edit->Preferences->Coding->Standard Headers
'

Option Explicit On
Option Strict On

Imports System
Imports System.Collections
Imports System.Collections.Generic

Namespace EUNemopolis.Math
 Public Class FibEnumerable2
 Inherits IntegerEnumerable

  Protected Overrides Function NewEnumerator() as IEnumerator
   return New FibEnumerator()
  End Function

     Private Class FibEnumerator
     Inherits IntegerEnumerable.IntegerEnumerator
   Private const MAXN As Integer =45 'The maximum n for which Fib(n) fits in an integer
   Private _n As Integer

   Private Readonly Shared GoldenRation as Double = _
   (1.0 + System.Math.Sqrt(5.0)) / 2.0

   Public Function MoveNext() As Boolean _
   Implements System.Collections.IEnumerator.MoveNext
       if _n<MAXN then
        _n=_n+1
        if _n<2 then
         SetCurrent(_n)
        else
         Dim newCurrent as Integer
         newCurrent= _
         System.Math.Floor((System.Math.Pow(GoldenRation, _n) - _
         System.Math.Pow((1.0 - GoldenRation), _n)) / _
         System.Math.Sqrt(5.0))
         SetCurrent(newCurrent)
        End If
        Return True
       Else
        Return False
       End If
      End Function

   Protected Overrides Sub Init()
   'illegal value first. Foreach does a movenext
   'first before reading current value
    _n=-1
    SetCurrent(_n)
   End Sub
     End Class
    End Class
End Namespace
```

To see whether this gives the same result as the original implementation I altered my main program. I walk the sequence for n=0 up to and including n=45 for both implementations. I cache the results for the first implementation. In the second foreach loop I print the results for both implementations and the difference between them. If all is correct all differences should be zero. I can use both a list or a simple array for storing the results. I chose an array here just for having used array in VB.Net. I never use arrays in C#.

```vb
' Application.vb created with MonoDevelop
' User: kruse at 9:50 20-1-2009
'
' To change standard headers go to Edit->Preferences->Coding->Standard Headers
'
Imports System.Collections
Imports System.Collections.Generic
Imports EUNemopolis.Math
NameSpace EUNemopolis

Public Class Application
 Public Shared Sub Main()
  System.Console.WriteLine("Hello world!")
     Dim fibseq as IEnumerable(Of Integer)=new FibEnumerable()
     Dim fib as Integer
     Dim cache(45) as Integer
  Dim i as Integer
  i=-1
     for each fib in fibseq
      i=i+1
      cache(i)=fib
     next
     fibseq=new FibEnumerable2()
     i=-1
     for each fib in fibseq
      i=i+1
      cache(i)=fib
      System.Console.Writeline(String.Format("{0:d},{1:d},{2:d},{3:d}",i,fib,cache(i),fib-cache(i)))
     next
 End Sub
End Class
End NameSpace
```

And indeed the algorithm is correct for n=0 up to and including n=45. When you run it you will always see zero as the last value of the print statement.
