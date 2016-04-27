import UIKit
import AVFoundation
import ChameleonFramework

class PronunciationViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  
  var level: Level?
  
  @IBOutlet weak var wordTextButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  
  @IBOutlet weak var hintTextButton: UIButton!
  @IBOutlet weak var hintMeaningButton: UIButton!
  @IBOutlet weak var playWordButton: UIButton!
    
  @IBOutlet weak var nextButton: UIButton!
    
  var voiceRecorder: AVAudioRecorder!
  var voicePlayer: AVAudioPlayer!
  var audioPlayer: AVAudioPlayer!
  
  var recNowRec: Bool = true
    var recNowPlay: Bool = true
  var voiceRecording: Bool = false
  var newVoiceRecording: Bool = false
  var isLevel: Bool = false
    
  let tempAudioFile = "japanize.caf"
  
  var word: Word?
  var countMeanings: Int?
    
    
  var levelWordsCount: Int = 0
    
  override func viewDidLoad() {
    super.viewDidLoad()

    nextButton.layer.cornerRadius = 7
    recordButton.setTitle("", forState: .Normal)

    
    if let level = level {
        isLevel = true
        self.level = level
        getLevelWord()
        wordTextButton.enabled = false
    } else {
        self.nextButton.hidden = true

        setNewRandomWord()
        if countMeanings > 1 {
          hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
        } else {
          hintMeaningButton.setTitle("English", forState: .Normal)
        }
    }
  }
  
    @IBAction func onNext(sender: AnyObject) {
        self.levelWordsCount = self.levelWordsCount + 1
        
        if self.levelWordsCount == self.level!.words.count {
            self.dismissViewControllerAnimated(false, completion: {
                print("Successfully completed level")
            })
        } else {
            getLevelWord()
        }
    }

    func getLevelWord() {
        if let audioURL = self.level!.words[self.levelWordsCount].audioURL {
            JapanizeFileClient.sharedInstance.dataForFilePath(audioURL, completion: { (data, error) in
                if let audioData = data {
                    self.level!.words[self.levelWordsCount].setAudioWithMP3(audioData)
                    print(self.levelWordsCount," of ", self.level!.words.count, "Random words ready!")
                    self.word = self.level!.words[self.levelWordsCount]
                    self.wordTextButton.setTitle(self.level!.words[self.levelWordsCount].spellings.last, forState: .Normal)
                    self.wordTextButton.enabled = true
                } else {
                    assertionFailure("error downloading audioData")
                }
            })
        }
    }
  override func viewWillAppear(animated: Bool) {
    
    //Theme Block rgb(231, 76, 60) //UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    let themeColor = FlatRed()
    let themeContrast = ContrastColorOf(themeColor, returnFlat: true)
    let nav = self.navigationController?.navigationBar
    nav?.barTintColor = themeColor
    nav?.tintColor =  themeContrast
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: themeContrast]
    self.tabBarController?.tabBar.tintColor = themeColor
    //
    
//    move down from ViewDidLoad
    hintTextButton.hidden = true
//    playWordButton.enabled = false
    playWordButton.hidden = true
    recNowPlay = false

    wordTextButton.setTitle("日本語", forState: .Disabled)
    hintTextButton.setTitle("", forState: .Normal)
    
    setupRecorder()

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
        playWordButton.hidden = false
      newVoiceRecording = false
    }
    if voiceRecording == true {
        recNowPlay = true

    }
  }
  
  func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
    print("Error while playing audio \(error!.localizedDescription)")
  }
  
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if isLevel {
        nextButton.hidden = false
    }
    recNowPlay = true

    newVoiceRecording = true
    voiceRecording = true
    recNowRec = true
    recPlay()
//    recordButton.setTitle("話す", forState: .Normal)
  }
  
  func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
    print("Error while recording audio \(error!.localizedDescription)")
  }
  
  @IBAction func onRecord(sender: AnyObject) {
    var error: NSError?
    let audioSession = AVAudioSession.sharedInstance()
    //      TODO: reset Record to work on enabled
//    if (sender.titleLabel!!.text == "話す"){
    if recNowRec {
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
        recNowRec = false
//        sender.setTitle("ストップ", forState: .Normal)
        recNowPlay = false

      }
    } else {
      voiceRecorder.stop()
      do{
        try audioSession.setActive(false)
        print(">>> audioSession.setActivity(false)")
      }catch{
        print("ERROR: onRecord setActive(false)")
      }
      recNowRec = true
//      sender.setTitle("話す", forState: .Normal)
      recordButton.tintColor = FlatBlack()
        recNowPlay = true

      //            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
      
    }
  }
  
  @IBAction func onRecPlay(sender: UIButton) {
    recPlay()
//    if (sender.enabled == true){
//      //            recordButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
//      //            recordButton.enabled = false
//      sender.enabled = false
//      preparePlayer()
//      voicePlayer.play()
//    } else {
//      voicePlayer.stop()
//      recordButton.enabled = true
//      sender.enabled = true
//      
//    }
  }
    
    func recPlay() {
        if recNowPlay == true {
            recNowPlay = false
            preparePlayer()
            voicePlayer.play()
        } else {
            voicePlayer.stop()
            recordButton.enabled = true
            recNowPlay = true
        }
    }

  @IBAction func onWordPlay(sender: UIButton) {
    if (sender.enabled == true){
//      hintTextButton.setTitle(word?.romaji, forState: .Normal)
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
    hintTextButton.setTitle("", forState: .Normal)
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
    playWordButton.hidden = true
//    playWordButton.enabled = false
    recNowPlay = false

    setNewRandomWord()
  }
  

    @IBAction func onTranslateJapanese(sender: AnyObject) {
        if hintTextButton.titleForState(.Normal) != word?.romaji {
            hintTextButton.setTitle(word?.romaji, forState: .Normal)
            hintTextButton.hidden = false
        } else {
            hintTextButton.hidden = !hintTextButton.hidden
        }
    }
    
    @IBAction func onTranslate(sender: AnyObject) {
        if hintTextButton.titleForState(.Normal) != word?.meanings[0]{
            hintTextButton.setTitle(word?.meanings[0], forState: .Normal)
            hintTextButton.hidden = false
        } else {
            hintTextButton.hidden = !hintTextButton.hidden
        }
        
    // TODO: Tap to switch between multiple meanings
//    if let meanings = word?.meanings{
//      if countMeanings > 1 {
//        hintMeaningButton.setTitle(String(countMeanings)+" english meanings", forState: .Normal)
//        var multiMeaningsCount: Int = 0
//        while multiMeaningsCount < countMeanings {
//          hintTextButton.setTitle(meanings[multiMeaningsCount], forState: .Normal)
//          multiMeaningsCount += 1
//          if multiMeaningsCount >= countMeanings {
//            multiMeaningsCount = 0
//          }
//        }
//        hintTextButton.setTitle(meanings[0], forState: .Normal)
//      } else {
//        hintMeaningButton.setTitle("English", forState: .Normal)
//        hintTextButton.setTitle(meanings[0], forState: .Normal)
//      }
//    }
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
        audioPlayer.volume = 1.5
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
