---
layout: post
title: "Default method implementations with Java 8 interfaces"
date: 2017-01-12T09:17:00-08:00
lastmod: 2018-08-17T03:31:58-07:00
draft: false
aliases:
 - /2017/01/default-method-implementations-with.html
---

Java 8 allows you to add so called ["default" method implementations to interfaces](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html). The intended use was being able to extend an existing interface without breaking existing code. A new function is added with a default implementation. Existing code does not have to change because of the default implementation.

A possible reason to add this to the language may be a side effect of adding support for functional programming with lambda support and "streams". By calling *stream()* on a collection you get an *Iterable* like structure with methods like *filter()*, *map()* and *flatMap().* These methods accept a lambda expression as argument. The *stream()* method is implemented as a so called default method on the *Collection* interface. A possible reason to not add *filter(), map()* and *flatMap()* directly to *Collection* may be the fact that all methods on an interface are public. You have no way of hiding an implementation detail in private methods. This will change in Java 9.

Note for .NET programmers, Java 8 Stream functionality has nothing to do with IO streams but are the Java way of LINQ. Sadly there is no syntactic sugar in the language to support this.

### Other uses of default methods

What else could you do with default method implementations on interfaces?

One thing you could do is defining interfaces where all methods have default methods.

These "interfaces" can then be used to mix in functionality in implementation classes instead of using delegation. This has the disadvantage of exposing implementation details to the external interface of the class. This should not be a problem since you already hide the class by using an interface and a factory for the functionality you want to expose. Or did you not?

Edit: Scala people may know this as the Cake Pattern.

### Introducing Noaber

To test this idea I wrote a sample library [Noaber](https://github.com/nicenemo/jnoaber) for which the source code is available on GitHub.

[Noaber](https://github.com/nicenemo/jnoaber) provides you with mixin functionality for functional programming. [Noaber](https://github.com/nicenemo/jnoaber) adds extra functionality for streams. It adds methods for currying and partial application for functions of more than two arguments.

```java
package eu.hanskruse.trackhacks.noaber;

public  interface $ extends //
 Compose,
 Curry,
 Identity,
 PartialApplication,
 VarArgMath{
 // Only anchor point. Default implementations are in the super interfaces
}
```

[Noaber](https://github.com/nicenemo/jnoaber) has a single interface you can ' implement' in your classes or extend in your interfaces.

Since I consider its name not important I opted for a single character name '$'. Why '$'?

* It is a short name that should not get in the way
* Saves typing
* Because '\_' is illegal to use in Java 9.
* '$' is also available on a QWERTY keyboard and many other keyboards.
* I was inspired by jQuery

In case you have a class that has a real public interface I got you covered too. There is a companion class *Noaber* with final static field $ that holds an implementation of *$.* In this case you have to do a static import of *Noaber.$* and prefix all calls to Noaber's functionality with '*$.'.*

```java
package eu.hanskruse.trackhacks.noaber;

public final class Noaber implements $ {

 public static final $ $ = new Noaber();

 private Noaber() {
  // do nothing
 }
}
```

### Sample use of Noaber

In the code below I mix in *Noaber*'s functionality by "implementing" *$.*

This means I can call the methods of *$* as if they were instance methods.

This saves a lot of typing.

```java
package eu.hanskruse.trackhacks;

import java.util.function.BiFunction;
import java.util.function.Function;

import eu.hanskruse.trackhacks.noaber.$;
import junit.framework.TestCase;

public class CurryTest extends TestCase implements $ {

 /**
  * Create the test case
  *
  * @param testName
  *            name of the test case
  */
 public CurryTest(String testName) {
  super(testName);
 }

 public void testLeftCurryOnBiFunction(){
  final String expected ="42";
  BiFunction<Integer,Boolean, String> f = (x,b) -> Integer.toString((b?x:42));
  Function<Integer, Function<Boolean, String>> cf=leftCurry(f);
  final String actual =cf.apply(3).apply(false);
  assertEquals(expected, actual);

 }

 public void testRightCurryOnBiFunction(){
   final String expected ="42";
   BiFunction<Integer,Boolean, String> f = (x,b) -> Integer.toString((b?x:42));
   Function<Boolean, Function<Integer, String>> cf=rightCurry(f);
   String actual = cf.apply(false).apply(3);
   assertEquals(expected, actual);
 }
}
```

### Why call it Noaber?

"Noaber" is the word for neighbour in the [Saxon](https://nl.wikipedia.org/wiki/Nedersaksisch) dialects spoken in the eastern parts of the Netherlands (Twents, Drents, Sallands, Gronings, Achterhoeks) and the north western part of Germany ([Plattdeutsch](https://de.wikipedia.org/wiki/Niederdeutsche_Sprache)) and some parts of Poland and Denmark. The German word for neighbours is Nachbarn. Do you see the pattern? A good neighbour helps you but does not get in your way. The same should be true for the Noaber library. That is why I call it Noaber ;)

### Future work

Noaber is my structured kitchen sink of useful Java experiments. Please feel free to use it but do not expect anything.

I can add just another interface to the '$' 's list of implements clauses when I like to do so during my train travels. I get my inspiration mainly from JavaScript libraries such as jQuery, Underscore, Ramda and to some extent from .NET.

I probably will also remove stuff or make changes.
