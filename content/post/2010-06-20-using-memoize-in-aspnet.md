---
layout: post
title: "Using Memoize in ASP.NET"
date: 2010-06-20T02:11:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - VB.NET
 - ASP.NET
aliases:
 - /2010/06/using-memoize-in-aspnet.html
---

I spent quite some time blogging about memoize. Until now I did not have a good solution for Memoize in VB.NET because VB.NET's lambda function is limited to a single expression and VB.NET has no anonymous delegates.

I first made a Memoize that used a Dictionary. Based on this implementation I made one that wraps the ASP.NET Cache. Certainly some generalisation is possible. I wrote a base class that abstracted away the concrete implementation of the cache using three functions:

* ContainsKey(k)
* GetCachedValue(k)
* Add(k,v)

With an abstract Memoize class I made a Dictionary Memoize and WeBCache Memoize that shared the core memoize functionality.

With the abstract implementation I got the feeling that a clean Memoize implementation was possible in VB.NET. In my first implementations I used a private member to hold the memoized function. This has the bad side effect that a Memoizer instance can only be used to Memoize one function.

However this private member is not required. Using the functions mentioned above Memoize can be implemented in VB.NET with an if() expression in a lambda expression as follows:

```vb
return function(fn)(if(ContainsKey(k),GetCachedValue(k),Add(k,fn(k)))
```

The if() expression in vb is the same as boolexpr?trueResult:falseResult; in C#. Note that the Add(k,f(k)) returns the result of calling f(k). Add is not a subroutine (void method in C#). This makes it possible to use an if expression. An if() expression is a single expression so it can be used as lambda expression in vb.net.

The sketched solution has one little problem...

The current solution cannot be used with multiple functions yet. By using the if() expression we eliminated the function member. However, we want/must use one cache object to cache function results. With the current solution trying to use multiple functions, e.g. sqrt(x) and sin(x), on the same memoizer would result in giving back wrong results since the cache is not aware of the function to cache results from. Fixing this is easy. Our 3 Cache functions get an extra function parameter:

* ContainsKey(fn,k)
* GetCachedValue(fn,k)
* Add(fn,k,v)

Here fn is a reference to the function being memoized. Implementations can use it to distinguish between multiple functions on the same cache, e.g. on an implementation that uses strings as key the key for the cache would be the full function name concatenated with the argument.

Of course our lambda expression has to be changed to the new situation too.

```vb
return function(fn)(if(ContainsKey(fn,k),GetCachedValue(fn,k),Add(fn,k,f(k)))
```

### Disclaimer

The above is a rough sketch. I have an implementation with concrete implementations of the base class that compiles but is not yet tested. However since this builds on earlier specialised implementations I have confidence that I can iron out the bugs.
