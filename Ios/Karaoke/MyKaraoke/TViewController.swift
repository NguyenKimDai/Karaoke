//
//  TViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/3/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import WebKit

class TViewController: UIViewController {

    @IBOutlet weak var wk: WKWebView!
    var myPlayer: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.requiresUserActionForMediaPlayback = false
        
        myPlayer = WKWebView(frame: CGRect(x: 0, y: 0, width: 375, height: 300), configuration: webConfiguration)
        self.view.addSubview(myPlayer)
        myPlayer.scrollView.isScrollEnabled = false
        
//        myPlayer.loadHTMLString(embedVideoHtml, baseURL: nil)
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/9n1e1N0Sa9k?autoplay=1&playsinline=1") {
            let request:URLRequest = URLRequest(url: videoURL)
            myPlayer.load(request)
        }
    }
    var embedVideoHtml:String {
        return """
        <!DOCTYPE html>
        <html>
        <body>
        <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
        <div id="player"></div>
        
        <script>
        var tag = document.createElement('script');
        
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
        var player;
        function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
        height: '300')',
        width: '375',
        videoId: 'https://www.youtube.com/embed/9n1e1N0Sa9k',
        events: {
        'onReady': onPlayerReady
        }
        });
        }
        
        function onPlayerReady(event) {
        event.target.playVideo();
        }
        </script>
        </body>
        </html>
        """
    }

}
