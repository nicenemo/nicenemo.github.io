---
layout: post
title: "Memento in Second Life"
date: 2010-06-20T02:06:00-07:00
lastmod: 2016-08-25T23:37:43-07:00
draft: false
tags:
 - secondlife
 - lsl
aliases:
 - /2010/06/memento-in-second-life.html
---

After grasping the power of Memoize in VB.NET and C# tried my luck at making a memoizing fibonacci generator in Second Life's scripting Language LSL. [Second Life](http://secondlife.com/) is 3d virtual world where end users can create there own world using basic building blocks. They can script their creation with a scripting language called LSL. This languages get's compiled to Mono's runtime.

LSL is somewhat limited. It does not allow for closures or lambda functions. It also has a very limited set of datatypes. It does not have arrays. It has immutable lists. A list in LSL can contain elements of string, integer and other types but not lists themselves. For Fibonacci a list with only integers will do.

I defined fib(n) first using it's recursive definition to get the LSL right. Of course this doesn 't perform at all. After that I looked into memoizing. I noticed that inserting integers in a list is an expensive operation in LSL. However the nature of the Fibonacci algorithm makes this not necessary. The cache will always be filled in order from n=0 up to the requested number. I preseeded the list with [0,1,1] which eliminates one if clause. after that the fib function is recursively called and the results are added to the cache. Below is the final code

```
list cache=[0,1,1];
integer  fib(integer n)
{
    integer result;

    if (n<llGetListLength(cache))
    {
        result= llList2Integer(cache, n);
    }
    else
    {
        result=fib(n-1)+fib(n-2);
        cache=(cache=[])+cache+result;
    }
    return result;
}
default
{

    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        integer i;
        for(i=0;i<
```

<!-- The Blogger export of this post was already cut off at this point; the rest of the listing is lost. -->
