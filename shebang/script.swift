#!/usr/bin/xcrun swift

println("Hello, world.")

// Shell scripts often need to return a value to the shell to signal success or failure. The Swift standard library does not contain a function to do this, but we can call exit() by importing Darwin.

import Darwin
exit(42)
