//
//  HomeScreenViewController.swift
//  P3
//
//  Created by Tony Branson on 12/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBAction func clearData(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "loggedIn")
        defaults.set("", forKey: "textTest")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic(filename: "Home_Screenn.mp3");//NEW
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
