---
layout: post
title: "The six benefits of final"
date: 2016-09-11T10:14:00-07:00
lastmod: 2018-08-17T03:32:09-07:00
draft: false
aliases:
 - /2016/09/the-six-benefits-of-final.html
---

Ever since I returned to back to "the Duke side of the Force" I am pleased when I can type a specific word of 5 letters: **final.** Final means you cannot change it after it was set or defined. In functional programming languages **final** is the default and usually implicit. At the cost of five characters more verbosity per declaration you get the same six benefits functional languages give you for free. With final code is easier to:

1. understand.
1. maintain.
1. document.
1. debug.
1. make parallel.
1. optimize for a compiler.

In the rest of this post I will explore possible uses of the word final in Java.

### Final for constants

Java has no keyword for constants but uses final. A constant in Java is defined within a class like:

```java
public static final int ULTIMATE_ANSWER = 42;
```

Constants are written in SNAKE_CASE in Java. Really something to get used to if you come from some other environment. And yes *const* like in C#, or JavaScript is more succinct. If you want to constrain the use more you can use package visibility, protected of private if you like.

In more recent versions of Java enums can be used for the same purpose if you use int values.

### Final for fields

You can use final for fields. This enforces setting them in a constructor. Something like

```java
public class DutchAddress{
  private final String street;
  private final int number;
  private final String postalCode;
  private final String city;
  public DutchAddress(String streetValue, //
    int numberValue, //
    String postalCodeValue, //
    String cityValue){
    //include some argument checking.
    this.street = streetValue;
    this.number = numberValue;
    this.postalCode = postalCodeValue;
    this.city = cityValue;
  }
 //.. only add getters!
}
```

If I do not add a constructor or only a default constructor I get a compile error.

Using the constructor as above I am sure DutchAddress never contains uninitialized values for its fields.

Taking care of argument sanity is something for another blog post.

However making this constructor private and provide a factory is a possible solution if you do not want to throw exceptions in a constructor.

For the remainder of this post we assume we do not use final for the fields.

### Final in method signatures

It is sometimes common practice to do argument checking on the arguments of a function and change the arguments value in the process. Something like the following.

```java
public class DutchAddress{
  private String street = "";

  public void setStreet(String value){
    if(value == null){
      value = "";
    }
    value = value.trim();
    this.street = value;
  }
  //...
}
```

Now imagine you are debugging the code above somewhere in the middle, or actually a bit more complicated code that does something similar. You cannot lookup the original value of *value* easily.

At the cost of using final and introducing an extra variable you can be sure the original value can be seen when debugging. I change the code as follows:

```java
public class DutchAddress{
  private String street = "";

  public void setStreet(final String value){
    String checkedValue = value;
    if(checkedValue == null){
      checkedValue  = "";
    }
    checkedValue =checkedValue .trim();
    this.street = checkedValue ;
  }
  //...
}
```

Yes, I know:

* This argument only holds for non mutable types. But a lot of my coding involves ints and Strings as arguments.
* I use *value* here as name of the argument instead of *street*. I think it is more DRY.

Using final is a promise to the compiler, yourself, your later self and the guy after you, that you do not play tricks with the arguments.

For a setter this is a bit verbose. I can improve on that and also lose the explicit temporary variable.

```java
public class DutchAddress{
  private String street = "";

  public void setStreet(final String value){
    this.street = (value == null?"":value).trim();
  }
  //...
}
```

### Final in the body of a method

Final in the body of a method works a bit like a const but it can change on every invocation influenced by the arguments or the state of the object.

```java
public class DutchAddresses{
  private final List<DutchAddress> addresses= //
    new ArrayList<DutchAddress>;

  public void addVerifiedAddress(final String street, //
     final  intnumber, //
     final String postalCode, //
     final String city){
  //we assume the arguments are fine for now ;)
  final DutchAddress address=new Address(street,number,postalCode,city);
  //...

  // do some amazing verifications here

  //...

  //we are certain the same address object we created earlier is added.
  //Since DutchAddress is mutable it's fields may have changed.
  addresses.add(address);

}
```

Here I am sure that the reference to address never changes within the current call of the method once it is set.

### Final in for loops

Java has a special kind of for loop that is known as an foreach loop in other languages.

It has the following form:

