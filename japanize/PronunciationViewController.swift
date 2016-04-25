import UIKit
import AVFoundation
import ChameleonFramework

class PronunciationViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  
  var level: Level?
  
  @IBOutlet weak var wordTextButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var playRecButton: UIButton!
  
  @IBOutlet weak var hintTextButton: UIButton!
  @IBOutlet weak var hintMeaningButton: UIButton!
  @IBOutlet weak var playWordButton: UIButton!
  
  @IBOutlet weak var recordButtonCenter: NSLayoutConstraint!
  
  var voiceRecorder: AVAudioRecorder!
  var voicePlayer: AVAudioPlayer!
  var audioPlayer: AVAudioPlayer!
  
  var voiceRecording: Bool = false
  var newVoiceRecording: Bool = false
  let tempAudioFile = "japanize.caf"
  
  var word: Word?
  var countMeanings: Int?
  var i: Int = 0
    
  override func viewDidLoad() {
    super.viewDidLoad()

    hintTextButton.hidden = true
    playWordButton.enabled = false
    playRecButton.enabled = false
    // hintMeaningButton.setTitle(String(""), forState: .Normal)
    
    
    recordButtonCenter.active = true
    wordTextButton.setTitle("日本語", forState: .Disabled)
    hintTextButton.setTitle("", forState: .Normal)
    
    setupRecorder()
    
    if let level = level {
        self.level = level
        updateWord()
    } else {
        // Do any additional setup after loading the view.
        setNewRandomWord()
        if countMeanings > 1 {
          hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
        } else {
          hintMeaningButton.setTitle("English", forState: .Normal)
        }
    }
  }
  
    @IBAction func nextWord(sender: AnyObject) {
        self.i = self.i + 1
        
        if self.i == self.level!.words.count {
            self.dismissViewControllerAnimated(false, completion: {
                print("Successfully completed level")
            })
        } else {
            updateWord()
        }
    }

    func updateWord() {
        if let audioURL = self.level!.words[self.i].audioURL {
            JapanizeFileClient.sharedInstance.dataForFilePath(audioURL, completion: { (data, error) in
                if let audioData = data {
                    self.level!.words[self.i].setAudioWithMP3(audioData)
                    print("Random word ready!")
                    self.word = self.level!.words[self.i]
                    self.wordTextButton.setTitle(self.level!.words[0].spellings.last, forState: .Normal)
                    self.wordTextButton.enabled = true
                } else {
                    assertionFailure("error downloading audioData")
                }
            })
        }
        
        if countMeanings > 1 {
            hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
        } else {
            hintMeaningButton.setTitle("English", forState: .Normal)
        }
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
    playWordButton.enabled = true
    if newVoiceRecording {
      if let word = word {
        wordPlayer(word)
      }
      newVoiceRecording = false
    }
    if voiceRecording == true {
      playRecButton.enabled = true
    }
  }
  
  func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
    print("Error while playing audio \(error!.localizedDescription)")
  }
  
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    self.recordButtonCenter.active = false
    self.playRecButton.enabled = true
    newVoiceRecording = true
    voiceRecording = true
    recordButton.setTitle("話す", forState: .Normal)
  }
  
  func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
    print("Error while recording audio \(error!.localizedDescription)")
  }
  
  @IBAction func onRecord(sender: AnyObject) {
    var error: NSError?
    let audioSession = AVAudioSession.sharedInstance()
    //      TODO: reset Record to work on enabled
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
        recordButton.tintColor = FlatRed()
        sender.setTitle("ストップ", forState: .Normal)
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
      recordButton.tintColor = FlatBlack()
      
      playRecButton.enabled = true
      //            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
      
    }
  }
  
  @IBAction func onRecPlay(sender: UIButton) {
    if (sender.enabled == true){
      //            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
      //            recordButton.enabled = false
      sender.enabled = false
      preparePlayer()
      voicePlayer.play()
    } else {
      voicePlayer.stop()
      recordButton.enabled = true
      sender.enabled = true
      
    }
  }
  @IBAction func onWordPlay(sender: UIButton) {
    if (sender.enabled == true){
      hintTextButton.setTitle(word?.romaji, forState: .Normal)
      sender.enabled = false
      if let word = word {
        wordPlayer(word)
      }
    } else {
      if audioPlayer.playing {
        audioPlayer.stop()
      }
      sender.enabled = true
      
    }
  }
  
  @IBAction func onHintTextButton(sender: AnyObject) {
    if let meanings = word?.meanings{
      if countMeanings > 1 {
        hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
        var i: Int = 0
        while i < countMeanings {
          hintTextButton.setTitle(meanings[i], forState: .Normal)
          i += 1
          if i >= countMeanings {
            i = 0
          }
        }
        hintTextButton.setTitle(meanings[0], forState: .Normal)
      } else {
        hintMeaningButton.setTitle("English", forState: .Normal)
        hintTextButton.setTitle(meanings[0], forState: .Normal)
        print("There can be (is) only one.")
      }
    }
  }
  
  @IBAction func onWordTextButton(sender: AnyObject) {
    hintTextButton.hidden = true
    voiceRecording = false
    if countMeanings > 1 {
      hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
    } else {
      hintMeaningButton.setTitle("English", forState: .Normal)
    }
    hintTextButton.setTitle("", forState: .Normal)
    playWordButton.enabled = false
    playRecButton.enabled = false
    setNewRandomWord()
  }
  
  @IBAction func onTranslate(sender: AnyObject) {
    if hintTextButton.hidden {
      hintTextButton.setTitle(word?.meanings[0], forState: .Normal)
      hintTextButton.hidden = false
      playWordButton.enabled = true
    } else {
      
    }
    
    // TODO: Tap to switch between multiple meanings
    if let meanings = word?.meanings{
      if countMeanings > 1 {
        hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
        var i: Int = 0
        while i < countMeanings {
          hintTextButton.setTitle(meanings[i], forState: .Normal)
          i += 1
          if i >= countMeanings {
            i = 0
          }
        }
        hintTextButton.setTitle(meanings[0], forState: .Normal)
      } else {
        hintMeaningButton.setTitle("English", forState: .Normal)
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
        var words = Array<Word>()
        
        for chapter in book.chapters {
          for level in chapter.levels {
            for word in level.words {
              if (word.audioURL) != nil {
                words.append(word)
              }
            }
          }
        }
        
        let chosenWord = words.sample()
        if let audioURL = chosenWord.audioURL {
          JapanizeFileClient.sharedInstance.dataForFilePath(audioURL, completion: { (data, error) in
            if let audioData = data {
              chosenWord.setAudioWithMP3(audioData)
              print("Random word ready!")
              self.word = chosenWord
              self.wordTextButton.setTitle(chosenWord.spellings.last, forState: .Normal)
              self.wordTextButton.enabled = true
            } else {
              assertionFailure("error downloading audioData")
            }
          })
        } else {
          assertionFailure("chosenWord should always have audioURL")
        }
      }
    })
    countMeanings = word?.meanings.count
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
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.becomeFirstResponder()
  }
  
  override func canBecomeFirstResponder() -> Bool {
    return true
  }
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
    if (event.subtype == UIEventSubtype.MotionShake && level == nil) {
      self.setNewRandomWord()
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
