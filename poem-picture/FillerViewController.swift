//
//  FillerViewController.swift
//  poem-picture
//
//  Created by Kevin Fang on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit

class FillerViewController: UIViewController {
    var tags = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (tags)
//        self.performSegue(withIdentifier: "toPoem", sender: self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
