//
//  Sockets.c
//  SwiftInterop
//
//  Created by Steve Madsen on 8/9/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

// Socket code may not be of quite as much use these days, but I find it still serves as a good example of the typical kinds of things we had to do in C in the past.

// Networking requires a handful of headers
#include <stdio.h>
#include <strings.h>
#include <sys/errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

void cSocketsDemo(void)
{
    // We need a socket of an appropriate type.
    int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock < 0) {
        printf("socket() failed: %d", errno);
        return;
    }

    // We need to tell the sockets API who to connect to. Note here that we create a sockaddr_in: an IPv4 Internet socket type. Also note that the address and port number are in network byte order. inet_addr() does this for us, but we have to convert 80 from host byte order to network (htons = host to network short).
    struct sockaddr_in serverAddress;
    bzero(&serverAddress, 0);
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1");
    serverAddress.sin_port = htons(80);

    // Note the cast from a struct sockaddr_in * to a plain struct sockaddr *. You can turn warnings off and remove the cast, but that's not a good idea. This serves to illustrate that casting in C is something a developer does almost without thinking. It's not so straightforward in Swift.
    int error = connect(sock, (struct sockaddr *)&serverAddress, sizeof(serverAddress));
    if (error < 0) {
        printf("connect() failed: %d", errno);
        return;
    }

    // Write the request to the server.
    const char *request = "GET / HTTP/1.0\n\n";
    write(sock, request, strlen(request));

    // Read the response and print it to the console.
    size_t bytesReceived;
    do {

        char buffer[1000];
        buffer[0] = '\0';
        bytesReceived = read(sock, buffer, sizeof(buffer));
        printf("%s", buffer);

    } while (bytesReceived > 0);

    printf("\n");

    close(sock);
}
