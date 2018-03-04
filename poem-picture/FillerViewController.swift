//
//  FillerViewController.swift
//  poem-picture
//
//  Created by Kevin Fang on 3/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
import Foundation
//import SwiftyJSON

class FillerViewController: UIViewController {
    var ghetto_tags = ""
    var tags = [String].init()
    var num_syllables = [Int].init()
    var color = ""
    var color_syllables = 0
    var adverb = ""
    var adverb_count = 0
    var tag_count = 0
    var entire_poem = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tags = (NSArray.init() as? [String])!
        num_syllables = (NSArray.init() as? [Int])!
        
        let dict = convertToDictionary(text: ghetto_tags)
        var scores = (NSArray.init() as? [Float])!
        
        if let tags = dict!["tags"] as? NSArray{
            if(tags.count <= 3){
                //TODO: emily make this retake please -- lmao it's still cut
                self.performSegue(withIdentifier: "unwind", sender: self)
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
        if let color2 = color!["dominantColorForeground"] as? String{
            backgroundColor = color2
        }
        else if let color3 = color!["dominantColorBackground"] as? String{
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
        
        let url6 = "https://wordsapiv1.p.mashape.com/words/" + largest_tag + "/syllables"
        
        var request2 = URLRequest(url: URL(string: url6)!)
        request2.httpMethod = "GET"
        request2.addValue("ro0dDrnSoImshe5xvMpPE7Mej0Nrp1ZoiaqjsnqjCNCqti4mXN", forHTTPHeaderField: "X-Mashape-Key")
        request2.addValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "wordsapiv1.p.mashape.com")
        
        let session2 = URLSession.shared
        
        session2.dataTask(with: request2) {data, response, err in
            let responseString = String(data: data!, encoding: .utf8)!
            let dict = self.convertToDictionary(text: responseString)
            if let syllables = dict!["syllables"] as? [String:AnyObject]{
                if let count = syllables["count"] as? Int{
                    self.tag_count = count
                }
            }
            }.resume()
        
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
        
        session.dataTask(with: request) {data, response, err in
            let responseString = String(data: data!, encoding: .utf8)!
            let dict = self.convertToDictionary(text: responseString)
            if let syllables = dict!["syllables"] as? [String:AnyObject]{
                if let count = syllables["count"] as? Int{
                    self.color_syllables = count
                }
            }
            }.resume()

        
        var adjectives = [[String]].init()
        let synonym2_url = "https://api.datamuse.com/words?rel_jjb=" + largest_tag + "&max=10&md=sp"
        
        getSynonyms(url: synonym2_url){(output) in
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
        let synonym3_url = "https://api.datamuse.com/words?rel_jjb=" + largest_tag + "&topics=beautiful&max=20&md=sp"
        
        getSynonyms(url: synonym3_url){(output) in
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
            
            self.makeHaiku(tag:largest_tag, real_nouns: real_nouns, adjectives: adjectives,artsy:artsy_adjectives, color:backgroundColor)
        }
        
        var ad_verb = [String].init()
        var ad_verb_syllables = [Int].init()
        
        let synonym5_url = "https://api.datamuse.com/words?rel_jjb=" + largest_tag + "&topics=beautiful&max=20&md=sp"
        
        getSynonyms(url: synonym5_url){(output) in
            let regex = try! NSRegularExpression(pattern:"\\{(.*?)\\}", options: [])
            var results = [String]()
            
            regex.enumerateMatches(in: output, options: [], range: NSMakeRange(0, output.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: output) {
                    results.append(String(output[range]))
                }
            }
            
            var asdf = results.enumerated().flatMap { index, element in index % 3 == 2 ? nil : element }
            
            var deepag: [[String]] = []
            for (index, str) in asdf.enumerated() {
                asdf[index] = str.replacingOccurrences(of: "\"", with: "")
                
                let word = asdf[index].components(separatedBy: ",")[0].components(separatedBy:":")[1]
                
                let num_syllables = Int(String(Array(asdf[index].components(separatedBy: "numSyllables:")[1])[0]))
                
                let all_pos = asdf[index].components(separatedBy: "tags:[")[1].replacingOccurrences(of: "]", with: "")
                
                if (all_pos.range(of: "adv") != nil) || (all_pos.range(of:"v") != nil)  {
                    ad_verb.append(word)
                    ad_verb_syllables.append(num_syllables!)
                }
                
                deepag.append([asdf[index].components(separatedBy: ",")[0], asdf[index].components(separatedBy: ",")[2]])
            }
            if(self.adverb.count > 0){
                self.adverb = ad_verb[0]
                self.adverb_count = ad_verb_syllables[0]
            }
            else{
                self.adverb = "good"
                self.adverb_count = 1
            }
            
            self.makeHaiku(tag:largest_tag, real_nouns: real_nouns, adjectives: adjectives,artsy:artsy_adjectives, color:backgroundColor)
        }
//        self.performSegue(withIdentifier: "toPoem", sender: self)
        // Do any additional setup after loading the view.
    }
    
    func makeHaiku(tag:String, real_nouns:[[String]], adjectives:[[String]], artsy:[[String]], color:String){
        let first_line = firstLine(real_nouns:real_nouns, adjectives:adjectives)
        let second_line = secondLine(adjectives:adjectives, artsy:artsy, color:color)
        let third_line = thirdLine(tag:tag, adjectives:adjectives)
        entire_poem += first_line + "\n" + second_line + "\n" + third_line
        print ("SDLKAFSDJLKFALJKFADS" + entire_poem)
        self.performSegue(withIdentifier: "toPoem", sender: nil)
    }

    func firstLine(real_nouns:[[String]], adjectives:[[String]]) -> String{
        var remaining_syllables = 5
        var first_line = ""
        
        let first_word_word = real_nouns[0][0].components(separatedBy: ":")
        let first_word_syllable = real_nouns[0][1].components(separatedBy: ":")
        
        let first_noun = first_word_word[1]
        let first_syllable = Int(first_word_syllable[1])
        remaining_syllables -= first_syllable!
        
        var index = 1
        while remaining_syllables > 0{
            let x = adjectives[index]
            let num_syllable:Int = getSyllable(data:x)
            let adjective = getWord(data:x)
            if(remaining_syllables - num_syllable >= 0){
                first_line += adjective + " "
                remaining_syllables -= num_syllable
            }
            
            index += 1
        }
        first_line += first_noun
        
//        for x in adjectives{
//            let num_syllable:Int = getSyllable(data:x)
//
//            if(first_line_count - first_syllable! == num_syllable){
//                first_adjective = getWord(data:x)
//                break
//            }
//        }
//
//        let first_line = first_adjective + " " + first_noun
        
        return first_line
    }
    
    func secondLine(adjectives:[[String]], artsy:[[String]], color:String) -> String{
        var remaining_syllables = 7
        var second_line = "The "
        
        let color = color
        second_line += color + " "
        
        remaining_syllables -= color_syllables
        
        let artsy_word = artsy[0][0].components(separatedBy: ":")[1]
        
        second_line += artsy_word + " "
        
        let artsy_syllables = Int(artsy[0][1].components(separatedBy: ":")[1])
        remaining_syllables -= artsy_syllables!
        
        var index = 1
        while remaining_syllables > 0{
            let x = artsy[index]
            let num_syllable:Int = getSyllable(data:x)
            let adjective = getWord(data:x)
            if(remaining_syllables - num_syllable >= 0){
                second_line += adjective + " "
                remaining_syllables -= num_syllable
            }
            
            index += 1
        }
        
        return second_line
    }
    
    func thirdLine(tag:String, adjectives:[[String]]) -> String{
        let total_syllables = 5
        
        var third_line = ""
        let remaining_syllables = 5
        
        third_line += tag
        third_line += " is " + adverb
        


        return third_line
    }
    
    func getWord(data:[String]) -> String{
        let first_adjective = data[0].components(separatedBy:":")[1]
        return first_adjective
    }
    
    func getSyllable(data:[String]) -> Int{
        let num_syllables = Int(data[1].components(separatedBy: ":")[1])
        return num_syllables!
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
        if(segue.identifier == "toPoem"){
            var same = segue.destination as? PoemViewController
            same?.poem = self.entire_poem
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
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
