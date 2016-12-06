//
//  LoginViewController.swift
//  P3
//
//  Created by Mitchell Borman on 12/6/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var parentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "loggedIn") == true {
            print(defaults.string(forKey: "textTest"))
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
            self.present(destinationVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSubmissionSegue") {
            //let homeScreenVC = (segue.destination as! HomeScreenViewController)
            let textBoxText = self.parentTextField.text
            let defaults = UserDefaults.standard
            defaults.set(textBoxText, forKey: "textTest")
            defaults.set(true, forKey: "loggedIn")
            defaults.synchronize()
        }
    }
}
