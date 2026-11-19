---
layout: post
title: "Refactoring Fibonacci code"
date: 2010-06-20T02:01:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/refactoring-fibonacci-code.html
---

I planned to experiment with Inversion of Control, unit tests and a Mockup Framework under VB.NET using Mono. For this I planned to use the Fibonacci example discussed earlier. However in its present form it is not pleasant to use, reusable or extendible. I want the following:

* Move the Fibonacci code in a separate library project. This will allow me to reuse the code more easily;
* Use a check in the MoveNext Code on n&lt;45. This allows me to use *For Each* in the mainloop and I do not need to explicitly use an Enumerator. This is more the way I am used to program in C#. I suppose this is also common practice in VB.NET. Note that this will be slower;
* Make an Abstract IntegerEnumerable base class that also contains an Abstract enumerator. This allows me to have the plumbing code in one place and let me concentrate on variations for the MoveNext function;
* Make a prime number finder as a variation;

When that is done I can do some performance analysis code. I am curious about the impact of checking on '45' in the MoveNext(). Also I am interested in some variations of the MoveNext Method. First of all, I developed the abstract integerenumerable:

```vb
' IntegerEnumerable.vb created with MonoDevelop
' User: kruse at 12:36 25-1-2009
'
' To change standard headers go to Edit->Preferences->Coding->Standard Headers
'

Option Explicit On
Option Strict On

Imports System
Imports System.Collections
Imports System.Collections.Generic

Namespace EUNemopolis.Math
 Public MustInherit Class IntegerEnumerable
 Implements IEnumerable(Of Integer)
      Public Sub New()
    MyBase.New()
   End Sub

  Public Function GetEnumerator() As IEnumerator(Of Integer) _
  Implements IEnumerable(Of Integer).GetEnumerator
      Return NewEnumerator()
  End Function

  Private Function GetEnumerator1() As IEnumerator _
  Implements IEnumerable.GetEnumerator
      Return GetEnumerator()
  End Function

  Protected MustOverride Function NewEnumerator() As IEnumerator

  Protected  Class IntegerEnumerator
  Implements IEnumerator(Of Integer)
  Private _current as Integer

   Public ReadOnly Property Current() As integer _
   Implements IEnumerator(Of Integer).Current
        Get
         Return _current
        End Get
   End Property
   Private  ReadOnly Property Current1() As Object  _
   Implements IEnumerator.Current
       Get
           Return Me.Current
       End Get
   End Property
      Protected Sub SetCurrent(current as Integer)
       _current=current
      End Sub

      Public Sub New()
    MyBase.New()
    Init()
   End Sub

      Public Overridable Function MoveNext() As Boolean _
   Implements System.Collections.IEnumerator.MoveNext
    return False
   End Function
   Public Overridable Sub Init()
   End Sub

   Public Sub Reset() _
      Implements System.Collections.IEnumerator.Reset
       Init()
   End Sub

   Public Sub Dispose() _
   Implements IDisposable.Dispose
   ' Empty implementation
   End Sub
  End Class
    End Class
End Namespace
```

Using this code as a base implementing all kinds of mathematical sequences becomes nothing more than implementing the Init() and MoveNext() method.

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
 Public Class FibEnumerable
 Inherits IntegerEnumerable

  Protected Overrides Function NewEnumerator() as IEnumerator
   return New FibEnumerator()
  End Function

     Private Class FibEnumerator
     Inherits IntegerEnumerable.IntegerEnumerator
   Private const MAXN As Integer =45 'The maximum n for which Fib(n) fits in an integer
   Private _n As Integer
   Private _previous As Integer

   Public Function MoveNext() As Boolean _
   Implements System.Collections.IEnumerator.MoveNext
       if _n<MAXN then
        _n=_n+1
        If _n<2 Then
         _previous=Current
         SetCurrent(_n)
        Else
         Dim newCurrent as Integer
         newCurrent=_previous+Current
         _previous=Current
         SetCurrent(newCurrent)
        End If
        Return True
       Else
        Return False
       End If
      End Function

   Private Overrides Sub Init()
    _n=-1 'illegal value first. Foreach does a movenext first before reading current value
    SetCurrent(_n)
    _previous=_n
   End Sub
     End Class
    End Class
End Namespace
```

When developing the code above I discovered that MonoDevelop (2.01) did not have an integrated debugger on my system. I am pretty sure that there is a Mono debugger. I also read on the Mono website that there was a 2.2 release of Mono with a lot of compiler improvements. So before I continue coding, I had better first invest some time in updating my development environment. Another thing I noticed is that one easily gets it wrong. Initially the sequence generated was off by one missing the value for n=0. This was because my init() method was never called until I added the forgotten *Overrides* tag to it. I also got the enumerator wrong. The Current value of an Enumerator is initially undefined. After the first time calling MoveNext() it will have a defined value if the MoveNext() has returned true.
