//
//  SignInViewController.swift
//  RandomChat
//
//  Created by Ziping Huang on 12/9/19.
//  Copyright © 2019 Ziping Huang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: Any) {
        performSegue(withIdentifier: "gotoChat", sender: nil)
    }
}
