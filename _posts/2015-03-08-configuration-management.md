---
title: On Configuration Management
layout: post
published: false
---
Over my years of working with [Puppet][puppet], one thing has become increasingly clear to me: it's not actually a very pleasant tool to use. I don't mind the syntax, the slowness is only an inconvenience, and its dependency system I actually like. No, for me the real problem in Puppet comes down to one thing: workarounds.

If you've used Puppet in a real-world situation you'll know it's a joy to use in the cases where the stars align and things work, but the workarounds quickly spiral out of control.

Monstrosities that take half an hour each run are not uncommon, because of the amount of patching around things that one has to do. ****

Ultimately, though, what we actually _need_ from configuration management basically boils down to a few basics[^1]:

* configuring what packages are installed,
* configuring what users and groups are present,
* configuring the contents of the config files in /etc,
* configuring what services are running,
* specifying dependencies between all of the above.

Here's the critical observation: *all of those things* can be done with the system package manager.

A deb or an rpm can certainly put files in places, create users, manage services, and have dependencies on other packages. We've been using them for a very long time now. But if they can do all of that, why the complexity in Puppet? Much of it is build steps. Puppet configuration tends to involve not just installing software, but *building it* too.

Python deployments often involve installing through source distributions with setup.py steps. Grunt or Rake builds are common. On my own server I run Jekyll to build the static content.

Here's what I would propose as an alternative. All the build steps should be handled by CI, which is much more suitable. CI can then produce .rpm or .deb packages as artifacts, and the server configuration can really just be a matter of specifying a list of packages to install.

I could well have CI run Jekyll and produce `alynn-website-content_$BUILDNUMBER_all.deb` which makes sure that the `www-content` user exists and installs the built website content into `/var/www/html`. I could also have `alynn-website_$BUILDNUMBER_all.deb` which depends on the content and on nginx, and installs the configuration for serving the main website.

With tools like [fpm][fpm], it's not difficult at all to generate native packages from other systems—going from a target directory structure, or from Python packages, or gems, or an npm bundle really is pretty trivial.

[puppet]: https://puppetlabs.com/
[fpm]: https://github.com/jordansissel/fpm

[^1]: A simplification which excludes cases like firewall rules, I do acknowledge.
