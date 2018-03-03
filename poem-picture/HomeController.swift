//
//  File.swift
//  poem-picture
//
//  Created by Emily on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import UIKit

let image = nil;

class HomeController: ViewController {
    @IBAction func start(_ sender: Any) {
//        if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
//                let alertController = UIAlertController(title: "Error", message: "Please turn your device horizontallly.", preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//        }
//            else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let ivc = storyboard.instantiateViewController(withIdentifier: "picture");
            ivc.modalPresentationStyle = .custom;
            ivc.modalTransitionStyle = .crossDissolve;
            self.present(ivc, animated: true);
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
