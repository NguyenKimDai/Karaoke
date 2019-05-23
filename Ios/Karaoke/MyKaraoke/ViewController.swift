//
//  ViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 11/30/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
        return view
    }()
    let tableView : UITableView = {
        let tb = UITableView()
        return tb
    }()
    
    let imageYoutube : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "yt")
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .red
        return iv
    }()
    let buttonSearch : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "search"), for: UIControlState.normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView(){
//        self.view.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
        self.headerView.addSubview(self.imageYoutube)
        self.headerView.addSubview(self.buttonSearch)
        buttonSearch.addTarget(self, action: #selector(handlerBtnSeach(_:)), for: .touchUpInside)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        
        self.headerView.addConstrainsWithFormat("H:[v0(44)]-1-|", self.buttonSearch)
        self.headerView.addConstrainsWithFormat("V:[v0(44)]-1-|", self.buttonSearch)
        self.headerView.addConstrainsWithFormat("H:|-8-[v0(116)]", self.imageYoutube)
        self.headerView.addConstrainsWithFormat("V:[v0(43)]-12-|", self.imageYoutube)
        
        
        self.view.addConstrainsWithFormat("H:|[v0]|", self.headerView)
        self.view.addConstrainsWithFormat("H:|[v0]|", self.tableView)
        self.view.addConstrainsWithFormat("V:|[v0(70)]-2-[v1]|", self.headerView,self.tableView)
    }
    @objc func handlerBtnSeach(_ sender : UIButton){
        print("some thing")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "search")
        vc.modalPresentationStyle = .overFullScreen
//        vc.view.backgroundColor = .clear
        self.present(vc, animated: false, completion: nil)
    }
    func presentResult(_ content : String) {
        print(content)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "result") as! ResultViewController
        vc.textField.text = content
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
let cellID = "This is cell ID1"
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
}


