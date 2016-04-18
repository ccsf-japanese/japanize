//
//  PronunciationViewController.swift
//  japanize
//
//  Created by Dylan Smith on 3/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import AVFoundation
import ChameleonFramework

class PronunciationViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var wordTextButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playRecButton: UIButton!
    
    @IBOutlet weak var hintTextButton: UIButton!
    @IBOutlet weak var hintRomajiButton: UIButton!
    @IBOutlet weak var hintMeaningButton: UIButton!
    @IBOutlet weak var playWordButton: UIButton!

    @IBOutlet weak var recordButtonCenter: NSLayoutConstraint!
    
    var voiceRecorder: AVAudioRecorder!
    var voicePlayer: AVAudioPlayer!
    var audioPlayer: AVAudioPlayer!

    var newVoiceRecording: Bool = false
    let tempAudioFile = "japanize.caf"
    
    var word: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hintTextButton.hidden = true
//        hintMeaningButton.hidden = true
        hintRomajiButton.hidden = true
        playWordButton.hidden = true
        hintMeaningButton.setTitle(String(""), forState: .Normal)

        
        recordButtonCenter.active = true
        wordTextButton.setTitle("日本語", forState: .Disabled)

        setupRecorder()
//                recordButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)

        // Do any additional setup after loading the view.
        setNewRandomWord()
    }
  
    override func viewWillAppear(animated: Bool) {
        
        //Theme Block rgb(231, 76, 60)
        let themeColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = themeColor
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.tintColor = themeColor
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
            try voiceRecorder = AVAudioRecorder(URL: self.getFileURL(), settings: recordSettings)
            voiceRecorder.delegate = self
            voiceRecorder.prepareToRecord()
        } catch let error1 as NSError {
            error = error1
            print("ERROR: setupRecorder")
            voiceRecorder = nil
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
            voicePlayer = try AVAudioPlayer(contentsOfURL: voiceRecorder.url, fileTypeHint: AVFileTypeCoreAudioFormat)
        } catch let error1 as NSError {
            error = error1
            print("ERROR: preparePlayer")
            voicePlayer = nil
        }
        if let err = error {
            print("ERROR: preparePlayer AVAudioPlayer: \(err.localizedDescription)")
        } else {
            voicePlayer.delegate = self
            voicePlayer.prepareToPlay()
            voicePlayer.volume = 1.0
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        playWordButton.setTitle(".", forState: .Normal)
        if newVoiceRecording {
            if let word = word {
                wordPlayer(word)
            }
            newVoiceRecording = false
        }
        playRecButton.setTitle("聴く", forState: .Normal)
        playRecButton.enabled = true

    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        self.recordButtonCenter.active = false
        self.playRecButton.enabled = true
        newVoiceRecording = true
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
                voiceRecorder.record()
            } catch let error1 as NSError {
                error = error1
                print("ERROR: onRecord")
                voiceRecorder = nil
            }
            if let err = error {
                print("ERROR: onRecord AVAudioRecorder: \(err.localizedDescription)")
            } else {
            sender.setTitle("ストップ", forState: .Normal)
//            sender.setTitleColor(UIColor.redColor(), forState: .Normal)
//            self.playRecButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
                playRecButton.enabled = false
            }
        } else {
                voiceRecorder.stop()
            do{
                try audioSession.setActive(false)
                print(">>> audioSession.setActivity(false)")
            }catch{
                print("ERROR: onRecord setActive(false)")
            }
            sender.setTitle("話す", forState: .Normal)
            playRecButton.enabled = true
//            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }
    }
    
    @IBAction func onRecPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "聴く"){
            recordButton.enabled = false
//            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            recordButton.enabled = false
            sender.setTitle("ストップ", forState: .Normal)
            preparePlayer()
            voicePlayer.play()
        } else {
            voicePlayer.stop()
            recordButton.enabled = true
//            recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            recordButton.enabled = true
            sender.setTitle("聴く", forState: .Normal)
            
        }
    }
    @IBAction func onWordPlay(sender: AnyObject) {
        if (sender.titleLabel!!.text == "."){
            hintTextButton.setTitle(word?.romaji, forState: .Normal)
            sender.setTitle(",", forState: .Normal)
            if let word = word {
                wordPlayer(word)
            }
        } else {
            if audioPlayer.playing {
                audioPlayer.stop()
            }
            sender.setTitle(".", forState: .Normal)
            
        }
    }
    
    
    
    @IBAction func onHint(sender: AnyObject) {
        if hintTextButton.hidden {
            hintTextButton.setTitle(word?.meanings[0], forState: .Normal)
            hintTextButton.hidden = false
            hintMeaningButton.hidden = false
            hintRomajiButton.hidden = false
            playWordButton.hidden = false
        }else{
            hintTextButton.hidden = true
            hintMeaningButton.hidden = true
            hintRomajiButton.hidden = true
            playWordButton.hidden = true

        }
        
        
    }
    
    @IBAction func onHintTextButton(sender: AnyObject) {
//        onHint(sender)
    }
    
    @IBAction func onWordTextButton(sender: AnyObject) {
        setNewRandomWord()
    }
    @IBAction func onRomaji(sender: AnyObject) {
        print("onRomaji")
        hintTextButton.setTitle(word?.romaji, forState: .Normal)
    }
    @IBAction func onTranslate(sender: AnyObject) {
        if let meanings = word?.meanings{
            if meanings.count > 1 {
                hintMeaningButton.setTitle(String(meanings.count), forState: .Normal)
            }else{
            hintMeaningButton.setTitle(String(""), forState: .Normal)
            hintTextButton.setTitle(meanings[0], forState: .Normal)
            }
        }
    }
   
  
  func setNewRandomWord() {
    word = nil
    wordTextButton.enabled = false
    print("fetching Word")
    // TODO: Consider refactoring nested code, adding error handling
    JapanizeClient.sharedInstance.book( { (book, error) -> () in
      if let book = book {
        var words = Array<String>()
        
        for chapter in book.chapters {
          for level in chapter.levels {
            for word in level.words {
              words.append(word)
            }
          }
        }
        
        let chosenWord = words.sample()
        JapanizeClient.sharedInstance.wordWithID(chosenWord, completion: { (word, error) in
          if let word = word {
            if let audioURL = word.audioURL {
              JapanizeFileClient.sharedInstance.dataForFilePath(audioURL, completion: { (data, error) in
                if let audioData = data {
                  word.setAudioWithMP3(audioData)
                  print("Random word ready!")
                  self.word = word
                  self.wordTextButton.setTitle(word.spellings.last, forState: .Normal)
                  self.wordTextButton.enabled = true
                } else {
                  self.setNewRandomWord()
                }
              })
            } else {
              self.setNewRandomWord()
            }
          }
        })
      }
    })
  }
     func wordPlayer(word: Word) {
        var error: NSError?
        if let audioData = word.audio {
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(data: audioData, fileTypeHint: AVFileTypeMPEGLayer3)
            } catch let error1 as NSError {
                error = error1
                audioPlayer = nil
            }
            if let err = error {
                print("ERROR: playWord AVAudioPlayer: \(err.localizedDescription)")
            } else {
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.play()
                
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
