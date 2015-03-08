---
layout: post
title: Adventures in Monorail
image: http://www.ludumdare.com/compo/wp-content/compo2/308734/16006-shot0.png
---
Nearly a year ago, I took part in Ludum Dare 28 with some of the usual
suspects. What we came up with was an off-beat game called
[Monorail][mr].

![Monorail in action][mr-shot]

After talking to the rest of the team, I decided that the time had come
to move Monorail on to new and better things. "New and better things" in
this case meaning mobile platforms.

I've only had a brief dalliance with iOS before and Android is utterly
alien to me so this is lining up to be an interesting challenge.

LibGDX supports those targets which is the first major hurdle. iOS
support is provided via the rather clever [RoboVM][robovm], which
cross-compiles from JVM bytecode to native code. This is both a
blessing and a curse.

It's a blessing because it means everything is small and fast and easy
to ship. It's a blessing because it means not having to ship a JVM
implementation for iOS. It's a curse because the compile process is
*extremely slow*.

Java is the *lingua franca* of Android which makes the Android LibGDX
target rather more straightforward. Other than the standard "here be
dragons" warnings about Dalvik I've heard very good things about
LibGDX's Android support, so other than having to slog through setting
up the appropriate dark rituals to get an emulator working I'm looking
forward to working with it.

Expect to see Monorail hit some flavour of app store near you, at some
point, maybe! <sub>I'm not a marketer...</sub>

[mr]: http://www.ludumdare.com/compo/ludum-dare-28/?action=preview&uid=16006
[mr-shot]: http://www.ludumdare.com/compo/wp-content/compo2/308734/16006-shot0.png
[robovm]: http://www.robovm.org/

