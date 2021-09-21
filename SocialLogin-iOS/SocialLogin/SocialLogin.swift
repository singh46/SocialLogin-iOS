//
//  SocialLogin.swift
//  SocialLogin-iOS
//
//  Created by VK.
//

import Foundation


enum LoginWith : String {
    case `default`
    case google
    case facebook
    case apple
}

class SocialLogin: NSObject {
    
    let GOOGLE_CLIENT_ID = "946887587735-iupnl66i9rgbd2u93io3tpfqg1p686hu.apps.googleusercontent.com"
    public typealias success = (_ profile : SocialProfileModel) -> Void
    public typealias failure = (_ error: Error) -> Void
}

