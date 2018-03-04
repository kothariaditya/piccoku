//
//  ViewController.swift
//  poem-picture
//
//  Created by Emily on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    let ngrok = "http://786794ad.ngrok.io/"
    var chosenImage: UIImage! = nil
    var tags:String!
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }

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
        
//        imageView.image = chosenImage;
        let imageData: Data! = UIImageJPEGRepresentation(chosenImage, 0.1)
        var dict = [String:AnyObject].init()
        same(imageData:imageData) { (output) in
//            else{
            self.tags = output
//            }
            let tags = (NSArray.init() as? [String])!
            let num_syllables = (NSArray.init() as? [Int])!
            print (self.tags)
            dict = self.convertToDictionary(text: self.tags) as! [String : AnyObject]
            var scores = (NSArray.init() as? [Float])!
        }
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.dismiss(animated: true){
                if let tags = dict["tags"] as? NSArray{
                    if(tags.count <= 3){
                            let alertController = UIAlertController(title: "Error", message: "Please retake your photo.", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "toFiller", sender: nil)
                    };
                }
            }
        }
    }
    
    // https://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    func same(imageData:Data, completionBlock: @escaping (String) -> Void) -> Void {
        var key = "ce9c64a70167498fafcdbfd3502a63fd"
        
        let urlString = "https://westus2.api.cognitive.microsoft.com/vision/v1.0/analyze?visualFeatures=tags,color&language=en"
        
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
//            print ("responsestring is " + responseString)
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
                vc.ghetto_tags = self.tags
            }
        }
    }


}

