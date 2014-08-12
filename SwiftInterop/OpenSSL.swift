//
//  OpenSSL.swift
//  SwiftInterop
//
//  Created by Steve Madsen on 7/17/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

// Theoretically, this code compiles, but due to a parsing bug in the Swift compiler in beta 5, I can't be sure.

// I'll try to keep up with Xcode 6 betas and update this code to work.

func sha1() {

    var context: EVP_MD_CTX
    EVP_MD_CTX_init(&context)
    EVP_DigestInit_ex(&context, EVP_sha1(), nil)

    let string = "hello, world"
    EVP_DigestUpdate(&context, string, UInt(countElements(string)))

    let digestSize = 20
    var digest = Array<UInt8>.init(count: 20, repeatedValue: 0)
    EVP_DigestFinal(&context, digest, nil)

    var s = ""
    for byte in digest {
        s += String(format: "%02x", byte)
    }
    println(s)

}
