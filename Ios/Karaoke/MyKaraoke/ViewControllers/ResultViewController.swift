//
//  ResultViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/1/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ResultViewController: UIViewController {
    
    var data : [YoutubeModel] = []
    let threshold : CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false
    var stopLoadMore = false
    var nextPageToken : String?
    
    let headerView : UIView = {
        let view = UIView()
        return view
    }()
    let tableView : UITableView = {
        let tb = UITableView()
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
        tf.text = "Test"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        getData()
    }
    
    func setupView () {
        (self.navigationController as! NavHomeViewController).listv.append(headerView)
        self.navigationController?.navigationBar.addSubview(headerView);
        self.navigationController?.navigationBar.addConstrainsWithFormat("H:|[v0]|", headerView)
        self.navigationController?.navigationBar.addConstrainsWithFormat("V:|[v0]|", headerView)
        self.headerView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.addSubview(tableView)
//
        self.headerView.addSubview(self.backButton)
        self.headerView.addSubview(self.textField)
//
        self.headerView.addConstrainsWithFormat("H:|[v0(42)][v1]-8-|", self.backButton, self.textField)
        self.headerView.addConstrainsWithFormat("V:[v0(42)]-4-|", self.backButton)
        self.headerView.addConstrainsWithFormat("V:[v0(46)]|", self.textField)
        
        self.view.addConstrainsWithFormat("H:|[v0]|", self.tableView)
        self.view.addConstrainsWithFormat("V:|[v0]|", self.tableView)
        
        
        backButton.addTarget(self, action: #selector(handlerBtnBack(_:)), for: .touchUpInside)
//
        self.textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerTFClick)))
        self.textField.isUserInteractionEnabled = true
//
        self.tableView.register(UINib(nibName: "CellYoutube", bundle: nil), forCellReuseIdentifier: "CellYoutube")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        let height = (self.view.frame.width - 60) * 9 / 32
        self.tableView.rowHeight = height + 20
    }
    @objc func handlerTFClick(){
        NotificationCenter.default.post(name: NSNotification.Name("showSearch"), object: nil, userInfo: nil)
    }
    @objc func handlerBtnBack(_ sender : UIButton){
        print("back")
        (self.navigationController as! NavHomeViewController).listv.removeLast();
        self.headerView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    func getData(){
        var url = URLComponents(string: "https://www.googleapis.com/youtube/v3/search")
        var querys = [URLQueryItem(name: "q", value: textField.text!), URLQueryItem(name: "part", value: "snippet,id"), URLQueryItem(name: "fields", value: "nextPageToken,items(id/videoId,snippet/title,snippet/description,snippet/thumbnails/high/url,snippet/channelTitle)"), URLQueryItem(name: "type", value: "video"), URLQueryItem(name: "q", value: textField.text), URLQueryItem(name: "key", value: key)]
        if let nextPageToken = self.nextPageToken , nextPageToken != ""{
            print("next")
            querys.append(URLQueryItem(name: "pageToken", value: nextPageToken))
            querys.append(URLQueryItem(name: "maxResults", value: "50"))
        }else {
            querys.append(URLQueryItem(name: "maxResults", value: "10"))
        }
        url?.queryItems = querys
        if !stopLoadMore {
            Alamofire.request(url!).response { (res) in
                print("done")
                if let data = res.data {
                    let json = JSON(data)
                    self.nextPageToken = json["nextPageToken"].stringValue
                    if (self.nextPageToken == "") {
                        self.stopLoadMore = true
                        self.isLoadingMore = true
                    }
                    let items = json["items"].arrayValue
                    var tmp : [YoutubeModel] = self.data
                    for item in items {
                        if !self.checkExistsID(tmp, item["id"]["videoId"].stringValue) {
                            let model = YoutubeModel()
                            model.id = item["id"]["videoId"].string
                            model.chanel = item["snippet"]["channelTitle"].string
                            model.title = item["snippet"]["title"].string
                            model.urlImage = item["snippet"]["thumbnails"]["high"]["url"].string
                            tmp.append(model)
                        }
                    }
                    self.data = tmp
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isLoadingMore = false
                    }
                }
            }
        }
        
    }
    
}
extension ResultViewController :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellYoutube", for: indexPath) as! YoutubeCell
        cell.time.text = "00:00"
        cell.model = data[indexPath.row]
        return cell
    } // flag
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false;
        let alert = UIAlertController(title: "What do you want ?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Chọn", style: UIAlertActionStyle.default, handler: { (_) in
            FirebaseUtils.pushDatabase(youtubeMode: self.data[indexPath.row], vc: self)
        }))
        alert.addAction(UIAlertAction(title: "Xem thử", style: UIAlertActionStyle.default, handler: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil, userInfo: ["id" : self.data[indexPath.row].id])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            // Update UI
            getData()
        }
    }
    func checkExistsID (_ list : [YoutubeModel], _ id : String) -> Bool{
        for index in list {
            if id == index.id! {
                print("replace")
                return true
            }
        }
        return false
    }
}
class YoutubeModel {
    var id : String?
    var urlImage : String?
    var countViews : String?
    var title : String?
    var chanel : String?
    var time : String?
    
    init(id : String, url : String, countViews : String, title : String, chanel : String, time : String) {
        self.id = id
        self.urlImage = url
        self.countViews = countViews
        self.title = title
        self.chanel = chanel
        self.time = time
    }
    init() {
    }
}

