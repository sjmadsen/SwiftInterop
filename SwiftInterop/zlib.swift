//
//  zlib.swift
//  SwiftInterop
//
//  Created by Steve Madsen on 8/7/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

import Darwin

func swift_zalloc(opaque: UnsafePointer<()>, items: UInt, size: UInt) -> UnsafeMutablePointer<()> {
    return malloc(items * size)
}

func swift_zfree(opaque: UnsafePointer<()>, address: UnsafeMutablePointer<()>) {
    free(address)
}

func zlibDemo() {

    let inputSize = 100
    var inputBuffer = Array<Bytef>.init(count: inputSize, repeatedValue: 65)

    // Zlib has a pretty simple API. We create a z_stream structure, set it up a bit, then initialize compression, feed it bytes, and finish. This should be really simple in Swift, right?

    // Creating the stream structure is easy.
    var stream: z_stream

    // Unfortunately, nothing else is. Before can initialize compression, zlib needs us to provide it an allocation and deallocation function. I wrote those functions above, in Swift. As near as I can determine, their signatures match what zlib wants. However, the next two lines will have errors. Comment them out to continue.
    stream.zalloc = swift_zalloc
    stream.zfree = swift_zfree

    // The workaround is to write these functions in C. I've done that and their prototypes are in the bridging header. They match what zlib wants, and so we should be fine, right? Uncomment them and it'll give you a similar error to above.
//    stream.zalloc = zalloc
//    stream.zfree = zfree

    // The final workaround is to set these structure members in C code, where Swift's compiler fussiness can be ignored.
//    stream = zlibCreateStream()

    var error: Int32

    // The next step is to initialize compression. Zlib's public API says to call deflateInit() with our stream struct and a compression level. Unfortunately, this doesn't work. Swift can't find a function "deflateInit()". As it turns out, there isn't one. deflateInit() is a macro, defined in zlib.h, and while Swift can handle very simple macros (name = value, basically), it can't handle this one. So we can't call the "official" initialization API. Comment out this block of code.
    error = deflateInit(&stream, Z_DEFAULT_COMPRESSION)
    if error != Z_OK {
        println("deflateInit failed: \(error)")
        return
    }

    // If you uncomment this code to use the "real" initialization API, it'll compile, but after fixing the other errors below, you'll discover that it fails with error -6: zlib doesn't think the version of the library you linked with matches the version in the header you included. I'm pretty sure it does and this is introduced by the Swift compiler. Comment this back out, then open up zlib.c and read the comment inside zlibCreateStream().
//    error = deflateInit_(&stream, Z_DEFAULT_COMPRESSION, ZLIB_VERSION, Int32(sizeofValue(z_stream)))
//    if error != Z_OK {
//        println("deflateInit failed: \(error)")
//        return
//    }

    // Next up, we need to tell zlib what to compressed and give it a place to put the compressed bytes. Just two simple byte buffers.
    let outputSize = 100
    var outputBuffer = Array<Bytef>.init(count: outputSize, repeatedValue: 0)

    // The sizes of the two buffers are easy, aside from the Swift version of a type cast.
    stream.avail_in = uInt(inputSize)
    stream.avail_out = uInt(outputSize)

    // next_in and next_out are pointers to the start of those buffers. Hmm, Swift doesn't have pointers. We can't just assign the Array<> variable here because the types don't match. We can't use in-out & syntax because this isn't a function call. Once again, we're stuck.
    stream.next_in = inputBuffer
    stream.next_out = outputBuffer

    // The solution, as I'm sure you're getting familiar with, is to move this work to C code. We can pass the arrays to a function, and that function can assign the structure members.
//    zlibSetBuffers(&stream, &inputBuffer, &outputBuffer)

    // Finally we've done enough set up that we can start feeding zlib bytes to compress. This example is very simple and completes in a single call to deflate(), but normally you'd loop and continue updating avail_in, next_in, avail_out and next_out as needed.
    error = deflate(&stream, Z_FINISH)
    if error != Z_STREAM_END {
        println("deflate failed: \(error)")
        return
    }

    // Tidy up.
    error = deflateEnd(&stream)
    if error != Z_OK {
        println("deflateEnd failed: \(error)")
        return
    }

    // I haven't tried to decompress and verify that the output of compression is correct, but it seems reasonable that 100 zeroes compresses down to about 12 bytes. Besides, the exercise here is how much work it takes to call the zlib C library, not to validate it.

    println("Compressed \(inputSize) bytes to \(outputSize - Int(stream.avail_out)) bytes")
    println(outputBuffer)

}

