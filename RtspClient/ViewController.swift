//
//  ViewController.swift
//  RtspClient
//
//  Created by Teocci on 18/05/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var setting: UIButton!
    var video: RTSPPlayer!
    var timer : Timer?
    var videoVC: VideoViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting.addTarget(self, action: #selector(self.showSetting), for: .touchUpInside)
     }
    
    @objc func showSetting(){
        let alert = UIAlertController(title: "Stream Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("Done !!")
            if let textField = alert.textFields?.first {
                print("Item : \(textField.text))")
            }
        }))
       
        alert.addTextField { (configurationTextField) in
            //configure here your textfield
            configurationTextField.placeholder = "get stream "
        }
        alert.addTextField { (confiTex) in
            confiTex.placeholder  = "Broadcast stream"
        }
        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("Done !!")
            if let textField = alert.textFields?[0]{
                if(textField.text != ""){
                    self.playStream(stream: textField.text!)
                }
            }
            if let textField = alert.textFields?[1] {
                if(textField.text != ""){
                 self.startBroadcast(chanel: textField.text!)
                }
            }
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        videoVC = segue.destination as! VideoViewController
    }
    
    func playStream(stream : String) {
        print("rtsp://103.69.195.137:1935/videochat/\(stream)")
        video = RTSPPlayer(video: "rtsp://103.69.195.137:1935/videochat/\(stream)", usesTcp: false)
        video.outputWidth = Int32(view.frame.width)
        video.outputHeight = Int32(view.frame.width)
        video.seekTime(0.0)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0/30, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func startBroadcast(chanel : String){
        //videoVC.startBroadcast(broadCast: chanel)
        videoVC.startBroadcast(streamName: chanel)
    }
    
    @objc func update(timer: Timer) {
        if(!video.stepFrame()){
            timer.invalidate()
            print("timer invalidate")
            video.closeAudio()
        }
        imageView.image = video.currentImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

