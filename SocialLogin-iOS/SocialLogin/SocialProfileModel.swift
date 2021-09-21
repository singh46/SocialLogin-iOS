//
//  SocialProfileModel.swift
//  SocialLogin-iOS
//
//  Created by VK.
//

import Foundation
import GoogleSignIn
import AuthenticationServices

struct SocialProfileModel
{
    var userId : String?
    var idToken : String?
    var name : String?
    var email : String?
    var picUrl : String?
    var loginSuccess : Bool = false
    var loginWith : LoginWith?
    
    init(loggedIn: Bool) {
        self.loginSuccess = loggedIn
    }
    
    // Parse google siginIn
    init(user : GIDGoogleUser) {
        userId = user.userID // Safe to send to the server
        idToken = user.authentication.idToken // Safe to send to the server
        name = user.profile.name
        email = user.profile.email
        let dimension = round(100 * UIScreen.main.scale)
        picUrl = user.profile.imageURL(withDimension: UInt(dimension))?.absoluteString
        self.loginSuccess = true
        self.loginWith = .google
    }
    
    @available(iOS 13.0, *)
    // Parse apple siginIn
    init(appleIdCredential :ASAuthorizationAppleIDCredential){
        self.userId = appleIdCredential.user
        if let fullName = appleIdCredential.fullName  {
            self.name = (fullName.givenName ?? "") + " " + (fullName.familyName ?? "")
        }
        if let appleEmail = appleIdCredential.email {
            self.email = appleEmail
        }else {
            self.email = "\(appleIdCredential.user)@apple.com"
        }
        self.loginSuccess = true
        self.loginWith = .apple
    }
    
    // Parse Facebook SiginIn
    init(result : [String : Any]?) {
        self.loginSuccess = true
        self.userId = result?["id"] as? String
        self.name = result?["name"] as? String
        self.email = result?["email"] as? String
        if let thumbUrl = ((result?["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
            self.picUrl = thumbUrl
        }
        self.loginWith = .facebook
    }
}
