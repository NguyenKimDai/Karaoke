//
//  SearchView.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/3/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SVDelegate {
    func changeText(_ text : String)
}

class SearchView: UIView {
    var data : [String] = ["nonstop", "viet mix", "karaoke"]
    var bottomConstrain:NSLayoutConstraint?
    var delegate : SVDelegate?
    var widthNavigationBar : CGFloat?
    
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
        //        tb.backgroundColor = .clear
        return tb
    }()
    let backButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: UIControlState.normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return btn
    }()
    let textField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Tìm kiếm bài hát"
        tf.clearButtonMode = .always
        return tf
    }()
    
    var textChange : String = "" {
        didSet {
            self.textField.text = textChange
//            handlerTextFieldChange(textField)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customization()
    }
    func customization(){
        addSubview(tableView)
        addSubview(headerView)
        
        tableView.backgroundColor = .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        //        self.tableView.rowHeight = 60
        self.tableView.separatorStyle = .none
        let xib = UINib(nibName: "SuggestionTableViewCell", bundle: nil)
        self.tableView.register(xib, forCellReuseIdentifier: cellID2)
        
        self.headerView.addSubview(self.backButton)
        self.headerView.addSubview(self.textField)
        self.textField.addTarget(self, action: #selector(handlerTextFieldChange(_:)), for: UIControlEvents.editingChanged)
        backButton.addTarget(self, action: #selector(handlerBtnBack(_:)), for: .touchUpInside)
        
        self.headerView.addConstrainsWithFormat("H:|[v0(42)][v1]-8-|", self.backButton, self.textField)
        self.headerView.addConstrainsWithFormat("V:[v0(42)]-4-|", self.backButton)
        self.headerView.addConstrainsWithFormat("V:[v0(46)]|", self.textField)
        
        addConstrainsWithFormat("H:|[v0]|", self.headerView)
        addConstrainsWithFormat("H:|[v0]|", self.tableView)
        addConstrainsWithFormat("V:|[v0(65)][v1]", self.headerView,self.tableView)
        bottomConstrain = NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraint(bottomConstrain!)
//        self.textField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    @objc func handlerBtnBack(_ sender : UIButton){
        print("back")
        self.hideSearchView(sender)
    }
    @IBAction func hideSearchView(_ sender: Any) {
        self.textField.text = ""
        self.data = ["karaoke", "nonstop", "vietmix"]
        self.tableView.isHidden = true
        self.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
    @objc func handleKeyNotification(notification : NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            print(keyboardFrame.height)
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstrain?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
        }
    }

}
//let cellID2 = "This is CellID2"
extension SearchView : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SuggestionCellDelegate {
    func changeTextRequest(_ text: String) {
        self.textField.text = text
        handlerTextFieldChange(self.textField)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! SuggestionTableViewCell
        var str = data[indexPath.row]
        while str.widthOfString(usingFont: UIFont.systemFont(ofSize: 16)) > self.frame.width - 112 {
            str.remove(at: str.index(before: str.endIndex))
        }
        cell.textlb.text = data[indexPath.row].makeString(length: str.count)
        cell.delegate = self
        cell.relativeValue = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        NotificationCenter.default.post(name: NSNotification.Name("result"), object: nil, userInfo: ["content" : data[indexPath.row]])
        self.hideSearchView(tableView)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            return false
        }else {
            NotificationCenter.default.post(name: NSNotification.Name("result"), object: nil, userInfo: ["content" : textField.text])
            self.hideSearchView(tableView)
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func handlerTextFieldChange(_ sender : UITextField){
        print("change \(sender.text)")
        let text = sender.text ?? ""
        var url = URLComponents(string: "http://suggestqueries.google.com/complete/search")
        url?.queryItems = [URLQueryItem(name: "q", value: text), URLQueryItem(name: "client", value: "firefox"), URLQueryItem(name: "ds", value: "yt"), URLQueryItem(name: "oe", value: "utf-8")]
        Alamofire.request(url!).response { (res) in
            print(text)
            if let data = res.data {
                let json = JSON(data)
                print(json.arrayValue.count)
                self.data = []
                if json.arrayValue.count > 0 {
                    for index in json.arrayValue[1].arrayValue {
                        self.data.append(index.stringValue)
                    }
                }else {
                    self.data = ["karaoke", "nonstop", "vietmix"]
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
