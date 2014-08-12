//
//  zlib.c
//  SwiftInterop
//
//  Created by Steve Madsen on 8/7/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <zlib.h>

voidpf zalloc(voidpf opaque, uInt items, uInt size)
{
    return malloc(items * size);
}

void zfree(voidpf opaque, voidpf address)
{
    free(address);
}

z_stream zlibCreateStream(void)
{
    z_stream stream;
    stream.zalloc = zalloc;
    stream.zfree = zfree;

    // Even the "real" public API for initializing the compression stream fails when called from Swift. Calling it (or the preferred macro version) from C code works just fine, though. Uncomment this code so the example actually works.
//    int error;
//    error = deflateInit(&stream, Z_DEFAULT_COMPRESSION);
//    if (error != Z_OK) {
//        fprintf(stderr, "deflateInit failed: %d", error);
//    }

    return stream;
}

void zlibSetBuffers(z_stream *stream, Bytef *in, Bytef *out)
{
    stream->next_in = in;
    stream->next_out = out;
}
