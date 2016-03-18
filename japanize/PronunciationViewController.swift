//
//  PronunciationViewController.swift
//  japanize
//
//  Created by Dylan Smith on 3/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import AVFoundation

class PronunciationViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var wordLabel: UILabel! // make a button to grab new word
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    let tempAudioFile = "japanize.caf"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupRecorder() {
        let recordSettings = [
            AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
            AVNumberOfChannelsKey : NSNumber(int: 2),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue))]
        
        var error: NSError?
        
        do {
            soundRecorder =  try AVAudioRecorder(URL: getFileURL(), settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
        }
        
        if let err = error {
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
    }
    
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory,.UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
        let path = getCacheDirectory().stringByAppendingString(tempAudioFile)
        let filePath = NSURL(fileURLWithPath: path)
        return filePath
    }
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton.setTitle("聴く", forState: .Normal)
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)

    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.hidden = false
        playButton.enabled = true
        recordButton.setTitle("話す", forState: .Normal)
        playButton.setTitleColor(UIColor.greenColor(), forState: .Normal)

    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    @IBAction func onRecord(sender: AnyObject) {
//        print(sender.titleLabel!!.text)
        if (sender.titleLabel!!.text == "話す"){
            soundRecorder.record()
            sender.setTitle("ストップ", forState: .Normal)
            sender.setTitleColor(UIColor.redColor(), forState: .Normal)
            playButton.enabled = false
            playButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        } else {
            soundRecorder.stop()
            sender.setTitle("話す", forState: .Normal)
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)

        }
    }
    
    
    @IBAction func onPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "聴く"){
            recordButton.enabled = false
            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            sender.setTitle("ストップ", forState: .Normal)
            preparePlayer()
            soundPlayer.play() // recording + prerecorded pronunciation 
        } else {
            soundPlayer.stop()
            recordButton.enabled = true
            recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            sender.setTitle("聴く", forState: .Normal)

        }
    }
    
    func loadWord(){
//        get level apropriate word from Data
//        set wordLable
//        set pronunciation
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
