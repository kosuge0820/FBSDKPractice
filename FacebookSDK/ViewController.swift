//
//  ViewController.swift
//  FacebookSDK
//
//  Created by 小菅仁士 on 2016/04/18.
//  Copyright © 2016年 kosuge satoshi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var customButton: UIButton!
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeFacebookButton()
        makeCustomButton()
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard error == nil else {
            print("Error: \(error)")
            return
        }
        
        if result.isCancelled {
            print("Cancelled");
            
        } else {
            print("Logged in");
            getUserData()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logout");
    }
    
    func makeFacebookButton(){
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self

        view.addSubview(loginButton)
    }
    
    func makeCustomButton(){
        let customButton = UIButton(type: .System)
        customButton.setTitle("My Login Button", forState: .Normal)
        customButton.addTarget(self, action: #selector(ViewController.loginButton_Clicked), forControlEvents: .TouchUpInside)
        customButton.frame = CGRectMake(0,0,180,80)
        customButton.center = view.center
        customButton.center.y += 40
        view.addSubview(customButton)
    }
    
    func loginButton_Clicked(){
        let loginManager = FBSDKLoginManager()
            if !isLogin {
                loginManager.logInWithReadPermissions(["public_profile"], fromViewController: self) { (result , error) in
                    guard error == nil else {
                        print("Process error");
                        return
                    }
                    
                    if result.isCancelled {
                        print("Canceled");
                    } else {
                        print("Logged in");
                        self.getUserData()

                    }
                }
            } else {
                loginManager.logOut()
                customButton.setTitle("My Login Button", forState: .Normal)
            }
        self.isLogin = !self.isLogin
    }
    
    func getUserData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me",
                                             parameters: ["fields": "id,name"])
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) in
            guard error == nil && result != nil else{
                print("Error: \(error)")
                return
            }
            
            print("User: \(result)")
        })
    }
}

