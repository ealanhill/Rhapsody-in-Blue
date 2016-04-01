//
//  ViewController.swift
//  Rhapsody in Blue
//
//  Created by E Alan Hill on 3/31/16.
//  Copyright © 2016 619 Fitness. All rights reserved.
//

import UIKit
import AVFoundation // audio vision foundation kit for videos and audio players

class ViewController: UIViewController {

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    var player: AVAudioPlayer = AVAudioPlayer()
    var timer:NSTimer! = nil
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define the path of the file we want to play by grabbing the main bundle of the app and searching
        // for the file we want to use
        let audioPath = NSBundle.mainBundle().pathForResource("gershwin-rhapsodyinblue-bertoli", ofType: "mp3")!
        
        durationLabel.text = "00:00"
        currentTimeLabel.text = "00:00"
        
        // the player can throw an error, so try it
        do {
            // add the file to the player
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            
            durationLabel.text = getTime(player.duration)
            
            // set the minimum time of the progress bar to 0, obvious
            progressSlider.minimumValue = 0
            
            // set the maximum time of the progress bar to the total duration fo the audio file
            progressSlider.maximumValue = Float(player.duration)
        } catch {
            // process error
            print("Received an error while attempting to open the audio file at \(audioPath)")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // stop the player
        player.stop()
        
        // stop updating the slider
        timer.invalidate()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pause(sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func play(sender: AnyObject) {
        // create a new timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updatePlayTime), userInfo: nil, repeats: true)
        // start playing the song
        player.play()
        // update the slider
        //updatePlayTime()
    }
    
    /// Updates the slider and the text label with the current position of the song
    func updatePlayTime() {
        // set the position of the slider to the current position in the song
        progressSlider.setValue(Float(player.currentTime), animated: true)
        
        // update our current time in the song
        currentTimeLabel.text = getTime(player.currentTime)
    }
    
    @IBAction func stop(sender: AnyObject) {
        // stop the player and reset the current time to 0
        player.stop()
        player.currentTime = 0
        // stop the timer
        timer.invalidate()
        
        // update the slider
        updatePlayTime()
    }
    
    @IBAction func changeVolume(sender: AnyObject) {
        // the volume is a value from 0 to 1, 0 being muted, and 1 the max volume
        player.volume = volumeSlider.value
    }
    
    /// changes the position of the progress bar
    @IBAction func changeProgress(sender: AnyObject) {
        // set the current time of the player to where we are on the slider
        player.currentTime = NSTimeInterval(round(progressSlider.value))
        updatePlayTime()
    }
    
    /// gets a string representing the time interval
    func getTime(time: NSTimeInterval) -> String {
        let interval = NSInteger(time)
        
        let seconds = interval % 60
        let minutes = (interval/60) % 60
        let hours = (interval / 3600)
        
        var toReturn:String = ""
        
        if hours == 0 {
            toReturn = String(format: "%0.2d:%0.2d", minutes, seconds)
        } else {
            toReturn = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }
        
        return toReturn
    }
}

