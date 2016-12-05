//
//  SelectAlphabetGameViewController.swift
//  P3
//
//  Created by Mitchell Borman on 12/5/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit

class SelectAlphabetGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segueToLetterGame") {
            let matchingGameVC = (segue.destination as! AlphabetGameViewController)
            
        } else if (segue.identifier == "segueToNumberGame") {
            let matchingGameVC = (segue.destination as! AlphabetGameViewController)
        }
    }
    

}
