//
//  SignInViewController.swift
//  RandomChat
//
//  Created by Ziping Huang on 12/9/19.
//  Copyright © 2019 Ziping Huang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signIn.backgroundColor = .clear
        signIn.layer.cornerRadius = 15
        signIn.layer.borderWidth = 2
        signIn.layer.borderColor = UIColor.white.cgColor
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: Any) {
        performSegue(withIdentifier: "gotoChat", sender: nil)
    }
}
