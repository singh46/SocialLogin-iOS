//
//  AppleLoginManager.swift
//  SocialLogin-iOS
//
//  Created by VK.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: SocialLogin {
    
    fileprivate var onSuccess : success?
    fileprivate var onFailure : failure?
    fileprivate var viewController : UIViewController!

    static let shared = AppleLoginManager()
    private override init() { }
    
    func signIn(controller: UIViewController, onSuccess : @escaping success, onFailure : @escaping failure) {
        
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.viewController = controller
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.viewController.view.window!
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    
    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleLogin : error : \(error.localizedDescription)")
        self.onFailure?(error)
    }
    
    // Authorization Succeeded
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let appleUserProfile = SocialProfileModel.init(appleIdCredential: appleIDCredential)
            self.onSuccess?(appleUserProfile)
            
        case _ as ASPasswordCredential:
            let error = NSError(domain:"Encountered an authorization error", code:100, userInfo:nil)
            self.onFailure?(error)
            
        default:
            let error = NSError(domain:"Encountered an authorization error", code:100, userInfo:nil)
            self.onFailure?(error)
            break
        }
    }
}
