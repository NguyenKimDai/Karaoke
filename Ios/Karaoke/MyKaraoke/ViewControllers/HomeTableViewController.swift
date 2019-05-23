//
//  HomeTableViewController.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/3/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class HomeTableViewController: UITableViewController {
    
    var data : [YoutubeModel] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CellYoutube", bundle: nil), forCellReuseIdentifier: "CellYoutube")
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        let height = (self.view.frame.width - 60) * 9 / 32
        self.tableView.rowHeight = height + 20
        getDatabases()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "Lựa chọn", message: nil, preferredStyle: .actionSheet)
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let action = UIAlertAction(title: "Hát trước", style: .default) { (action) in
            FirebaseUtils.pushOnTopByID(id: self.data[indexPath.row].id!)
        }
        let actionDelete = UIAlertAction(title: "Xoá", style: .destructive) { (action) in
            FirebaseUtils.removeByID(id: self.data[indexPath.row].id!, indexPath: indexPath)
        }
        let actionRev = UIAlertAction(title: "Xem thử", style: .default) { (action) in
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil, userInfo: ["id" : self.data[indexPath.row].id!])
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(actionRev)
        sheet.addAction(action)
        sheet.addAction(actionDelete)
        sheet.addAction(actionCancel)
        
        //show(sheet, sender: nil)
        self.present(sheet, animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellYoutube", for: indexPath) as! YoutubeCell
        cell.time.text = "00:00"
        cell.model = data[indexPath.row]
        return cell
    }
    @objc func getDatabases(){
        let alert = UIAlertController(title: "Hãy nhập key để kết nối đến screen", message: "", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.keyboardType = .numberPad
        }
        func handler(_ act:UIAlertAction) {
            let tf = alert.textFields![0]
            var listYoutube = [YoutubeModel]()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.key = tf.text!
            NotificationCenter.default.post(name: NSNotification.Name("cuonghx"), object: nil, userInfo: nil)
            let ref = Database.database()
                .reference(withPath: tf.text!)
                .child("YoutubeModel")
            ref.observe(.value, with: { (snapshot) in
                if (snapshot.childrenCount > 0){
                    let dictiondary = snapshot.value as! NSDictionary
                    for dic in dictiondary.allValues {
                        let list = (dic as! [String: Any])["list"] as! NSArray
                        listYoutube = []
                        for item in list{
                            let json = JSON(item)
                            listYoutube.append(YoutubeModel(id: json["id"].stringValue, url: json["thumbnailURL"].stringValue, countViews: json["countViews"].stringValue, title: json["title"].stringValue, chanel: json["chanel"].stringValue, time: json["time"].stringValue))
                        }
                    }
                    self.data = listYoutube
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    }
                }else{
                    self.data = []
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        self.present(alert, animated: true)
    }

}
