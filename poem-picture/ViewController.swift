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

    let ngrok = "https://asdfjlk.ajksl/"
    var chosenImage: UIImage! = nil
    
    @IBOutlet var imageView: UIImageView!
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
        
        imageView.image = chosenImage;
        let imageData: Data! = UIImageJPEGRepresentation(chosenImage, 0.1)
        
        
        let base64String = (imageData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        
        
        //        let binaryImageData = base64EncodeImage(#imageLiteral(resourceName: "test_image.png"))
        //        createRequest(with: binaryImageData)
        //
        
        //     do stuff with image
//        URL(String: ngrok + "?base64=" + base64String)
        var url = URL(string: ngrok + "?base64=" + base64String)
        var response = Alamofire.request(url)
        
        dismiss(animated: true, completion: nil);
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


}

