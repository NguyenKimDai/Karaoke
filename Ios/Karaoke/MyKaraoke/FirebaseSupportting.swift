//
//  FirebaseSupportting.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/29/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class FirebaseUtils {
    static var ref : DatabaseReference!
    
    static func pushDatabase(youtubeMode: YoutubeModel, vc : UIViewController){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ref = Database.database().reference(withPath: appDelegate.key).child("YoutubeModel")
        ref.observeSingleEvent(of: .value) { (datasnapshot) in
            if datasnapshot.childrenCount > 0{
                let dictiondary = datasnapshot.value as! NSDictionary
                for (key, value) in dictiondary{
                    let list = (value as! [String: Any])["list"] as! NSArray
                    var newlist = [YoutubeModel]()
                    
                    for item in list{
                        let json = JSON(item)
                        newlist.append(YoutubeModel(id: json["id"].stringValue, url: json["thumbnailURL"].stringValue, countViews: json["countViews"].stringValue, title: json["title"].stringValue, chanel: json["chanel"].stringValue, time: json["time"].stringValue))
                    }
                    newlist.append(youtubeMode)
                    print(newlist.count)
                    
                    let fireBaseModel = FireBaseModelYoutube(list: newlist)
                    
                    ref.child(key as! String).setValue(fireBaseModel.dict)
                    
                    let alert = UIAlertController(title: nil, message: "Success! ", preferredStyle: .actionSheet)
                    alert.view.backgroundColor = UIColor.black
                    alert.view.alpha = 0.6
                    alert.view.layer.cornerRadius = 15
                    
                    vc.present(alert, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        alert.dismiss(animated: true)
                    }
                }
            }else {
                var newlist = [YoutubeModel]()
                newlist.append(youtubeMode)
                let fireBaseModel = FireBaseModelYoutube(list: newlist)
                
                ref.childByAutoId().setValue(fireBaseModel.dict)
                
            }
            
        }
    }
    
    static func removeByID(id: String, indexPath: IndexPath){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ref = Database.database().reference(withPath: appDelegate.key).child("YoutubeModel")
        ref.observeSingleEvent(of: .value) { (datasnapshot) in
            if datasnapshot.childrenCount > 0{
                let dictiondary = datasnapshot.value as! NSDictionary
                for (key, value) in dictiondary{
                    let list = (value as! [String: Any])["list"] as! NSArray
                    var newlist = [YoutubeModel]()
                    for item in list{
                        let json = JSON(item)
                        if(json["id"].stringValue != id){
                            newlist.append(YoutubeModel(id: json["id"].stringValue, url: json["thumbnailURL"].stringValue, countViews: json["countViews"].stringValue, title: json["title"].stringValue, chanel: json["chanel"].stringValue, time: json["time"].stringValue))
                        }
                    }
                    
                    let fireBaseModel = FireBaseModelYoutube(list: newlist)
                    ref.child(key as! String).setValue(fireBaseModel.dict)
                }
            }else {
                print("else")
            }
            
        }
    }
    
    static func pushOnTopByID(id: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ref = Database.database().reference(withPath: appDelegate.key).child( "YoutubeModel")
        ref.observeSingleEvent(of: .value) { (datasnapshot) in
            if datasnapshot.childrenCount > 0{
                let dictiondary = datasnapshot.value as! NSDictionary
                for (key, value) in dictiondary{
                    let list = (value as! [String: Any])["list"] as! NSArray
                    var newlist = [YoutubeModel]()
                    
                    for item in list{
                        let json = JSON(item)
                        newlist.append(YoutubeModel(id: json["id"].stringValue, url: json["thumbnailURL"].stringValue, countViews: json["countViews"].stringValue, title: json["title"].stringValue, chanel: json["chanel"].stringValue, time: json["time"].stringValue))
                    }
                    
                    for index in 0..<newlist.count{
                        if id == newlist[index].id {
                            let tmp = newlist[index];
                            newlist.remove(at: index)
                            newlist.insert(tmp, at: 0)
                            break
                        }
                    }
                    
                    
                    let fireBaseModel = FireBaseModelYoutube(list: newlist)
                    
                    ref.child(key as! String).setValue(fireBaseModel.dict)
                }
            }else {
                print("else")
            }
        }
    }
    
    static func pushNext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ref = Database.database().reference(withPath: appDelegate.key).child("Status")
        ref.observeSingleEvent(of: .value) { (datasnapshot) in
            if datasnapshot.childrenCount > 0{
                let dictiondary = datasnapshot.value as! NSDictionary
                for (key, value) in dictiondary{
                    let status = (value as! [String: Any])["status"] as! String
                    if status == "play"{
                        let v = ["status": "next"]
                        ref.child(key as! String).setValue(v)
                    }
                }
            }else {
                let v = ["status": "next"]
                ref.childByAutoId().setValue(v)
            }
        }
    }
    
    class FireBaseModelYoutube{
        var list: [YoutubeModel]
        init(list: [YoutubeModel]) {
            self.list = list
        }
        
        var dict:[String:Any] {
            
            return [
                "list": getList()
            ]
        }
        
        func getList() -> [[String: Any]] {
            var r = [[String: Any]]()
            
            for index in 0..<list.count{
                let item = list[index]
                var content = [String: Any]()
                content["id"] = item.id
                content["thumbnailURL"] = item.urlImage
                content["chanel"] = item.chanel
                content["title"] = item.title
                content["countViews"] = item.countViews
                content["time"] = item.time
                r.append(content)
            }
            return r
        }
    }
}
