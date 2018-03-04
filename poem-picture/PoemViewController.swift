//
//  PoemViewController.swift
//  poem-picture
//
//  Created by Kevin Fang on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit

class PoemViewController: UIViewController {
    var poem:String!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var poemview: UITextView!

    @IBAction func retake(_ sender: Any) {
        self.performSegue(withIdentifier: "retake", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        poemview.text = poem
        imageView.image = image
        
        let imageData: Data! = UIImageJPEGRepresentation(image, 0.1)
        
        var base64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        base64 = base64.replacingOccurrences(of: "+", with: "%2b")
        print (base64)
        
        let lines = poem.components(separatedBy: "\n")

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://ancient-plateau-48847.herokuapp.com/images/create")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "url=" + base64 + "&name=" + username + "&line1=" + lines[0] + "&line2=" + lines[1] + "&line3=" + lines[2]
//        print (postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
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
