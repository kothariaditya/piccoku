//
//  FillerViewController.swift
//  poem-picture
//
//  Created by Kevin Fang on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit

class FillerViewController: UIViewController {
    var ghetto_tags = ""
    var tags = [String].init()
    var num_syllables = [Int].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = (NSArray.init() as? [String])!
        num_syllables = (NSArray.init() as? [Int])!
        
        
        let dict = convertToDictionary(text: ghetto_tags)
        
        if let same = dict!["categories"] as? NSArray{
            for x in same{
                let stringX = "\(x)"
                var same = stringX.components(separatedBy: "\"")
                var tag = same[1]
                tag = tag.replacingOccurrences(of: "_", with: "")
                tags.append(tag)
            }
        }
        
        let largest_tag = tags[0]
        getSynonyms(tag: largest_tag){(output) in
            print (output)
            let dictionary_v = self.convertToDictionary(text: output)
            print (dictionary_v)
//            if let jsonResult = try JSONSerialization.jsonObject(with:output, options: []) as? JSONDictionary {
//                print (jsonresult)
//            }
        }
//        self.performSegue(withIdentifier: "toPoem", sender: self)
        
        // Do any additional setup after loading the view.
    }
    
    func getSynonyms(tag:String, completionBlock: @escaping (String) -> Void) -> Void{
        let url = "https://api.datamuse.com/words?ml=" + tag + "&max=10&md=sp"
        
        let req = NSMutableURLRequest(url: URL(string:url)!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let stringV = String(data: data!, encoding: .utf8)!
                print ("stringV is " + stringV)
                completionBlock(stringV);
            }
        }.resume()
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
