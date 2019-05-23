//
//  PlayVideoViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/1/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import YoutubeKit

class PlayVideoViewController: UIViewController {
    
    var videoId : String?
    private var player: YTSwiftyPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new player
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width/16*9),
            playerVars: [.videoID(self.videoId!), .playsInline(true) , .showInfo(false), .alwaysShowCaption(false)])
        
        // Enable auto playback when video is loaded
        player.autoplay = true
        
        // Set player view.
        view.addSubview(player)
        
        // Set delegate for detect callback information from the player.
        player.delegate = self
        
        // Load the video.
        player.loadPlayer()

    }
}
extension PlayVideoViewController : YTSwiftyPlayerDelegate {
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel1")
    }
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("cancel2")
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("canel3")
    }
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print(state)
        if state == YTSwiftyPlayerState.paused{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        print(playbackRate)
    }
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("err")
    }
}
