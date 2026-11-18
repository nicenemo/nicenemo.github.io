---
layout: post
title: "Basic Fibonacci"
date: 2010-06-20T01:55:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/basic-fibonacci.html
---

When I planned to do the Fibonacci sequence I wanted to do an IEnumerable(Of Integer) implementation first using the 'yield' keyword. Well that doesn't work in VB.NET because 'yield' is something specific for C#. I had to implement a full IEnumerable and IEnumerator ;(. I started using a Console Project in Monodevelop. I wrote a main program that will print the Fibonacci sequence from 0 to 44(maximum possible with integer).

```vb
' Application.vb created with MonoDevelop
' User: kruse at 9:50 20-1-2009
'
' To change standard headers go to Edit->Preferences->Coding->Standard Headers
'
Imports System.Collections
Imports System.Collections.Generic
NameSpace EUNemopolis

Public Class Application
 Public Shared Sub Main()
  System.Console.WriteLine("Hello world!")
     Dim fibseq as FibEnumerable=new FibEnumerable()
     Dim fibenumerator as IEnumerator(Of Integer)= fibseq.GetEnumerator()
     Dim fib as Integer
  Dim i as Integer
     for i=0 to 44
      fib= fibenumerator.Current
      System.Console.Writeline(String.Format("{0:d},{1:d}",i,fib))
      fibenumerator.MoveNext
     next
 End Sub
End Class
End NameSpace
```

Writing this program I already discovered that MonoDevelop is still missing intellisense and autocomplete. That would have been a real time saver. Also the mono compiler gave some cryptic errors on not having both System.Collections and System.Collections.Generic as imports. With some googling in MSDN on IEnumerable and IEnumerator I managed to complete an implementation. My implementation consists of class that implements IEnumerable(Of Integer). This class contains a private inner class that implements IEnumerator(Of Integer) this class does the actual Fibonacci calculation. On the outside this enumerator is not visible.

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

Namespace EUNemopolis
 Public Class FibEnumerable
 Implements IEnumerable(Of Integer)
      Public Sub New()
    MyBase.New()
   End Sub
  Public Function GetEnumerator() As IEnumerator(Of Integer) _
  Implements IEnumerable(Of Integer).GetEnumerator
      Return New FibEnumerator()
  End Function
  Private Function GetEnumerator1() As IEnumerator _
  Implements IEnumerable.GetEnumerator
      Return GetEnumerator()
  End Function
     Private Class FibEnumerator
     Implements IEnumerator(Of Integer)
   Private _n As Integer
   Private _current As Integer
   Private _previous As Integer
      Public Sub New()
    MyBase.New()
     Init()
    End Sub

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
   Public Function MoveNext() As Boolean _
   Implements System.Collections.IEnumerator.MoveNext
       _n=_n+1
       If _n<=2 Then
        _previous=_current
        _current=_n
       Else
        Dim newCurrent as Integer
        newCurrent=_previous+_current
        _previous=_current
        _current=newCurrent
       End If
       Return True
      End Function
 Public Sub Reset() _
      Implements System.Collections.IEnumerator.Reset
       Init()
   End Sub
 Private Sub init()
    _n=0
    _current=0
    _previous=0

   End Sub
 Public Sub Dispose() _
   Implements IDisposable.Dispose
   ' Empty implementation
   End Sub
 End Class
 End Class
End Namespace
```

For those interested I use [Karekol](http://sourceforge.net/projects/karekol/) for vb.net sourcecode to html conversion. This concludes my first implementation of the Fibonacci sequence in VB.NET. Later I will continue with one of the items mentioned in the previous blogpost.
