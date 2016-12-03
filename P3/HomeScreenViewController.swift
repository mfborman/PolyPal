//
//  HomeScreenViewController.swift
//  P3
//
//  Created by Tony Branson on 12/3/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startMusic()//NEW

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
    
    func startMusic(){
        playMusic(filename: "Home_Screen.mp3");//NEW
    }
}
