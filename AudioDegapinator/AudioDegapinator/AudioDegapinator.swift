//
//  AudioDegapinator.swift
//  AudioDegapinator
//
//  Created by Michael Behan on 10/05/2017.
//  Copyright © 2017 Michael Behan. All rights reserved.
//

import AVFoundation

protocol AudioDegapinatorUpdatesDelegate: class {
    func degapinatorSavedTime(_: TimeInterval, totalTimeSaved: TimeInterval)
}

class AudioDegapinator: NSObject, AVAudioPlayerDelegate {
    
    let audioPlayer: AVAudioPlayer
    private var timer: Timer?
    private let silenceTreshold = Float(0.05)
    private let normalSpeed = 1.0
    private let maxSpeed = 2.0
    
    weak var delegate : AudioDegapinatorUpdatesDelegate?
    
    init(fileURL: URL) {
        audioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
        audioPlayer.isMeteringEnabled = true
        audioPlayer.enableRate = true
        
        super.init()
        audioPlayer.delegate = self
    }
    
    func play() {
        audioPlayer.play()
        
        let numChannels = audioPlayer.numberOfChannels
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            self.audioPlayer.updateMeters()
            
            var averageAveragePower = Float(0.0)
            for i in 0 ..< numChannels {
                averageAveragePower += pow(10, (0.05 * self.audioPlayer.averagePower(forChannel:i)))
            }
            averageAveragePower /= Float(numChannels)
            
            if averageAveragePower < self.silenceTreshold {
                self.changeAudioPlayerRate(self.maxSpeed)
            } else {
                self.changeAudioPlayerRate(self.normalSpeed)
            }
        }
    }
    
    private var beganDegapination = 0.0
    private(set) var timeSaved = 0.0
    
    private func changeAudioPlayerRate(_ rate: Double) {
        if self.audioPlayer.rate == Float(rate) {
            return
        }
        
        if rate == 2.0 {
            beganDegapination = CACurrentMediaTime()
        } else if rate == 1.0 {
            let diff = CACurrentMediaTime() - beganDegapination
            let newTimeSaving = diff / 2.0
            timeSaved += newTimeSaving
            
            delegate?.degapinatorSavedTime(newTimeSaving, totalTimeSaved: timeSaved)
        }
        
        self.audioPlayer.rate = Float(rate)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    // MARK: - AVAudioPlayerDelegate funcs
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        timer = nil
    }
}
