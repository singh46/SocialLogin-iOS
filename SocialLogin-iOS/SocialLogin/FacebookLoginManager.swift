//
//  FacebookLoginManager.swift
//  SocialLogin-iOS
//
//  Created by VK.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookLoginManager: SocialLogin {
    
    static let shared = FacebookLoginManager()
    private override init() { }
    
    func login(vc : UIViewController, onSuccess : @escaping success,  onFailure : @escaping failure) {
        
        if AccessToken.current != nil {
            
            self.requestGraphAPI { (profile) in
                onSuccess(profile)
            } onFailure: { (error) in
                onFailure(error)
            }
        }else{
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [.publicProfile, .email], viewController: vc) { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print("FacebookLogin Error : \(error.localizedDescription)")
                    onFailure(error)
                case .cancelled:
                    print("FacebookLogin : User cancelled login.")
                    let error = NSError(domain:"User cancelled login", code:100, userInfo:nil)
                    onFailure(error)
                case .success( _, _, _):
                    print("FacebookLogin : Logged in success")
                    
                    self.requestGraphAPI { (profile) in
                        onSuccess(profile)
                    } onFailure: { (error) in
                        onFailure(error)
                    }
                }
            }
        }
    }
    
    fileprivate func requestGraphAPI(onSuccess : @escaping success,  onFailure : @escaping failure)
    {
        let connection = GraphRequestConnection()
        connection.add(getGraphRequest(), completionHandler: { ( response , result, error) in
            print("FacebookLogin : Facebook login response \(String(describing: response))  result \(String(describing: result))")
            
            if let error = error {
                onFailure(error)
            }else{
                let profile = SocialProfileModel.init(result: result as? [String : Any])
                onSuccess(profile)
            }
        })
        connection.start()
    }    
    
    fileprivate func getGraphRequest() -> GraphRequest
    {
        let graphPath = "/me"
        let parameters: [String : Any] = ["fields": "id, name,email,picture.type(large)"]
        let accessToken = AccessToken.current?.tokenString ?? ""
        let request = GraphRequest.init(graphPath: graphPath, parameters: parameters, tokenString: accessToken, version: .none, httpMethod: .get)
        return request
    }
    
    func logout() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
}
