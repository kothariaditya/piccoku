//
//  FillerViewController.swift
//  poem-picture
//
//  Created by Kevin Fang on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

var wordInfo: [[String]]!

class FillerViewController: UIViewController {
    var ghetto_tags = ""
    var tags = [String].init()
    var num_syllables = [Int].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = (NSArray.init() as? [String])!
        num_syllables = (NSArray.init() as? [Int])!
        
        
        let dict = convertToDictionary(text: ghetto_tags)
        
        print(dict)
        print(ghetto_tags)
        print(JSON(ghetto_tags))
        
        if let same = dict!["categories"] as? NSArray{
            for x in same{
                let stringX = "\(x)"
                print(stringX)
                var same = stringX.components(separatedBy: "\n")
                print(same)
                var tag = same[1]
                if let match = same[1].range(of: "(?<=\")[^_]+", options: .regularExpression) {
                    print(same[1].substring(with: match))
                    tags.append(same[1].substring(with: match))
                }
                tag = tag.replacingOccurrences(of: "_", with: "")
                print(tag)
//                tags.append(tag)
            }
        }
        
        let largest_tag = tags[0]
        print(largest_tag)
        getSynonyms(tag: largest_tag){(output) in
            print (output)
            print("asdf")
            print(JSON(output))
            let dictionary_v = self.convertToDictionary(text: output)
            print (dictionary_v)
            print("---nani")
            for word in output {
                print(word)
            }
            
            // this is hella stupid but basically just converting the data into a readable format
            let regex = try! NSRegularExpression(pattern:"\\{(.*?)\\}", options: [])
            var results = [String]()
            
            regex.enumerateMatches(in: output, options: [], range: NSMakeRange(0, output.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: output) {
                    results.append(String(output[range]))
                }
            }
            
            print(results) // ["test", "test1"]
            var asdf = results.enumerated().flatMap { index, element in index % 3 == 2 ? nil : element }
            let stringArray = results.chunked(by: 2)
//            let asdf = stringArray.enumerated().flatMap { index, element in index % 3 == 2 ? nil : element }
            print(asdf)
            // um better formatted i guess
            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
//            var deepag: [[String]]
            print("---")
            print(deepag)
            wordInfo = deepag
        }
//        self.performSegue(withIdentifier: "toPoem", sender: self)
        
        // Do any additional setup after loading the view.
    }
    func find(inText text: String, pattern: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.matches(in: text, options: .init(rawValue: 0), range: NSRange(location: 0, length: text.count))
            
            let matches = result.map { result in
                return (text as NSString).substring(with: result.range)
            }
            
            return matches
        } catch {
            print(error)
        }
        return nil
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
                print(JSON(stringV))
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

extension Array {
    
    func chunked(by distance: IndexDistance) -> [[Element]] {
        let indicesSequence = stride(from: startIndex, to: endIndex, by: distance)
        let array: [[Element]] = indicesSequence.map {
            let newIndex = $0.advanced(by: distance) > endIndex ? endIndex : $0.advanced(by: distance)
            //let newIndex = self.index($0, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex // also works
            return Array(self[$0 ..< newIndex])
        }
        return array
    }
    
}
