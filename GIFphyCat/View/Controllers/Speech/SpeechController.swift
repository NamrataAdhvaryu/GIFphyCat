//
//  SpeechController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import AVFoundation
import Speech

class SpeechController: NSObject, AVSpeechSynthesizerDelegate {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    
    func pronounce(text:String)
    {
        let utterance = AVSpeechUtterance(string: text)
        
        self.speechSynthesizer.speak(utterance)
    }
    
}

