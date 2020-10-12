---
title: "Move the keys to your fingers"
date: 2020-05-23T15:25:38+02:00
draft: true 
tags:
 - gear
 - ergonomics
 - smart working
Author: Hans Kruse
---
I am looking into faster, smaller and hopefully more ergonomic keyboards.
Below you will find a selection of my thoughts on _(custom build)_ mechanical keyboards.

 <!--more-->
 Franz,

Thanks for your email. Currently, I am not using Autohotkey. Maybe I will again later.
I did customize my 40% Planck keyboard and customized it a bit too much. I will post this answer as a blog post later.

When first looking into a smaller keyboard I wanted a 40% or 60% split ergonomic keyboard.
I was looking at Kyria or a Daisy. I might buy one of these later. The Ergodox is too big for me.
I am waiting for my second Planck for us at work or on the move. Only getting Zealeos 62 gram purple switches are very hard to get.
So it might take some time before it is useable. 

With a 60% Keyboard and certainly with a 40% you need layers. The standard layouts provided make it easy to start discover/guess where the number keys etc are. I decided to keep it as is for two weeks before starting to customize it. Then I started adding layers and changing existing ones. I used inspiration from many keymaps and read through the QMK documentation and source code. 

 I quickly  noticed the limitations of keyboards. Keyboards can only send letters, numbers, function keys modifier keys and a few others as key codes. Diacritics or Chinese characters is something that is done on the computer. The keyboard has no idea in what program I am in. I decided to do away with Autohotkey. I improved my vi knowledge, switch to Z shell and turn on vi mode in both Z shell and Bash. I did not program any macros in my keyboard. Macros make only sense in the context of specific programs. If I want macros, I probably would use Autohotkey or the macro functionality of Vim or Visual Studio Code. 

What I used a lot was the functionality to have a different behaviour when holding a key. For example my space bar when tapped is just normal space. When hold it works as an extra layer key and the keys left and right of it are delete and backspace keys. I did move my enter key to be on the right layer key. The left layer key is an extra backspace when tapped. With this change I created a thumb-cluster like you find on split ergonomic keyboards, like yours.

 The cursor keys work as cursor keys when tapped but modifier keys, Windows, Shift, Control and Alt key. The modifiers keys on the left work like the cursor keys but for the big movements: home, page down, page up and end. I added both a left and right-hand mouse layer, a left and right-hand nummeric layer a function key layer a media key layer. Finally, I added a layer with leftover keys, e.g. Sun keys, Asian modifier and function keys.

I added two extra dedicated layer keys that when hold bring another layer under the existing keys. Other layer keys are on the backspace and tab key when held.

Most of my time I work from home nowadays because of Covid. One day when I was at the office I forgot to bring a mouse. I did use the mouse functionality of QMK. It works very  well.

You might have heard about the Space Cadet Keyboard which has a hyper key, the combination of shift control Windows and Alt. Microsoft on Windows defined it as the Office-Key. The Office-Key  allows you to start Office Programs or open LinkedIn in the browser. I defined 2 letter keys to be used as office keys when held.

During my summer holiday I did not use my keyboard a lot. I forgot some layers. 

The last few months I am using my Planck on an almost daily basis and I ran into some issues with my layout that need change:

* The Hyper-L combination fires by accident a lot. This will start a browser tab with Linked in.
* I do mash the cursor keys in some programs, especially games. When playing games I switch to my Das Keyboard.
* I can get an editor into overwrite mode and I did not remember how to type the insert mode key.
* I still use the backspace keys.
* I would like the backslash instead of the backspace key.

Changes I will make soon are:

* getting rid of the Hyper-key or move it to an useable but not annoying place.
* Make the cursor keys Mashable again; thenceforth I will lose the right modifier key functionality.
* Get an useable insert key
* Make the backspace key a backslash key.

My current keyboard layout https://github.com/nicenemo/franken-planck. At the moment of writing still with double function cursor keys and Hyper key support. 

I am curious about your experience with the Ergodox after two weeks, after a month and after 3 months.
Since it is bigger than a 40% I wonder whether you will change it that much as I did with my Planck.
