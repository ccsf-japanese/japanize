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
    
    @IBOutlet weak var recordButtonCenter: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var assetAudioPlayer: AVAudioPlayer!

    
    let tempAudioFile = "japanize.caf"
    
    // TODO: Get model from Tom and Alex
    let wordFromModel = "なん"
    let englishHint = "what"
    let romagiHint = "na n"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Theme Block rgb(231, 76, 60)
        let themeColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = themeColor
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.tintColor = themeColor
        
        wordLabel.text = wordFromModel
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
    
    func playAudioAsset(audioAsset: String = "voc-what-なん") {
        var error:NSError?
        if let sound = NSDataAsset(name: audioAsset) {
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                try assetAudioPlayer = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            } catch let error1 as NSError {
                error = error1
                soundPlayer = nil
            }
            if let err = error {
                print("AVAudioPlayer error: \(err.localizedDescription)")
            } else {
                assetAudioPlayer.delegate = self
                assetAudioPlayer.prepareToPlay()
                assetAudioPlayer.volume = 1.0
                assetAudioPlayer.play()

            }
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
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
        
        self.recordButtonCenter.active = false
        self.playButton.hidden = false
        self.playButton.enabled = true
        self.playButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        recordButton.setTitle("話す", forState: .Normal)
        
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
            playAudioAsset("voc-"+englishHint+"-"+wordFromModel)
            preparePlayer()
            soundPlayer.play()
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
