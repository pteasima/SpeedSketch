/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The application delegate.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let driver: Driver<State, Action> = Driver(state: State(), reduce: update)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = [:]) -> Bool {

print(a.foo)

        // Minimal basic setup without a storyboard.
        let localWindow = UIWindow(frame: UIScreen.main.bounds)
        localWindow.rootViewController = CanvasMainViewController()
        localWindow.makeKeyAndVisible()
        window = localWindow
        
        return true
    }

}

// TODO: inject into View objects (if there are any objects left when im done with this)

var dispatch: (Action) -> () {
    return (UIApplication.shared.delegate as! AppDelegate).driver.dispatch
}

var state: I<State> {
    return (UIApplication.shared.delegate as! AppDelegate).driver.state
}

var globalRefs = [Any]()
