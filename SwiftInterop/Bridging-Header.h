//
//  Bridging-Header.h
//  SwiftInterop
//
//  Created by Steve Madsen on 7/6/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

// Anything in the bridging header is made available to Swift code.

// This can be as simple as #include'ing (or #import'ing) a C/ObjC header file, but we can also put C function prototypes directly here. After all, remember that the C preprocessor is very simple: when it encounters a #include, it reads the contents of that file and inserts it in place within the current file. This is why precompiled headers and Xcode modules improve build times: the C compiler is no longer parsing the same headers over and over for every file.

// Swift can deal with simple macro definitions like this.
#define FOO 42

// Swift cannot handle more complex macros, such as the one for zlib's deflateInit() "function".

// Prototypes for some C functions defined in our own OutValue.c.
void outValue(int *outValue);
int sumArray(int *array, int count);

// And one for the function in Sockets.c.
void cSocketsDemo(void);

// zlib
#include <zlib.h>

// See zlib.swift for a discussion of why these following functions exist.
z_stream zlibCreateStream(void);
void zlibSetBuffers(z_stream *stream, Bytef *in, Bytef *out);
voidpf zalloc(voidpf opaque, uInt items, uInt size);
void zfree(voidpf opaque, voidpf address);

// OpenSSL's headers to support a simple example that generates a SHA-1 digest.

// Unfortunately, in Xcode 6 beta 5, the Swift compiler fails to parse rsa.h properly, and the OpenSSL example won't compile. There is an open Radar for this problem (17573187).

//#include <openssl/err.h>
//#include <openssl/evp.h>
//#include <openssl/bio.h>
//#include <openssl/pem.h>
//#include <openssl/pkcs7.h>
