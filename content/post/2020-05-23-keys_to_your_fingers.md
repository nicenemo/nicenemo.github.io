---
title: "Move the keys to your fingers"
date: 2020-05-23T15:25:38+02:00
draft: false
tags:
 - gear
 - ergonomics
 - smart working
Author: Hans Kruse
---
I am looking into faster, smaller and hopefully more ergonomic keyboards.
Below you will find a selection of my thoughts on _(custom build)_ mechanical keyboards.

 <!--more-->

On a keyboard, the _home row_ is the row that you rest your fingers on a keyboard.
This is the second row from the bottom. On a 40% keyboard, every key you need is
on the _"home row"_ or one row above or below the _"home row"_. For other keys you switch modes,
or layers. [Move the keys to your fingers](https://www.youtube.com/watch?v=AKGXZ1ReU54),
not your fingers to the keys.

A custom mechanical keyboard with all options ticked is quite expensive and is easily priced between €200,-
and €300,- Therefore I thought it to be wise to emulate and try 40% and 60% keyboard first. More on those percentages later in this post.  I found a project that emulated QMK style layered keyboards using
[AutoHotKey](https://www.autohotkey.com/) _(AHK)_. AutoHotKey is a keyboard macro utility
(and much more) for Windows.

I cloned and modified the [project](https://github.com/nicenemo/AutoHotkey), so that I have 40% and 60%
keyboards on a normal 100% keyboard with the extra keys blocked and support for layers.
Switch layers is done by tapping shift or control twice fast.
It is not the same as real 40% or 60% keyboard, but it helps.
After a week, I really noticed the benefits.
Certainly AutoHotKey is useful on its own. I will probably use it in combination with a smaller keyboard.

As a computer science student in 1994, I was introduced to [Vi](https://en.wikipedia.org/wiki/Vi),
not [Vim](https://vim.org), but the real thing, Vi.
Vi is an advanced editor that distinguishes itself from other editors by utilizing modes.
The cursor keys, delete key, backspace key etc are not used. Instead, in Vi you are in normal mode first.
You use _h, j, k, l_ and other keys to move around and edit.
This has the advantage of not moving your hands.
Moving your hands to the cursor keys and back slows you down.
Using the normal cursor keys can also be painful, if you suffer from RSI.
Entering text in Vi, is done by switching to input mode first.
You do this, by pressing the _i_ key. When done entering text, going back to _normal mode_ is done by
pressing the _Escape_ key. Learning a bit more beyond those basics is really worth It! Yes I know how to exit vim. I press _ZQ_, _:q!_ is for amateurs.

Fast-forward to 2020. I am still interested in working faster and more comfortable. I use Vi in it's
[SpaceVim](https://spacevim.org/) incarnation with [NeoVim](https://neovim.io/). I like it so much that I,
_wannabe_, try to configure Vim key bindings in other programs when possible. This sometimes works well,
but sadly this does not work in some situations.

What if my keyboard has a Vi modus? I knew about so called 10 keys less (TKL) keyboards.
These are similar to common laptop keyboards in the sense that they ditch the numeric parts.
Function keys and the numeric pad are reachable via the _Fn_ key.
This has also exists in an _Fn Lock_ variant. But can you go further? Yes of course you can.
Sadly The Fn key on my ThinkPad does nothing with other keys. I checked with AHK and other tooling.

Printing out and learning some hotkeys of
[Windows](https://www.hanselman.com/blog/CollectingWindows10AnniversaryEditionKeyboardShortcuts.aspx)
or Mac and your favourite programs can be useful.
Did you know that Microsoft calls pressing the combination of _Shift_, _Control_, _Alt_ and _Windows_,
the _Office Key_ ? It can be used to start Office the following Office programs:

|Key      | Function                                                                               |
|:--------|:---------------------------------------------------------------------------------------|
| Hyper   | Browser on the [office 365 site](https://www.office.com/?from=OfficeKey)               |
| Hyper F | Onedrive                                                                               |
| Hyper L | Browser on the [LinkedIn site](https://www.linkedin.com/feed/?trk=Officekey)           |
| Hyper N | OneNote                                                                                |
| Hyper O | Outlook                                                                                |
| Hyper P | Powerpoint                                                                             |
| Hyper T | Teams                                                                                  |
| Hyper W | Word                                                                                   |
| Hyper X | Excel                                                                                  |
| Hyper Y | Yammer or the browser on [Yammer](https://www.yammer.com/)                             |

Do you know more?

Hyper is nothing new but more commonly known has the _Hyper_ key.
The Windows key is also known as the _Super_ key.
Some keyboards such as the [Space cadet keyboard](https://en.wikipedia.org/wiki/Space-cadet_keyboard)
have a dedicated key labelled _Hyper_. The combination is awkward to press. Having a dedicated _Hyper_ key might be a good idea to have on my new keyboard.

Now I will elaborate more on Keyboard percentages. TKL keyboards ditch the numeric pad and are also known as 90% or 80 something % keyboards. TKL is more common for these keyboards. So called 60% keyboards exist,
e.g., the [Ducky Mecha Mini](https://www.duckychannel.com.tw/en/Ducky-Mecha-Mini)
and similar from other brands. These are popular among gamers. These do not only ditch the numeric pad,
but also go without the function keys, NAV cluster and cursor keys.
The missing keys, the numeric pad and even a mouse is made available by switching layers.
This is done by using special _Fn_ like keys or by pressing a key like shift briefly or twice.

This is similar to pressing caps lock on a traditional keyboard or using modes like in Vi.
A 60% keyboard has a learning curve. However, with a 60% keyboard I still have one row too many.
The rows with the numbers is two rows away from the _"home row"_. Ditch that row and you get a so called 40% keyboard. Again the numbers and function keys are available on a layer. The numbers are also available as a numeric pad on another layer. On such a keyboard you can imagine shifting the function keys and number keys virtually present above the top row. You can shift them under your fingers by activating a layer.

The percentage does not mean that keys are shrunk, but how many keys are still left on the keyboard. Keyboards with smaller keys do exist too!
There are variations of 60% and 40% keyboards, that do have cursor keys,
instead of Right-Alt, Windows, Right-Shift and Right-Control keys.
Some even have a double function, modifier when hold, cursor key when tapped.
Using layers a 47 key keyboard can easily go to more than 470 different keys.
A normal keyboard has 101 or 105 keys. So less is more!

Can we go further? Maybe 30%? Keyboards with fewer keys do exist,
think about separate numeric or macro pads. Other are for more specialist use,
e.g. like the ones stenographers use.
One handed keyboards such as the [FrogPad](https://en.wikipedia.org/wiki/FrogPad) is another category.
I am not sure what the use case is for that except for people with disabilities.
In theory one key is enough to press all keys, it just requires something like Morse code to type all the keys. Hobby projects for such keyboards do exist.

Keyboards with way more keys also do exist. An example is the [Space Cadet Keyboard](https://en.wikipedia.org/wiki/Space-cadet_keyboard).
It has both a Hyper and a Super key. It allows for easy entering of mathematical formulas.
If you like to take it to the max you can go for a Space Cadet inspired keyboard,
the [Hyper 7](http://xahlee.info/kbd/hyper_7_keyboard.html)
Another insane keyboard is the [Wytec MK6](https://www.youtube.com/watch?v=1FHkQpYBygE).
This is keyboard with 3 build-in screens and a KVM. This one is mainly marketed for trading floors but can also be used in other Command & Control theatres.

An overview of typical keyboard sizes:

| kind | remark                                                                 |
| :--- | :--------------------------------------------------------------------- |
| 100% | The normal PC keyboard                                                 |
| 96%  | Squeezed 100% keyboard with (almost) all the keys)                     |
| TKL  | Ten-Keys-Less, no numeric pad, like a laptop.                          |
| 75%  | Squeezed TKL with the NAV cluster on right as a row from top to bottom |
| 65%  | Like the 75% but with no function keys                                 |
| 60%  | No cursor keys, NAV cluster and function keys                          |
| 40%  | Like the 60% but also places the numbers on a layer.                   |

Besides number of keys, keyboards can also differ in layout:

| layout               | remark                                                                 |
| :------------------- | :--------------------------------------------------------------------- |
| horizontal staggered | The rows are shifted a little less than half a key from each other.    |
| vertical staggered   | The columns are shifted a little less than half a key from each other. |
| Ortholinear          | All keys are in a grid, like in the normal numpad.                     |
| Split                | The keyboard is split in two halves connected by a wire.               |
| Ergonomic            | Halves at an angle and there is a so-called thumb cluster              |

Combinations of a split, ergonomic with horizontal or vertical staggering or ortholinear keyboards do exist.

I like the ortholinear 40% keyboards, such as the [Planck](https://ergodox-ez.com/pages/planck) or the [Niu40](https://kbdfans.com/products/fully-assembled-niu40-mechanical-keyboard). They force you to use layers and are portable too!
Initially I was a bit worried about my shoulders and back when using such a tiny keyboard.
Therefore, a 40% split ergonomic keyboard with thumb cluster might be more suitable. This allows me to place the two halves apart so that I will not sit with bent shoulders. I can even rest the two halves on the sides of an arm chair and pretend I am captain Picard.

I finally bit the bullet and bought a Planck via [Drop](https://drop.com/?referer=MEXT6P).
It was delivered two weeks ago. It is good!! So good, I did buy two more.
Angela my wife was sceptical at first, but now she asked me to get one for her too.
I still think a split might be a good/cool idea but is less necessary.
I am still exploring the Planck and 40% for real now. More on that in a later post.

Final thought, how many keys do you have left before you die? Find out on [keysleft.com](https://keysleft.com/)
