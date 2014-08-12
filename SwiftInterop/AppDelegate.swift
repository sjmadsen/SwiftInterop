//
//  AppDelegate.swift
//  SwiftInterop
//
//  Created by Steve Madsen on 7/5/14.
//  Copyright (c) 2014 Light Year Software, LLC. All rights reserved.
//

import UIKit
import Darwin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController = UIViewController()

        // Passing a pointer to a simple integer type is very C-like, with the exception that Swift is strict about the pointed-to variable being initialized with a value before it is used.
        var myInt: Int32 = 0
        outValue(&myInt)
        println(myInt)

        // Passing a pointer to an array looks a little odd for seasoned C developers. In C, a pointer to an array is the array itself, without indexing to an element. In Swift, passing that array into a C function still requires the in-out & operator.

        // It's very interesting that although this is a Swift array, it's laid out in memory exactly as we're used to from C, even though we can do more advanced operations with Swift arrays, such as adding elements to the end and extending their length.
        var array: [Int32] = [1, 2, 3]
        var sum = sumArray(&array, 3)
        println(sum)

        // Uncomment to run the associated demo code.

//        cSocketsDemo()
//        socketsDemo()

//        zlibDemo()

        return true
    }

}

