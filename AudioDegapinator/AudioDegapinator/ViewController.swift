//
//  ViewController.swift
//  AudioDegapinator
//
//  Created by Michael Behan on 10/05/2017.
//  Copyright © 2017 Michael Behan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AudioDegapinatorUpdatesDelegate {
    
    @IBOutlet weak var timeSavedLabel: UILabel!
    
    let silenceTreshold = Float(-3.0)
    var audioPlayer : AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "gappy_file.mp3", ofType:nil)!)
        
        let audioDegapinator = AudioDegapinator(fileURL: url)
        audioDegapinator.delegate = self
        audioDegapinator.play()
    }
    
    func degapinatorSavedTime(timeSaved: TimeInterval, totalTimeSaved: TimeInterval) {
        timeSavedLabel.text = String(format: "Time saved: %.2f seconds", totalTimeSaved)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

