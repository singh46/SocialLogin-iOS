//
//  GoogleLoginManager.swift
//  SocialLogin-iOS
//
//  Created by VK.
//

import Foundation
import GoogleSignIn

class GoogleLoginManager: SocialLogin {
    
    fileprivate var onSuccess : success?
    fileprivate var onFailure : failure?
    
    static let shared = GoogleLoginManager()
    private override init() { }
    
    func signIn(controller: UIViewController, onSuccess : @escaping success, onFailure : @escaping failure) {
        
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().presentingViewController = controller
        GIDSignIn.sharedInstance().signIn()
        
        // Automatically sign in the user.
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
}

extension GoogleLoginManager : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }
            else if (error as NSError).code == GIDSignInErrorCode.canceled.rawValue {
                print("user canceled the sign in request")
            }
            else {
                print("\(error.localizedDescription)")
            }
            self.onFailure?(error)
            return
        }
        var profile =  SocialProfileModel.init(user: user)
        profile.loginSuccess = true
        self.onSuccess?(profile)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("GIDSignIn : didDisconnectWith")
        
    }
}
