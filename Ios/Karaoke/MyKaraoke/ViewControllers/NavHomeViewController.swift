//
//  NavHomeViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/3/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import Kingfisher

class NavHomeViewController: UINavigationController {
    @IBOutlet var searchView: SearchView!
    @IBOutlet var playerView: PlayerView!
    var listv : [UIView] = [];
    
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    let searchButton : UIButton = {
       return UIButton.init(type: .system)
    }()
    let youtubeImageView : UIImageView = {
        return UIImageView()
    }()
    // Toolbar
    let playImageView : UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        return iv;
    }()
    let toolbarView : UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        iv.layer.masksToBounds = false;
        iv.layer.shadowOffset = CGSize(width: -1, height: 1)
        iv.layer.shadowRadius = 5;
        iv.layer.shadowOpacity = 0.5;
        return iv
    }()
    let titleView : UITextView = {
        let tv = UITextView()
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.textContainer.maximumNumberOfLines = 2
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textContainer.lineBreakMode = .byTruncatingTail
//        tv.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        return tv
    }()
    let nextButton : UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        let image = UIImage(named: "next")!.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = .gray
        btn.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return btn;
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
     func customization() {
        // Set up Navigation bar
        self.navigationBar.backgroundColor = UIColor(red: 182, green: 196, blue: 192, alpha: 1)
        self.navigationBar.isTranslucent = false
        self.navigationBar.layer.masksToBounds = false;
        self.navigationBar.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.navigationBar.layer.shadowRadius = 5;
        self.navigationBar.layer.shadowOpacity = 0.5;
        
        // Search Button
        let searchButton = UIButton.init(type: .system)
        searchButton.setImage(UIImage.init(named: "search"), for: .normal)
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        searchButton.tintColor = UIColor.gray
        searchButton.addTarget(self, action: #selector(self.showSearch), for: UIControlEvents.touchUpInside)
        self.navigationBar.addSubview(searchButton)
        self.navigationBar.addConstrainsWithFormat("H:[v0(44)]-1-|", searchButton)
        self.navigationBar.addConstrainsWithFormat("V:[v0(44)]-1-|", searchButton)
        // Logo
        youtubeImageView.image = UIImage(named: "yt")
        youtubeImageView.layer.masksToBounds = true
        youtubeImageView.contentMode = .scaleAspectFill
        self.navigationBar.addSubview(youtubeImageView)
        self.navigationBar.addConstrainsWithFormat("H:|-8-[v0(100)]", youtubeImageView)
        self.navigationBar.addConstrainsWithFormat("V:[v0(36)]-10-|", youtubeImageView)
        
        // Set up SearchView
        self.view.addSubview(self.searchView)
        self.view.addConstrainsWithFormat("H:|[v0]|", self.searchView)
        self.view.addConstrainsWithFormat("V:|[v0]|", self.searchView)
        self.searchView.isHidden = true

        
        // PlayerView setup
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(handlerOpenResult(_:)), name: NSNotification.Name("result"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSearch), name: NSNotification.Name("showSearch"), object: nil)
        // setup Toolbar
        self.view.addSubview(toolbarView)
        self.view.addConstrainsWithFormat("H:|[v0]|", self.toolbarView)
        self.view.addConstrainsWithFormat("V:[v0]|", self.toolbarView)
        self.toolbarView.addSubview(playImageView)
        self.toolbarView.addConstrainsWithFormat("V:|-7-[v0(40)]-7-|", self.playImageView)
        self.toolbarView.addSubview(titleView)
        self.toolbarView.addConstrainsWithFormat("V:|[v0]|", self.titleView)
        self.toolbarView.addSubview(self.nextButton)
        
        let uiv = UIView()
        uiv.backgroundColor = UIColor.gray;
        self.toolbarView.addSubview(uiv)
        self.toolbarView.addConstrainsWithFormat("V:|[v0]|", uiv)
        
        self.toolbarView.addConstrainsWithFormat("H:|-8-[v0(40)]-8-[v1][v2(1)][v3(50)]|", self.playImageView, self.titleView,uiv, self.nextButton)
        self.toolbarView.addConstrainsWithFormat("V:|[v0]|", self.nextButton)
        self.playImageView.rotate(duration: 6)
        let dTap = UITapGestureRecognizer(target: self, action: #selector(gesture))
        dTap.numberOfTapsRequired = 2
        self.toolbarView.addGestureRecognizer(dTap)
        NotificationCenter.default.addObserver(self, selector: #selector(obserCurrentPlay), name: NSNotification.Name("cuonghx"), object: nil)
    }
    @objc func gesture(){
        for i in listv {
            i.removeFromSuperview()
        }
        self.popToRootViewController(animated: true)
    }
    
    @objc
    func obserCurrentPlay(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = Database.database().reference(withPath: appDelegate.key).child("Current")
        ref.child("song").observeSingleEvent(of: .value) { (snap) in
            let json = JSON(snap.value)
            print(json)
            self.titleView.text = json["title"].stringValue
            self.playImageView.kf.setImage(with: URL(string: json["urlImage"].stringValue))
        }
        ref.observe(.childChanged) { (snap) in
            let json = JSON(snap.value)
            print(json)
            print(snap.value)
            self.titleView.text = json["title"].stringValue
            self.playImageView.kf.setImage(with: URL(string: json["urlImage"].stringValue))
        }
    }
    @objc func handleSendButton(){
        FirebaseUtils.pushNext()
    }
    @objc func handlerOpenResult(_ notification : NSNotification){
        if let userInfor = notification.userInfo{
            let content = userInfor["content"] as! String
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "result") as! ResultViewController
            vc.textField.text = content
            self.pushViewController(vc, animated: true)
        }
    }
    @objc func showSearch()  {
        print("search")
        self.searchView.alpha = 0
        self.searchView.isHidden = false
        self.searchView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.alpha = 1
        }) { _ in
            self.searchView.textField.becomeFirstResponder()
            self.searchView.tableView.reloadData()
            self.searchView.tableView.isHidden = false
        }
    }
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customization()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playerView)
        }
    }
}
extension NavHomeViewController : PlayerVCDelegate {
    
    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
}
