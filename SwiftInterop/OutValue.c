//
//  OutValue.c
//  SwiftInterop
//
//  Created by Steve Madsen on 8/7/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

void outValue(int *outValue)
{
    *outValue = 42;
}

int sumArray(int *array, int count)
{
    int sum = 0;
    while (count-- > 0) {
        sum += *array;
        array++;
    }

    return sum;
}
