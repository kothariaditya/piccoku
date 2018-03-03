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
    var color = ""
    var color_syllables = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tags = (NSArray.init() as? [String])!
        num_syllables = (NSArray.init() as? [Int])!
        
        let dict = convertToDictionary(text: ghetto_tags)
        var scores = (NSArray.init() as? [Float])!
        
        if let tags = dict!["tags"] as? NSArray{
            if(tags.count <= 3){
                //TODO: emily make this retake please
            }
        }
        
        if let same = dict!["tags"] as? NSArray{
            for x in same{
                let stringX = "\(x)"
                var same = stringX.components(separatedBy: "\n")
                var tag = same[2]
                var score = same[1]
                
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
        var color = (dict!["color"])! as? [String:AnyObject]
        var backgroundColor = ""
        if let color2 = color!["dominantColorBackground"] as? String{
            backgroundColor = color2
        }
        else if let color3 = color!["dominantColorForeground"] as? String{
            backgroundColor = color3
        }
        
        
        var count = 0
        var nouns = [String].init()
        if(scores.count >= 3){
            while count < 3{
                let max_score = scores.max()
                let index = scores.index(of: max_score!)
                let tag = tags[index!]
                nouns.append(tag)
                tags.remove(at:index!)
                scores.remove(at:index!)
                count += 1
            }
        }
        else{
            nouns = tags
        }
        
        
        var largest_tag = nouns[0]
        
        
        let synonym1_url = "https://api.datamuse.com/words?ml=" + largest_tag + "&max=10&md=sp"
        
        var real_nouns = [[String]].init()
        getSynonyms(url: synonym1_url){(output) in
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
            
            real_nouns = deepag
        }
        
        let synonym4_url = "https://api.datamuse.com/words?ml=" + backgroundColor + "&max=5&md=sp"
        
        
        let url4 = "https://wordsapiv1.p.mashape.com/words/" + backgroundColor + "/syllables"
        
        var request = URLRequest(url: URL(string: url4)!)
        request.httpMethod = "GET"
        request.addValue("ro0dDrnSoImshe5xvMpPE7Mej0Nrp1ZoiaqjsnqjCNCqti4mXN", forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "wordsapiv1.p.mashape.com")
        
        let session = URLSession.shared
        var color_syllables = 0
        
        session.dataTask(with: request) {data, response, err in
            let responseString = String(data: data!, encoding: .utf8)!
            let dict = self.convertToDictionary(text: responseString)
            if let syllables = dict!["syllables"] as? [String:AnyObject]{
                if let count = syllables["count"] as? Int{
                    color_syllables = count
                }
            }
            }.resume()

        
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

            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
            
            adjectives = deepag
        }

        
        var artsy_adjectives = [[String]].init()
        let synonym3_url = "https://api.datamuse.com/words?rel_jjb=" + largest_tag + "&topics=beautiful&max=10&md=sp"
        
        getSynonyms(url: synonym3_url){(output) in
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
            
            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
            
            artsy_adjectives = deepag
            
            print ("artsy adjectives are ---")
            print (artsy_adjectives)
            
            self.makeHaiku(tag:largest_tag, real_nouns: real_nouns, adjectives: adjectives,artsy:artsy_adjectives, color:backgroundColor)
        }
//        self.performSegue(withIdentifier: "toPoem", sender: self)
        // Do any additional setup after loading the view.
    }
    
    func getSyllable(url:String){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("", forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "wordsapiv1.p.mashape.com")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            let responseString = String(data: data!, encoding: .utf8)!
            let dict = self.convertToDictionary(text: responseString)
            if let syllables = dict!["syllables"] as? [String:AnyObject]{
                if let count = syllables["count"] as? Int{
                    self.color_syllables = count
                }
            }
            }.resume()
    }
    
    func makeHaiku(tag:String, real_nouns:[[String]], adjectives:[[String]], artsy:[[String]], color:String){
        let third_line_count = 5
        
        let first_line = firstLine(real_nouns:real_nouns, adjectives:adjectives)
        print (first_line)
        let second_line = secondLine(adjectives:adjectives, artsy:artsy, color:color)
        print (second_line)
    }
    
    func getWord(data:[String]) -> String{
        let first_adjective = data[0].components(separatedBy:":")[1]
        return first_adjective
    }
    
    func getSyllable(data:[String]) -> Int{
        let num_syllables = Int(data[1].components(separatedBy: ":")[1])
        return num_syllables!
    }
    
    func firstLine(real_nouns:[[String]], adjectives:[[String]]) -> String{
        let first_line_count = 5
        let first_word_word = real_nouns[0][0].components(separatedBy: ":")
        let first_word_syllable = real_nouns[0][1].components(separatedBy: ":")
        
        let first_noun = first_word_word[1]
        let first_syllable = Int(first_word_syllable[1])
        
        var first_adjective = ""
        
        for x in adjectives{
            let num_syllable:Int = getSyllable(data:x)

            if(first_line_count - first_syllable! == num_syllable){
                first_adjective = getWord(data:x)
                break
            }
        }
        print (first_adjective, first_noun)
        let first_line = first_adjective + " " + first_noun + "\n"
        
        return first_line
    }
    
    func secondLine(adjectives:[[String]], artsy:[[String]], color:String) -> String{
        let second_line_count = 7
        var syllable_current = 0
        
        let color = color
        syllable_current += color_syllables
        
        let artsy_word = artsy[0][0].components(separatedBy: ":")[1]
        let artsy_syllables = Int(artsy[0][1].components(separatedBy: ":")[1])
        syllable_current += artsy_syllables!
        
        
        
        print ("artsyword is " + artsy_word)
        
        
        return "X"
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
