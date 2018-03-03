//
//  ViewController.swift
//  poem-picture
//
//  Created by Emily on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    let ngrok = "http://786794ad.ngrok.io/"
    var chosenImage: UIImage! = nil
    var tags:String!
    
    @IBOutlet var imageView: UIImageView!
    //    @IBOutlet var imageView: UIImageView!
    @IBAction func takePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.allowsEditing = true;
        self.present(imagePicker, animated: true, completion: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var imagePicker: UIImagePickerController!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        image = chosenImage
        
        imageView.image = chosenImage;
        let imageData: Data! = UIImageJPEGRepresentation(chosenImage, 0.1)

        same(imageData:imageData) { (output) in
            self.tags = output
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            self.dismiss(animated: true){
                self.performSegue(withIdentifier: "toFiller", sender: nil)
            };
        }

        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let ivc = storyboard.instantiateViewController(withIdentifier: "filler-processing");
//        ivc.modalPresentationStyle = .custom;
//        ivc.modalTransitionStyle = .crossDissolve;
//        self.present(ivc, animated: true);
        
    }
    
    func same(imageData:Data, completionBlock: @escaping (String) -> Void) -> Void {
        var key = "ce9c64a70167498fafcdbfd3502a63fd"
        let urlString = "https://westus2.api.cognitive.microsoft.com/vision/v1.0/analyze?visualFeatures=Categories&language=en"
        print (urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        let postString = imageData
        request.httpBody = postString
        
        var responseString = ""
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            responseString = String(data: data, encoding: .utf8)!
            completionBlock(responseString);
        }
        task.resume()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toFiller"){
            if let vc = segue.destination as? FillerViewController{
                vc.tags = self.tags
            }
        }
    }


}

