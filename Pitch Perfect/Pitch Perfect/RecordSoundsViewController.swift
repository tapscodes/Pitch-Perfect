//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tristan Pudell-Spatscheck on 10/21/18.
//  Copyright © 2018 TAPS. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Variables
    var audioRecorder: AVAudioRecorder!

    //outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
    }
    
    //changes state from recording to not recording
    func changeButtonState(enabled: Bool){
        if enabled {
        recordingLabel.text = "Recording in progress"
        }
        else {
        recordingLabel.text="Tap to Record"
        }
        stopRecordingButton.isEnabled = enabled
        recordingButton.isEnabled = !enabled
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Recorder
    //records original audio clip
    @IBAction func recordAudio(_ sender: Any) {
        changeButtonState(enabled: true)
        //let statements
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        //try statements
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //stops recording audio clip and stores it
    @IBAction func stopRecording(_ sender: Any) {
        changeButtonState(enabled: false)
        audioRecorder.stop()
        let audioSession=AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Could remove else: simply checks if audio finished recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording was not successful")
        }
    }
    
    // MARK: Ending
    //prepares the audio file to be transfarred to PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundsVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL=sender as! URL
            playSoundsVC.recordedAudioURL=recordedAudioURL
        }
    }
}

