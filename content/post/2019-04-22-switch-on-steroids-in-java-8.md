---
layout: post
title: "Switch on Steroids in Java 8"
date: 2019-04-22T18:24:30+02:00
draft: true
tags:
 - Java
 - Functional Programming
 - Esotheric Programming
---
In this blogpost I will create a more advanced `switch` expression in Java step by step.

<!--more-->

## Java switch statement until Java 8

I assume you are familiar
with a basic *C* Style switch statement as is present in Java since version 1.0. If not you can [look here](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/switch.html) for an example.

If you had some exposure to functional programming, you know that Java's switch statement corresponds to pattern matching in Functional Programming languages.

> Do not confuse Pattern matching in functional programming languages with Pattern matching using regular expressions.

Until Java 12, Java's `switch` is a bit limited in what you can match against in the `case` clauses:

* a primitive, int,long, boolean etc.
* a String
* An enum value

In Java you cannot match against:

* Classes
* Regular expressions
* Predicates

> Think about it!... Matching against *Classes* , *regular expressions*  and *ordinary values* are special cases of matching against *Predicates*.

## My Functional programming contamination

In 2007~2015 my brain was gradually contaminated by functional programming caused by exposure to:

* JQuery
* Linq (List monad in C#/VB.NET)
* FP style JavaScript
* A Scala course
* Books on F#
* An F# workshop  at Joy of Coding conference
* Writing some property based testing unit test code in F# and later Scala

Around 2014 I wondered whether an FP style switch statement could be created for JavaScript(Boring, no static typing) or C#. In 2015 I switched jobs and moved from C# to Java. So I challenged myself to write an advanced switch function in Java.

## First brain wave

A FP style switch expression consists of:

* A value to match against
* A list of case expressions that are evaluated in order until one matches. Every case consists of:
  * ~A primitive value, enumeration value, `String`, Type, Regular Expression,~ Predicate
  * Optional result
* A case returns `Optional.empty()` if  it's predicate results into false. Otherwise an `Optional` with the value of the right hand side can be returned.
* the switch expression returns with the first non optional value that is returned.

Matching a value is implemented using an `equals(...)` predicate.

In Java this can be implemented as follows:

```Java
package eu.hanskruse.trackhacks.noaber;

import static eu.hanskruse.trackhacks.noaber.Noaber.noaber;
import static java.util.Objects.isNull;
import static java.util.Arrays.stream;
import java.util.function.Function;
import java.util.Optional;

public interface WithPatternMatching {

  default <T,R> R match(final T value, final Function<T,Optional<R>>... cases) {
    return stream(cases)//
        .map(cse -> cse.apply(value))
        .filter(r -> r.isPresent())//
        .findFirst()//
        .get()//
        .get();
  }  
}
```

This has three problems.

* It crashes on a null array
* It crashes on an empty array of cases
* It crashes when a result is `Optional.empty()`

So let's fix that first.

```Java
  default <T,R> Optional<R> match(final T value, final Function<T,Optional<R>>... cases){
    Optional<Optional<R>> matchingCase = //
    stream(cases)//
    .map(cse -> cse.apply(value))
    .filter(r -> r.isPresent())//
    .findFirst();
    return matchingCase.isPresent() ? matchingCase.get() : Optional.empty();
  }
```

Now we need still need to define a helper function to create the `case` clauses. We name it `when(...)`.

```Java
  default <T,R> Function<T, Optional<R>> when(Predicate<T> p, R result){
     return value -> p.test(value) ? Optional.ofNullable(result) :Optional.empty();
  }
```

Also a helper function to implement the `default` `case` clause is needed. We name it `orElse(...)`.

```Java
  default <T,R>  Function<T, Optional<R>> orElse(R result){
    //ignore value
    return value -> Optional.ofNullable(result);
  }
```

## Shorthand for case type

Let's save some typing by defining a shorthand for the case type.

```Java
FunctionalInterface
public interface Case<T, R> extends Function<T, Optional<R>> {
  // do nothing. just a shorthand
}
```

## Matching with predicates

We first test our *FP style* switch statement by implementing [FizzBuzz]().

I created this little helper class:

```Java
public final class FizzBuzz {

  public static boolean buzz(final int n) {
    return n % 5 == 0;
  }

  public static boolean fizz(final int n) {
    return n % 3 == 0;
  }

  public static boolean fizzBuzz(final int n) {
    return fizz(n) && buzz(n);
  }
}
```

Now I can implement *FizzBuzz* as follows:

```Java
public class PatternMatchingTest implements WithQuickTheories, WithPatternMatching {

  @Test
  public void fizzBuzzExample() {
    qt().forAll(integers().all()).check(i -> {
      @SuppressWarnings("unchecked")
      final Optional<String> result = //
          (Optional<String>) match(i,//
          when(FizzBuzz::fizzBuzz, "FizzBuzz:" + i),
          when(FizzBuzz::fizz, "Fizz:" + i),
          when(FizzBuzz::buzz, "Buzz:" + i), //
          orElse("Something else:" + i)//
   );
      result.ifPresent(System.err::println);
      return result.isPresent();
    });
  }

}
```
And with this I showed that it is feasible to create a useable FP style pattern matching function in Java 8.

## Partial application

Next I looked on how pattern matching look like in Scala and F#. I made my code mimic this by first having a single argument function that `CaseAcceptor<T,R> match(T x)` that returns an instance of `CaseAcceptor<T,R>`. 
It is a form of partial application. 

It allows you to write the *FizzBuzz* example like:

```Java
 @Test
  public void fizzBuzzExample() {
    qt().forAll(integers().all()).check(i -> {
      @SuppressWarnings("unchecked")
      final Optional<String> result = //
          (Optional<String>) match(i).with(//
          whenPredicate(FizzBuzz::fizzBuzz).then(n -> "FizzBuzz:" + n),
          whenPredicate(FizzBuzz::fizz).then(n -> "Fizz:" + n),
          whenPredicate(FizzBuzz::buzz).then(n -> "Buzz:" + n), //
          orElse(n -> "Something else:" + n)//
   );
      //result.ifPresent(System.err::println);
      return result.isPresent();
    });
  }
```

## Matching with classes

For matching with classes I added a shorthand function.
In the following example I play with my food. (don't tell my mum.)

```Java
  @Test
  public void classMatchingExample() {
    final Food o = new Banana();
    final Optional<String> result = //
        match(o).with(
            whenClass(Elstar.class, "Elstar"), //
            whenClass(Fuji.class, "Fuji"), //
            whenClass(Braeburn.class, "Braeburn"), //
            whenClass(McIntosh.class, "McIntosh"), //
            whenClass(Apple.class, "Not a known apple: " + o.getClass().getName()), //
            whenClass(Fruit.class, "Not an Apple but it is fruit: " + o.getClass().getName()), //
            whenClass(FastFood.class, "Not an Apple but fastfood :( : " + o.getClass().getName()), //
            whenClass(Food.class, "Not an apple but you can eat it! : " + o.getClass().getName()), //
            orElse("Not edible" + o.getClass())//
        );
    // result.ifPresent(System.err::println);
    assertTrue(result.isPresent());
  }
```

## Matching with regular expressions

Other shorthand functionality I added was matching against regular Expressions. You can provide both a `String` or a a `Pattern` to matching against.

```Java
@Test
  public void regularExpressionMatchingExample2() {
    final String dutchPostalCodePattern = "\\d{4}[A-Z]{2}";
    final String o = "3122NH";
    final Optional<String> result = //
        match(o).with(
            whenPattern(dutchPostalCodePattern, "A dutch Postal code matched with a compiled pattern") //
        );
    // result.ifPresent(System.err::println);
    assertTrue(result.isPresent());
  }
```

When you want to use compiled patterns just provide a `Pattern` as first argument instead of a `String`, e.g:

```Java
...
match(o).with(
          whenPattern(Pattern.compile(dutchPostalCodePattern), "A dutch Postal code matched with a compiled pattern") //
      );
...
```

## Matching with values

Like with an ordinary *switch* statement we still want to be able to match against valules.

```Java
@Test
  public void valueMatching() {
    final String o = "3122NH";
    final Optional<String> result = //
        match(o).with(
            whenValue("3122NH", "An appartment building in Schiedam") //
        );
    // result.ifPresent(System.err::println);
    assertTrue(result.isPresent());
  }
```


## Combined matching

There is no reason why you could not combine Predicate, Class, Regular Expression and value matching.

```Java
@Test
  public void combinedMatchingAgainstObject() {
    final Object o = "3122NH";
    final Optional<String> result = //
        match(o).with(
            whenValue("Hello, World", "It is a nice day"), //
            whenValue(new Braeburn(), "yummie"), //
            whenClass(Elstar.class, "Elstar"), //
            whenValue("3122NH", "An appartment building in Schiedam"), //
            orElse("Not edible" + o.getClass())//
        );
    // result.ifPresent(System.err::println);
    assertTrue(result.isPresent());
  }
```

Note that your IDE may not always catch obvious errors in these kind of situations.
The compiler will, but the error messages will be a bit cryptic.

## FunctionalPredicate

>> TODO: still seems to be needed when you want to be lazy in the second argument of cases

I realized that I could generalize the `Predicate` of a case to a `Funtion<T,Optional<V>>`. This is *FunctionalPredicate* is composed from a Predicate<T> and a transformation function of type `Function<T,V>`. The right hand side of the `Case`  then accepts a function of `Function<V,Optional<R>>` instead of a simple value. You may consider this a bit overengineering.



I also wrote a variant that accepted the cases first and with the resulting function accepted a value to match against. This allows you to pass around a *'switch'* expression.

A benefit of this two step approach is that you probably have to write fewer unit tests.

This works great until I tried:

* To add `when` overloads for values, regular expressions and classes. The compiler cannot handle that. Circumvented in the above example with postfixing *'when'* to  *'whenPredicate'*.
* Using subclassing with my *'whenClass'* method.

Then the compiler lambda parameter binding does not work as you want it. It may be my fault but there are also seem to be some bugs in Java 8's  compiler. There seem to be some fixes in later Java versions but not for Java 8. It was too complex to sort this out for a hobby project,  so I decided to to take two steps back before adding matching Classes and regular expressions as shorthands:

* I removed the `FunctionalPredicate` support
* I reverted to a single method for pattern matching.
