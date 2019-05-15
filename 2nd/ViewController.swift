//
//  ViewController.swift
//  StopWatchApp
//
//  Created by Gen Taguchi on 2017/01/23.
//  Copyright © 2017年 Dotinstall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
//    スタートが押されてない間はストップは非表示
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var startTime: TimeInterval? = nil // Double
    var timer = Timer()
    var elapsedTime: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
//        起動直後: スタート○、ストップ×、リセット×
        setButtonEnabled(start: true, stop: false, reset: false)
    }
    
    func setButtonEnabled(start: Bool, stop: Bool, reset: Bool) {
        self.startButton.isEnabled = start
        self.stopButton.isEnabled = stop
        self.resetButton.isEnabled = reset
    }
    
    @objc func update() {
        // 2001/1/1 00:00:00
        //        print(Date.timeIntervalSinceReferenceDate)
        if let startTime = self.startTime {
            let t: Double = Date.timeIntervalSinceReferenceDate - startTime + self.elapsedTime
            //            print(t)
            let min = Int(t / 60)
            let sec = Int(t) % 60
//            1分越えると秒数表示がおかしくなるのは分を引いてないから
            let msec = Int((t - Double(min * 60) - Double(sec)) * 100.0)
            self.timerLabel.text = String(format: "%02d:%02d:%02d", min, sec, msec)
        }
    }
    
    @IBAction func startTimer(_ sender: Any) {
//        タイマーが始まったら（スタートが押されたら）:スタート×、ストップ○、リセット×
        setButtonEnabled(start: false, stop: true, reset: false)
        
        self.startTime = Date.timeIntervalSinceReferenceDate
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.update),
            userInfo: nil,
            repeats: true)
    }
    
    @IBAction func stopTimer(_ sender: Any) {
//        ストップした時: ○ × ○
        setButtonEnabled(start: true, stop: false, reset: true)
        
        if let startTime = self.startTime {
            self.elapsedTime += Date.timeIntervalSinceReferenceDate - startTime
        }
        self.timer.invalidate()
    }
    
    @IBAction func resetTimer(_ sender: Any) {
//        リセットが押されたら：○ × ×
        setButtonEnabled(start: true, stop: false, reset: false)

        self.startTime = nil
        self.timerLabel.text = "00:00:00"
        self.elapsedTime = 0.0
    }
}
