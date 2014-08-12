//
//  Sockets.swift
//  SwiftInterop
//
//  Created by Steve Madsen on 8/7/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

// This is the Swift equivalent to the pure C sockets example.

// Far less to import to get to all of the types and functions we need.
import Darwin

func socketsDemo() {

    // This looks essentially identical to the C version.
    var sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    if sock < 0 {
        println("socket() failed: \(errno)")
        return
    }

    // This is where things start getting funny. Some things to note here:
    // 1. We can't "allocate" the struct on the stack, because there's no way to get a pointer to it to hand to the connect() API. So instead we have to go through a factory method on UnsafeMutablePointer<> and ask it to create an instance. This also means it must be explicitly deallocated (see below, immediately following the call to connect()).
    // 2. Setting values on our struct goes through this "memory" thing, although at least we can use the same names as C after that.
    // 3. Instead of htons(), we can ask the integer literal 80 for its value in big endian. One must already know that big endian is the same as network byte order, though.
    var serverAddress = UnsafeMutablePointer<sockaddr_in>.alloc(1)
    bzero(serverAddress, 0)
    serverAddress.memory.sin_family = sa_family_t(AF_INET)
    serverAddress.memory.sin_addr.s_addr = inet_addr("127.0.0.1")
    serverAddress.memory.sin_port = 80.bigEndian

    // Where in C we cast the pointer to make the compiler happy in the face of warnings, with Swift that isn't allowed. Or at least, it's messier. We have to create a new constant and initialize it with the value of the real struct. This makes Swift happy when we call connect(). Likewise, sizeofValue() returns an Int, and Swift won't coerce that into a socklen_t/Int32 automatically.
    let address = UnsafePointer<sockaddr>(serverAddress)
    let size = socklen_t(sizeofValue(serverAddress.memory))
    let error = connect(sock, address, size)
    serverAddress.dealloc(1)
    if error < 0 {
        println("connect() failed: \(errno)")
        return
    }

    // Mostly the same here as C.
    let request = "GET / HTTP/1.0\n\n"
    write(sock, request, UInt(countElements(request)))

    // The read loop isn't too different. Buffer management, again, isn't as straightforward, and "casting" the buffer into something printable feels a little dirty. What to do if we don't get back UTF-8?
    var bytesReceived = 0
    do {

        let bufferSize = 1000
        var buffer = UnsafeMutablePointer<CChar>.alloc(bufferSize)
        bytesReceived = read(sock, buffer, UInt(bufferSize))

        // Creates a new `String` by copying the nul-terminated UTF-8 data referenced by a `CString`.
        // What if it isn't UTF-8?
        print(String.fromCString(buffer)!)

        buffer.dealloc(bufferSize)

    } while bytesReceived > 0
    println()

    close(sock)

}
