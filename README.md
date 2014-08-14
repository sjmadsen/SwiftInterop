# SwiftInterop

This project contains the examples I worked through during the Swift Interoperability with C talk I gave in August 2014 at [CocoaConf Columbus](http://cocoaconf.com/columbus-2014/home).

I tried to ease into some of the difficulties involved with calling C code during the talk.

1. Open the playground first. Apple has packaged up what I consider to be "standard C" in the Darwin framework. Once you import it, you'll see that calling simple standard C library functions like `time()` is very easy. Swift's in-out function argument syntax even makes passing a time_t variable by reference to `time()` look exactly like it does in C.
2. Swift also makes working with C strings nearly transparent. Calling `strlen()` works as one might expect it to with a literal Swift string.
3. There are also a couple examples of how to create pointers to arbitrary data types. I don't use them for anything in the playground, but we'll come back to pointers in some of the code examples.
4. Open AppDelegate.swift. There are a couple of examples of calling your own C code here. Function prototypes are in Bridging-Header.h.
5. From this point on, I commented the code to explain problems and workarounds. Start with the sockets demo. Read through the C version to see how it has traditionally been done, and compare it to the same code written in Swift. Then move on to the zlib example.
6. During the talk, between the Swift sockets example and zlib, I touched on OpenSSL. In Xcode 6 beta 5, the Swift compiler can't parse rsa.h, one of the OpenSSL headers. When this is fixed, I'll update the example code and this README.

# Questions?

Create a GitHub issue or ping me on Twitter.

Steve Madsen  
[@sjmadsen](http://twitter.com/sjmadsen)
