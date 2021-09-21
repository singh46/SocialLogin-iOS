//
//  ViewController.swift
//  SocialLogin-iOS
//
//  Created by VK
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Button action
    @IBAction func facebookButtonAction(_ sender: Any) {
        
        FacebookLoginManager.shared.login(vc: self) { (profile) in
            print("FacebookLogin profile : \(String(describing: profile.name)), \(String(describing: profile.email))")
        } onFailure: { (error) in
            print("FacebookLogin error : \(String(describing: error.localizedDescription))")
        }
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        
        GoogleLoginManager.shared.signIn(controller: self) { (profile) in
            print("GoogleLogin profile : \(String(describing: profile.name)), \(String(describing: profile.email))")
        } onFailure: { (error) in
            print("GoogleLogin error : \(String(describing: error.localizedDescription))")
        }
    }
    
    
    @IBAction func appleButtonAction(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            
            AppleLoginManager.shared.signIn(controller: self) { (profile) in
                print("AppleLogin profile : \(String(describing: profile.name)), \(String(describing: profile.email))")
            } onFailure: { (error) in
                print("AppleLogin error : \(String(describing: error.localizedDescription))")
            }
        }
    }
}

