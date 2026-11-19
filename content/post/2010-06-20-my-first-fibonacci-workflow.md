---
layout: post
title: "My First Fibonacci workflow"
date: 2010-06-20T01:57:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - VB.NET
aliases:
 - /2010/06/my-first-fibonacci-workflow.html
---

When supporting a business with software one often draws diagrams of the so-called business processes. These diagrams describe the flow, the work flow, of the business process. Since .NET 3.0 there is built-in support for work flows which is augmented with a nice Visual Designer in Visual Studio 2008. With this Designer one designs the workflows graphically. These designs can be used as a means of communication to the customer and between programmer and business analyst.

This is something I wanted to try with my Fibonacci Generator. So I started Visual Studio and used a VB.NET Console application template with workflow support. That gave me an almost empty canvas that asked me to drag a so called workflow activity on it. In the toolbox there are many different activities/workflow constructs such as While, If/Then, Webservice, Code, Parallelisation and many more.

### My First Workflow

My First workflow will be simple:

* It contains a *code* activity that prints the next Fibonacci number to the Console and move to the next Fibonacci Number;
* I use a Workflow *while* construct to stay below 45, since the 44th Fibonacci number is the largest that fits in an Integer;
* Use a *Sleep* activity that sleeps for 15 seconds so that we can see the result in the console

Graphically this is shown in Visual Studio as follows: (The screenshot of the workflow in the Visual Studio designer was hosted on Blogger and is no longer available.)

This is a very simple sequential workflow with conditional iteration. In the code behind the conditions and the part for the code blob are programmed. Actually this should only refer to code defined elsewhere and not be used for your actual programming.

```vb
Namespace EUNemopolis
    Public Class FibWorkflow
        Inherits SequentialWorkflowActivity
        Private MyFibEnumerator As IEnumerator(Of Integer)
        Private MyCounter As Integer

        Public Sub New()

            ' This call is required by the Windows Form Designer.
            InitializeComponent()

            MyFibEnumerator = New FibEnumerable().GetEnumerator()
            MyCounter = 0
        End Sub
        Public ReadOnly Property CurrentFib()
            Get
                Return MyFibEnumerator.Current
            End Get
        End Property
        Private Sub NextFib(ByVal sender As System.Object, ByVal e As System.EventArgs)
            Console.WriteLine(String.Format("{0:d},{1:d}", MyCounter, MyFibEnumerator.Current))
            MyFibEnumerator.MoveNext()
            MyCounter = MyCounter + 1
        End Sub

        Private Sub FitsInType(ByVal sender As System.Object, ByVal e As System.Workflow.Activities.ConditionalEventArgs)
            e.Result = (MyCounter < 45)
        End Sub

    End Class
End Namespace
```

Besides the code I have written, which is shown above, the template generator generates some initialisation code. The Designer also generates supporting initialisation code when dragging and dropping activities to the workflow canvas.

Of course this example is far from some actual business case. However, it gives the opportunity to make oneself familiar with the basics of Work flows in .NET 3.0 and 3.5 without the hassle of having to configure web services or building some GUI application that fires events that are consumed by the work flow. I am particularly interested in combining work flow with email since many business processes involve sending notification E-Mail messages to people. The default set of activities in the toolbox does not contain support for E-Mail. I have to look online for an E-Mail component or make one myself. More on that in a later blog post.
