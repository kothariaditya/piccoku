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

class FillerViewController: UIViewController {
    var ghetto_tags = ""
    var tags = [String].init()
    var num_syllables = [Int].init()

    override func viewDidLoad() {
        super.viewDidLoad()
        tags = (NSArray.init() as? [String])!
        num_syllables = (NSArray.init() as? [Int])!
        
        let dict = convertToDictionary(text: ghetto_tags)
        var scores = (NSArray.init() as? [Float])!
        
        if let same = dict!["tags"] as? NSArray{
            for x in same{
                let stringX = "\(x)"
                var same = stringX.components(separatedBy: "\n")
                var tag = same[2]
                var score = same[1]
                print ("tag is " + tag)
                print ("score is " + score)
//                if let match = tag.range(of: "(?<=\")[^_]+", options: .regularExpression) {
                tag = tag.components(separatedBy:"=")[1]
                
                let start = tag.index(tag.startIndex, offsetBy: 1)
                let end = tag.index(tag.endIndex, offsetBy: -1)
                let range = start..<end
                
                let new_tag = tag.substring(with: range)
                tags.append(new_tag)
                
                let isolated_score = (Float(score.components(separatedBy: ("\""))[1]))!
                scores.append(isolated_score)
                
                tag = tag.replacingOccurrences(of: "_", with: "")
            }
        }
        
        var count = 0
        var nouns = [String].init()
        
        while count < 3{
            let max_score = scores.max()
            let index = scores.index(of: max_score!)
            let tag = tags[index!]
            nouns.append(tag)
            tags.remove(at:index!)
            scores.remove(at:index!)
            count += 1
        }
        
        var largest_tag = nouns[0]
        
        
        let synonym1_url = "https://api.datamuse.com/words?ml=" + largest_tag + "&max=10&md=sp"
        
        var real_nouns = [[String]].init()
        getSynonyms(url: synonym1_url){(output) in
            let dictionary_v = self.convertToDictionary(text: output)
            
            // this is hella stupid but basically just converting the data into a readable format
            let regex = try! NSRegularExpression(pattern:"\\{(.*?)\\}", options: [])
            var results = [String]()
            
            regex.enumerateMatches(in: output, options: [], range: NSMakeRange(0, output.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: output) {
                    results.append(String(output[range]))
                }
            }
            
            var asdf = results.enumerated().flatMap { index, element in index % 3 == 2 ? nil : element }
            let stringArray = results.chunked(by: 2)
            // um better formatted i guess
            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
//                print (asdf[index])
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
            

            real_nouns = deepag
        }
        
        print (real_nouns)
        
        var adjectives = [[String]].init()
        let synonym2_url = "https://api.datamuse.com/words?rel_jjb=" + largest_tag + "&max=10&md=sp"
        getSynonyms(url: synonym2_url){(output) in
            let dictionary_v = self.convertToDictionary(text: output)
            
            // this is hella stupid but basically just converting the data into a readable format
            let regex = try! NSRegularExpression(pattern:"\\{(.*?)\\}", options: [])
            var results = [String]()
            
            regex.enumerateMatches(in: output, options: [], range: NSMakeRange(0, output.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: output) {
                    results.append(String(output[range]))
                }
            }
            
            var asdf = results.enumerated().flatMap { index, element in index % 3 == 2 ? nil : element }
            let stringArray = results.chunked(by: 2)
            // um better formatted i guess
            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
            
            adjectives = deepag
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
    
    func getSynonyms(url:String, completionBlock: @escaping (String) -> Void) -> Void{
        
        let req = NSMutableURLRequest(url: URL(string:url)!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let stringV = String(data: data!, encoding: .utf8)!
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