```java
for (DutchAddress address :addresses){
 //do something with the address
}
```

Unfortunately the reference to address is modifiable like with the method arguments without final keyword. You can do this.

```java
for (DutchAddress address :addresses){
 //do something with the address
 address = new Address("Noordeinde",68,"2514GL","Den Haag");
 //do some more with the overwritten address
}
```

The guy living at the newly instantiated address is lucky for multiple reasons! One reason is that he never ends up in our address list. To prevent such error superhero final rescues us.

```java
for (final DutchAddress address :addresses){
 //do something with the address
 address = new Address("Noordeinde",68,"2514GL","Den Haag"); // compile error
 //do some more with the overwritten address
}
```

Every iteration an address is retrieved from the list of adresses which cannot be changed in the body of the loop. However since an instance of DutchAddress is mutable its fields can be changed.

### Final at the class level

```java
public final class DutchAddress{
 //..
}
```

This means you never intended the class to be extended. It is a clear message to your later self and the guy after you in the role of maintainer. It also allows a compiler to do some optimizing.

Making a class extensible, aka non final places great responsibility on the base class designer. The guy extending your code may not have access to the source. So you must make it bullet proof and document the extension points very well. If someone is using extended code and it breaks in the base class who is to blame?

### Final at the method level

Final at the method level is similar to final at the class level. It forbids overriding a method.

Since I usually make classes final I haven't used it in Java or the similar 'sealed' construct in C#. A crazy thing you can do to test your IDE with final is making an abstract method final. At least Eclipse gives the wrong advice about making the method public or protected.

```java
public class DutchAddress{
 //..
 final boolean isValid(){
    //...
  }
}
```

### Final in try with resources clause

Since Java 7 try /catch is extended with the option to declare resources that get released when they get out of scope. This is similar to a .NET using clause but with the added benefit of being able to catch Exceptions. However in Java the references to the resources are mutable where they are 'final' in .NET. However you can make them immutable by declaring the resources final. Resources must implement the interface `java.lang.AutoCloseable`

Example:

```java
try( final MyAutoCloseableResource reader=new MyAutoCloseableResource()){
 //... do something
}catch(Exeption ex){
//... log something and do some exception handling
}
//.. here is an implicit finally clause closes the autocloseable if it is not null.
```

The added final makes sure we dot leak resources in the body of the try.

### Disadvantages of final

There are some disadvantages on final. First of all, it is not DRY because final is not the default in Java. You have to use it again and again to enforce it. Code checking tools like [findbugs](http://findbugs.sourceforge.net/) or [Sonarqube](http://www.sonarqube.org/) may help to discover violations and or enforce it.

Second method signatures may become very long with multiple arguments.

It becomes worse if you also add argument validating decorators which will be the topic of another post. e.g. a method signature like

```java
public void addAddress(@NonNull final String streetValue, //
  @IntRange(from=1,to=9999) final int number, //
  @NonNull String postalCodeValue, //
  @NonNull String city){
//..
}
```

Third, a trick to test classes is to subclass them and override methods. Sorry you better use a proxy for that.

Finally, making fields final in existing code is usually undoable without major API redesign.

### Recommendations

I recommend making:

* classes final that you never intend to extend.
* loop variables in a 'foreach' style for loop final.
* arguments of methods final.
* declared variables in methods final as much as possible.

I think making fields final is hard. It goes against the Java Beans Idea and requires additional methods to make it usable by other programmers. In existing code it is not doable but perhaps your team can agree upon doing it on new code.

### Finally

'Finally' is another nice keyword out of the scope for this blog post.

Yes I know about using specific types for street and postal code but that is out of scope too*.*

If you are interested in that, read [Scott Wlaschin's excellent series on Desiging with types.](https://fsharpforfunandprofit.com/series/designing-with-types.html)

Also available as video conference talk via his website. Enforcing that style in an existing codebase may be an "interesting" exercise. In a next post I try doing that a bit using decorators.

* *What's your favorite keyword or language feature and why?*
* *What is a valid use for final at the method level?*
* *What is the maximum number of arguments you allow in a method?*
* *What is the maximum number of characters you allow in a line of code?*
* ~~*Tabs or spaces?*~~

### What's Next

* Decorators to constrain types.
* Streams.
* Automatic Getter/Setter and more testing for Beans.
