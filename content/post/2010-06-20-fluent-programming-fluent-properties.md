---
layout: post
title: "Fluent Programming, Fluent Properties"
date: 2010-06-20T02:19:00-07:00
lastmod: 2016-08-26T00:12:34-07:00
draft: false
tags:
 - vb.net
aliases:
 - /2010/06/fluent-programming-fluent-properties.html
---

Currently Fluent Programming is a hype. You see it in clientside webprogramming, you see it in .NET programmming and I think it is safe to asume it has been, is or will be fashionable in other environments to. You find fluent interfaces within the .NET framework in the LINQ libraries.

The idea of fluent interfaces is that you structure your code in such a way that you can continue chaining methods on a line. In the example below we create a FluentPerson, and like in this sentence which is way to long and uses commas to chain, we continue, by setting the *Age*, the *Name*, let it *Dance* and finally give it a *Rest*.

```vb
New FluentPerson().Age(34).Name("Hans").Dance().Rest()
```

*Example of fluent Programming*

If we observe a typical class like the example Person class below you will notice that the code above cannot work because we have Subs(void methods) that do not return results and property setters that do not return results either.

```vb
Public Class  Person
   Default public Property Name As String
      Get
        return nameField
      End Get
      Set(value as String)
         nameField=value
      End Set
   End Property
   Protected nameField as String

   Public Property Age As Integer
      Get
         return ageField
      end Get
         Set(value as Integer)
         ageField=value
      End Set
   End Property
   Protected ageField as Integer

   Public Sub Dance()
      Console.WriteLine("Salsa!!")
   End Sub

   Public Sub Rest()
      Console.WriteLine("Relax")
   End Sub
End Class
```

*Example Person Class*

To Make this work in VB.NET/C# you have to:

* Change all Subs/void functions and propperty setters into function calls,
* Let these function calls return the current object after they have done their thing.

Changing Subs into functions will not be a problem but not using properties breaks expectations from both fellow programmers and tools. So we are going to keep the properties but add an extra property setter method that just calls the Property Setter and then returns the current object.

In our example code we remove the *Dance* and *Rest* methods from our Person class. We add the following Fluent Subclass:

```vb
Public Class FluentPerson
Inherits Person
   Public function SetName(Byval name as String) as FluentPerson
      nameField=name
      return Me
   End Function

   Public function SetAge(Byval age as Integer) as FluentPerson
      ageField=age
      return Me
   End Function

   Public Function Dance() As FluentPerson
      Console.Writeline("Salsa!!!")
      return Me
   End Function
   Public Function Rest() As FluentPerson
      Console.WriteLine("Relax")
   End Function
End Class
```

Now we are able to make a fluent call like:

```vb
dim fp as FluentPerson =New FluentPerson().setAge(34).setName("Hans").Dance().Rest()
```

Setting the properties here could have been done with the appropriate constructors. We did not include them in the sample code. Property initalizers could not have been used. They are like a normal " With" statement and do not return a result. The solution presented here is more verbose than the original example but we think it is an acceptable compromis.

Fluent programming has two disadvantages:

* A chain of fluent method calls is harder to debug. You can only set one breakpoint
* It is a bit more work for the person making the class

Suggestions for improvement are welcome.
