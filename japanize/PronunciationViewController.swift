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
    @IBOutlet weak var playAssetButton: UIButton!
    @IBOutlet weak var playRecButton: UIButton!
    
    @IBOutlet weak var hintTextButton: UIButton!
    @IBOutlet weak var recordButtonCenter: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var assetAudioPlayer: AVAudioPlayer!

    var hintTaps: Int! = 0
    let tempAudioFile = "japanize.caf"
    
    
    // TODO: Get model from Tom and Alex
    var word: String?
    var englishHint: String?
    var romagiHint: String?
    var audioAsset: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintTextButton.hidden = true
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
        
        loadWord()
        wordLabel.text = word
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupRecorder() {
        let recordSettings = [
            AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue]
        
        var error: NSError?
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try soundRecorder = AVAudioRecorder(URL: self.getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch let error1 as NSError {
            error = error1
            print("ERROR: setupRecorder")
            soundRecorder = nil
        }
        if let err = error {
            print("ERROR: setupRecorder AVAudioRecorder: \(err.localizedDescription)")
        } else {
            print(">>> setupRecord ran without errors")
        }
    }
    
    func getFileURL() -> NSURL {
        let cachePath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
        let path = cachePath.URLByAppendingPathComponent(tempAudioFile)
        let filePath = path.path!
        let fileURL = NSURL(string: filePath)!
        return fileURL
    }
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            soundPlayer = try AVAudioPlayer(contentsOfURL: soundRecorder.url, fileTypeHint: AVFileTypeCoreAudioFormat)
        } catch let error1 as NSError {
            error = error1
            print("ERROR: preparePlayer")
            soundPlayer = nil
        }
        if let err = error {
            print("ERROR: preparePlayer AVAudioPlayer: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playAssetButton.setTitle("聴く", forState: .Normal)
        playAssetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        self.recordButtonCenter.active = false
        self.playAssetButton.hidden = false
        self.playAssetButton.enabled = true
        self.playAssetButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        recordButton.setTitle("話す", forState: .Normal)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    @IBAction func onRecord(sender: AnyObject) {
        var error: NSError?
        let audioSession = AVAudioSession.sharedInstance()
//        if !soundRecorder.recording{
        if (sender.titleLabel!!.text == "話す"){
            do{
                try audioSession.setActive(true)
                setupRecorder()
                print(">>> Start recording")
                soundRecorder.record()
            } catch let error1 as NSError {
                error = error1
                print("ERROR: onRecord")
                soundRecorder = nil
            }
            if let err = error {
                print("ERROR: onRecord AVAudioRecorder: \(err.localizedDescription)")
            } else {
            sender.setTitle("ストップ", forState: .Normal)
            sender.setTitleColor(UIColor.redColor(), forState: .Normal)
            self.playAssetButton.enabled = false
            self.playAssetButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            }
        } else {
                soundRecorder.stop()
            do{
                try audioSession.setActive(false)
                print(">>> audioSession.setActivity(false)")
            }catch{
                print("ERROR: onRecord setActive(false)")
            }
            sender.setTitle("話す", forState: .Normal)
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }
    }
    
    @IBAction func onRecPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "聴く"){
            recordButton.enabled = false
            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            sender.setTitle("ストップ", forState: .Normal)
            if audioAsset != nil{
                playAudioAsset(audioAsset!)
            }
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            recordButton.enabled = true
            recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            sender.setTitle("聴く", forState: .Normal)
            
        }
    }
    @IBAction func onAssetPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "聴く"){
            recordButton.enabled = false
            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            sender.setTitle("ストップ", forState: .Normal)
            if audioAsset != nil{
                playAudioAsset(audioAsset!)
            }
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            recordButton.enabled = true
            recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            sender.setTitle("聴く", forState: .Normal)
            
        }
    }
    
    @IBAction func onPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "聴く"){
            recordButton.enabled = false
            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            sender.setTitle("ストップ", forState: .Normal)
            if audioAsset != nil{
             playAudioAsset(audioAsset!)
            }
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            recordButton.enabled = true
            recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            sender.setTitle("聴く", forState: .Normal)
            
        }
    }
    
    
    @IBAction func onHint(sender: AnyObject) {
        if hintTaps == 0 {
            hintTextButton.hidden = false
            hintTextButton.setTitle("Tap again For English", forState: .Normal)
            hintTaps = 1
        } else if hintTaps == 1 {
            hintTextButton.setTitle(englishHint, forState: .Normal)
            hintTextButton.hidden = false
            hintTaps = 2
        } else if hintTaps == 2 {
            hintTextButton.setTitle("Tap again For Romagi", forState: .Normal)
            hintTextButton.hidden = false
            hintTaps = 3
        } else if hintTaps == 3 {
            hintTextButton.setTitle(romagiHint, forState: .Normal)
            hintTextButton.hidden = false
            hintTaps = 4
        } else if hintTaps == 4 {
            hintTextButton.setTitle("Tap again to Hear word", forState: .Normal)
            hintTextButton.hidden = false
            hintTaps = 5
        } else if hintTaps == 5 {
            hintTextButton.hidden = true
            if audioAsset != nil{
                playAudioAsset(audioAsset!)
            }
            hintTaps = 1
        }
        
        
    }
    
    @IBAction func onHintTextButton(sender: AnyObject) {
        onHint(sender)
    }
    
    @IBAction func onWord(sender: AnyObject) {
        hintTextButton.hidden = true
        hintTaps = 0
        loadWord()
        
    }
    
    func loadWord(){
        var randomAudioAsset: String!
        let audioAssetNames = ["Business-Bijinesu-ビジネス", "America(USA)-Amerika-アメリカ", "Japanese-Nihongo-日本語", "What-Nan-なん"]
        randomAudioAsset = audioAssetNames.sample()
        print(randomAudioAsset)
        let splitAssetName = randomAudioAsset.characters.split("-").map(String.init)
        word = splitAssetName[2]
        englishHint = splitAssetName[0]
        romagiHint = splitAssetName[1]
        audioAsset = randomAudioAsset
        wordLabel.text = word
        
        //        get level apropriate word from Data
        //        set wordLable
        //        set pronunciation
    }
    
    func playAudioAsset(audioAsset: String) {
        var error:NSError?
        // TODO: Consider not using NSDataAsset to make project compile for iOS 8
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
                print("ERROR: playAudioAsset AVAudioPlayer: \(err.localizedDescription)")
            } else {
                assetAudioPlayer.delegate = self
                assetAudioPlayer.prepareToPlay()
                assetAudioPlayer.volume = 1.0
                assetAudioPlayer.play()
                
            }
        }
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
