---
layout: post
title: "Vanilla Java for stream copy"
date: 2018-09-04T08:25:14+02:00
draft: false
tags:
 - Java
 - programming
---

In the JavaScript community, not long ago, there was a discussion about using a library versus rolling your own implementation to achieve certain goals. Since there seems to be a new hot and happy JavaScript framework every two months or so, rolling your own may be attractive to some people. It even has a name *Vanilla JavaScript*. Someone even proposed   *[Vanilla-JS](http://vanilla-js.com/) framework* framework... ;). But how is that for Java? Java used to be slower paced but even here we have the problem of overchoice. For a simple problem you often have the following options:

1. Program it yourself inline where you need it.
2. Program it yourself and place it in your growing `Util` class.
3. *Stack Overflow* it and adapt to your needs, with proper credits/licensing.
4. Pick a third party library out of 3 more options

In the next few paragraphs I will explore the costs and benefits of using Vanilla Java vs using library using an example.

Let's imagine you are developing using Java 8 and you need to copy the contents of  `java.io.InputStream` to a `java.io.OutputStream`. In Java 9 you could use the new `transferTo` method as easy as:

```Java
  try (InputStream is = new FileInputStream(fileName);
       OutputStream os = new FileOutputStream(fileName + ".copy")){
    is.transferTo(os);
    }catch(final IOException exception){
      out.println("Exception encountered: " + exception);
  }
```

*Source: [DZone](https://dzone.com/articles/transferring-inputstream-to-outputstream-in-jdk-9)*

However `transferTo` is not present for Java 8 and below.
In the context where I needed to copy stream contents the final target is a byte array. So that is what I explored first. I also realised that I already was using a library in another project to copy streams, not byte arrays, so it would be interesting to explore real stream copying.

## Program it yourself

My first thought then was not to copy streams at all but copy the `InputStream` into a `byte[]`.
In order to do this myself I would probably:

1. Read the stream in chunks into a `List<byte[]>`
2. Keep track of the number of bytes read in the last chunk
3. Calculate the the number of bytes need for the final target array taking into account that the last chunk probably needs less.
4. Copy the the chunk's content into the target byte array taking into account that the last chunk may need less bytes.

You can do this by using a simple for loop. You may also be able to use the `java.util.stream.Collector`. However with use of a collector correcting for the last chunk may be challenging and not worth it.

Since we are inlining you have the option to convert the chunks or the final result into something completely different straight away. This may be more *optimal* ;). Of course this *optimal* code needs special unit tests.

After reading some Stack Overflow samples and library source code I think I will change my answer when asked again. I would use a [ByteBuffer](https://docs.oracle.com/javase/8/docs/api/java/nio/Buffer.html) instead of a plain `byte[]`.

## Program it yourself and place it in your Util class

When you add the initial generic solution sketched in  the previous paragraph to your `Util` class you only have to write unit tests for copying streams once. Whether you copy that `Util` class around or make it into a nice reproducible jar is up to you.

In case of the stream copy example I would prefer the following test cases:

1. Tests with null input and output
2. Tests with empty input
3. Tests with input and output that throw an `IOException`
4. Tests with in-memory streams.
5. Tests with file streams since memory streams are just arrays with sugar coating.
6. Tests with a stream that is non-seekable and can only read chunks or bytes going forward and cannot be reset.

## Stack Overflow it

Lots of programming problems are answered kindly on Stack Overflow. However those answers come with a catch.
All answers on Stack Overflow are licensed under [Creative Commons Attribution-Share Alike. Proper attribution is required](https://stackoverflow.com/help/licensing).

However when is a solution considered copied or just trivial code invented at more places at the same time?

With just copying you have to consider that:

* You do not fully understand it.
* You have no idea about corner cases.
* You have no ideas whether an answer selected best answer is still the best answer.
  In case of the copying Streams the best answer for Java 8 is different than that for Java 9.
* Code samples often lack some input checks for brevity
* Code samples in general do not come with unit tests

See:
<https://stackoverflow.com/questions/40743724/fastest-way-to-copy-a-file-over-socket?rq=1>

## Libraries

When looking through libraries two commonly used libraries that offer stream copy are
[Apache Commons IO](https://commons.apache.org/proper/commons-io/) and [Google Guava](https://github.com/google/guava/wiki) There are a few others less commonly used ones that are implemented like *Commons IO* or *Guava*.

When I compare *Commons IO* with *Guava* I found one interesting difference. Commons IO does not use a `ByteBuffer` while *Guava* does. Why? Maybe *Apache Commons IO* does not use `ByteBuffer` because of backwards compatibility with *JDK 6* and below?

Another interesting thing I learned from reading the sources  was, that *Guava* did something different for different kinds of streams. This is not something you come up with yourself unless  stream copying is your core business.

## Vanilla Java or not?

In the past, and still for demos, I would not think twice and glue a solution together out of libraries. This Frankenstein solution of course contains a lot of unused code. It takes ages to download all dependencies with a clean maven cache. If you use the shade plugin to create just one jar without dependencies it would be huge.

> I experienced long deployment times with Node.js and Azure Functions because of a lot of dependencies. I do not want that for my code, not in Node.js, not in Java or whatever.

Nowadays I think twice before I take a dependency on a library or tool. Is it really worth it?

What would I do when I need stream copy?

I would:

* Use a library if I could use more functionality from that library and it was allowed to use that library.
* Roll my own using `ByteBuffer`. Taking lessons learned from Stack Overflow into account.
* Copy relevant parts from *Guava* or *Commons IO* if allowed with respect to licensing.

Sadly Java does not have a linker that only copies in relevant parts of a library.
Using [ProGuard](https://en.wikipedia.org/wiki/ProGuard_(software)) you can do something like that, but it will not work with all code. Especially it does not work with signed code and code that uses a lot of reflection.

Regarding stream copy, I wrote an implementation based on the Javadocs that I integrated in [Noaber](https://github.com/nicenemo/jnoaber), my personal experimental toolbelt Java Library.
