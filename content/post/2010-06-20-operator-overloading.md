---
layout: post
title: "Operator overloading"
date: 2010-06-20T02:17:00-07:00
lastmod: 2018-08-17T03:31:19-07:00
draft: false
tags:
 - VB.NET
aliases:
 - /2010/06/operator-overloading.html
---

Although I have been doing .NET since December 1999 I never followed a formal course or did take an exam. With my new employer I am going to be certified. For this I have to pass some basic exams first. These are not difficult but still require some study.

When reading chapter one of the course book I noticed something called widening and narrowing operator overloading. These two overloads allow you to create some custom type instance by assigning a simple type. This caught my attention because we use some custom types which are just some Guids wrapped in a type. The wrapping is done to distinguish their use.

I wrote a little test to check it myself:

```vb
Option Strict On
Option Explicit On

Public Class PonyTailGuid
    Public V As Guid
    Public Sub New()
        V = Guid.Empty
    End Sub
    Public Sub New(ByVal g As Guid)
        V = g
    End Sub
    Public Shared Widening Operator CType(ByVal arg As Guid) As PonyTailGuid
        Return New PonyTailGuid(arg)
    End Operator
    Public Shared Narrowing Operator CType(ByVal arg As PonyTailGuid) As Guid
        Return arg.V
    End Operator
End Class

Public Class BaldGuid
    Public V As Guid
    Public Sub New()
        V = Guid.Empty
    End Sub
    Public Sub New(ByVal g As Guid)
        V = g
    End Sub
    Public Shared Widening Operator CType(ByVal arg As Guid) As BaldGuid
        Return New BaldGuid(arg)
    End Operator
    Public Shared Narrowing Operator CType(ByVal arg As BaldGuid) As Guid
        Return arg.V
    End Operator

End Class

Module Module1

    Sub Main()
        Dim g As Guid = Guid.NewGuid
        Dim bg As BaldGuid = g
        Dim pg As PonyTailGuid = g
        Dim g2 As Guid = CType(bg, Guid)
        Dim g3 As Guid = CType(pg, Guid)

    End Sub

End Module
```

A more didactical example would be something that converts integers to a Masstype with a kilo field augmented with some non metrical mass type classes. But it is Sunday evening and there are some more urgent things to do.
