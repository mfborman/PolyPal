//
//  SelectMatchingGameViewController.swift
//  P3
//
//  Created by Mitchell Borman on 12/4/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit

class SelectMatchingGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "6by6MatchingGame") {
            let matchingGameVC = (segue.destination as! MatchingGameViewController)
            matchingGameVC.boardSize6by6 = true
            
        } else if (segue.identifier == "4by4MatchingGame") {
            let matchingGameVC = (segue.destination as! MatchingGameViewController)
            matchingGameVC.boardSize6by6 = false
        }
    }
    
    

}
