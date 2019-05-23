//
//  PlayerView.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/3/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import YoutubeKit

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
}


class PlayerView: UIView {
    @IBOutlet weak var player: UIView!
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var youtubePlayer: YTSwiftyPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customization()
    }
    func customization (){
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(tapPlayView(_:)), name: NSNotification.Name("open"), object: nil)
        youtubePlayer = YTSwiftyPlayer(frame: self.player.frame,
            playerVars: [ .playsInline(true) , .showInfo(false), .alwaysShowCaption(false)])
        self.player.layer.addSublayer(youtubePlayer.layer)
        youtubePlayer.autoplay = true
        youtubePlayer.loadPlayer()
        youtubePlayer.delegate = self
    }
    @objc func tapPlayView(_ notification : NSNotification)  {
        if let userInfor = notification.userInfo{
            let id = userInfor["id"] as! String
            youtubePlayer.loadVideo(videoID: id)
            youtubePlayer.delegate = self
            self.state = .fullScreen
            self.delegate?.didmaximize()
            self.animate()
        }
    }
    func animate()  {
        switch self.state {
        case .fullScreen:
            //            myPlayer.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, animations: {
//                self.minimizeButton.alpha = 1
//                self.tableView.alpha = 1
                self.player.transform = CGAffineTransform.identity
                UIApplication.shared.isStatusBarHidden = true
            })
        case .minimized:
            //            myPlayer.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = false
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player.bounds.width/4, y: -self.player.bounds.height/2.5))
                self.player.transform = trasform
            })
        default: break
        }
    }
    @IBAction func minimize(_ sender: UIButton) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
//        print("zzzzz")
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.youtubePlayer.pauseVideo()
            }
        }
    }
    func changeValues(scaleFactor: CGFloat) {
//        self.minimizeButton.alpha = 1 - scaleFactor
//        self.tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
        self.player.transform = trasform
        
    }

}
extension PlayerView : YTSwiftyPlayerDelegate {
    func playerReady(_ player: YTSwiftyPlayer) {
        print("abcd")
    }
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("err")
    }
    func apiDidChange(_ player: YTSwiftyPlayer) {
        print("ance")
    }
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        print("abcd")
    }
}
