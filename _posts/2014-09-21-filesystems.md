---
layout: post
title: Filesystems – A Terrible Abstraction
published: false
---
*Filesystems are a terrible abstraction*.

That's quite a claim—particularly since people feel strongly enough about
hierarchical filesystems to make them the basis of entire operating systems
(UNIX and Plan 9).

Block Devices
-------------

To begin to demonstrate what might be bad about filesystems, let me introduce a
similar abstraction from one level down: the block device. What kind of an
abstraction is a block device? A block device essentially has three methods:

* get the number of blocks in the device,
* get the contents of a block (indexed from 0 to the number of blocks in the
  device),
* write new contents to a block.

Now block devices, in my opinion, are a fantastic abstraction. That list is
small, and while it makes a very convenient abstraction for SATA or USB block
devices, it's far more generic than that.

How would you make a "block device" which actually refers to space in memory (a
RAM disk)? It's actually pretty clear, with some block of memory, how all three
of those operations work - the first gives you the size of the memory region
divided by the size of a block, and the second and third are `memcpy()` in
different directions.

Encryption, again, is pretty clear. It "stacks" onto another, lower-level block
device: the block count operation passes straight through, the read operation
reads from the lower device and decrypts it on the way out, and the write
operation writes to the lower device and encrypts it on the way in.

The basic RAID configurations are simple too. To mirror multiple block devices
with the same block count, you pass through the read operations to any of them
and the write operations to all of them. RAID 0 is a matter of switching on the
block index, passing even reads and writes to one device and odd reads and
writes to the other.

The simplicity and totality of the block device interface makes it not only very
good for its original purpose, but also very composable and adaptable to new
interfaces. If I write a piece of software that works on block devices, then
"for free" it works with encryption, or RAID, or ATA over Ethernet, or any of
these technologies which can just present their interface as a standard block
device.

Filesystems
-----------

Now, compare with the above the operations on a filesystem.

* `open`
* `close`
* `read`
* `write`
* `lseek`
* `stat`
* `unlink`

And some functions for dealing with directories.

* `opendir`
* `closedir`
* `readdir`
* `seekdir`
* `mkdir`
* `rmdir`

...and permissions...

* `chmod` (ah yes, of course - permissions in the filesystem)
* `chown` (and owner information...)

Symbolic links...

* `readlink`
* `symlink`
* `lstat`

Hard links...

* `link`

Named pipes.

* `mkfifo`

Character and block specials.

* `mknod`
* `ioctl`

UNIX-domain sockets...

* `socket`
* `bind`
* `connect`
* `listen`
* `accept`
* `shutdown`

And the kitchen sink.

* `fcntl`
* `flock`
* `utimes`

Is that everything? I have no idea. I could very easily have forgotten things.
That list doesn't include extended attributes, or the details of the different
modes for `open`, or `mmap`, or what is or isn't available in `ioctl`...

It's horrible, take it away!

Given the sheer weight of complexity from that interface, is it surprising that
there are strange special cases when one tries to write union-mounted filesystems?
Or filesystems running over a network (NFS)?

Think back to the block devices, I used the example of encryption. The way
encryption works at the block device level is pretty obvious. How would you
handle encryption with the filesystem abstraction? The level of complexity and
special cases is staggering.

