//
//  YoutubeCell.swift
//  YoutubeApp
//
//  Created by cuonghx on 5/1/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SkeletonView


class YoutubeCell: UITableViewCell {
    
    var imageContentView : UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .red
        iv.layer.masksToBounds = true
//        iv.layer.cornerRadius = 15
        iv.isSkeletonable = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    var time : UILabel = {
        let label = PaddingLabel(withInsets: 2, 2, 5, 5)
        label.text = "00:00"
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.isSkeletonable = true
        return label
    }()
    var textViewTittle : UILabel = {
        let tv = UILabel()
        tv.text = "Abcdddddddddjljalfjlajlfajljfaljlajfljaljalf00000000000000000000"
        tv.numberOfLines = 3
        tv.font = UIFont (name: "Helvetica Neue", size: 16)
        return tv
    }()
    var textChanel : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.text = "Cuonghx"
        lb.font = UIFont (name: "Helvetica Neue", size: 14)
        lb.textColor = UIColor.gray
        return lb
    }()
    var textViews : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = UIColor.gray
        lb.text = "120K"
        lb.font = UIFont (name: "Helvetica Neue", size: 14)
        return lb
    }()
    
    var model : YoutubeModel? {
        didSet {
            self.textViewTittle.text = model?.title
            self.textChanel.text = model?.chanel
            let url = URL(string: (model?.urlImage)!)
            imageContentView.kf.setImage(with: url)
            
            Alamofire.request("https://www.googleapis.com/youtube/v3/videos?id=\(model!.id!)&fields=items(contentDetails/duration)&part=contentDetails&key=\(key)").response { (res) in
                if let data = res.data {
                    let json = JSON(data)
                    let items = json["items"].arrayValue
                    if items.count > 0 {
                        let item = items[0]
                        let duration = item["contentDetails"]["duration"].stringValue
                        let time = duration.parseVideoDurationOfYoutubeAPI(videoDuration: duration)
                        DispatchQueue.main.async {
                            self.time.text = time
                            if time == "00:00" {
                                self.time.text = "Live"
                            }
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.time.text = "00:00"
                        }
                    }
                    
                }
            }
            Alamofire.request("https://www.googleapis.com/youtube/v3/videos?part=statistics&id=\(model!.id!)&fields=items(id,statistics/viewCount)&key=\(key)").response { (res) in
                if let data = res.data {
                    let json = JSON(data)
                    var viewCount = 0
                    for index in json["items"].arrayValue{
                        viewCount = index["statistics"]["viewCount"].intValue
                    }
                    let count = self.formatPoints(num: viewCount)
                    DispatchQueue.main.async {
                        self.textViews.text = count
                    }
                }
            }
        }
    }
    
    func formatPoints(num: Int) -> String {
        let newNum = String(num / 1000)
        var newNumString = "\(num) lượt xem"
        if num > 1000 && num < 1000000 {
            newNumString = "\(newNum) N luợt xem"
        } else if num > 1000000 {
            let TrnewNum = String(num / 1000000)
            newNumString = "\(TrnewNum) Tr lượt xem"
        }
        
        return newNumString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        addSubview(imageContentView)
        imageContentView.addSubview(time)
        time.sizeToFit()
        time.frame.size.width = time.intrinsicContentSize.width + 10
        time.frame.size.height = time.intrinsicContentSize.height + 10
        time.textAlignment = .center
        imageContentView.addConstrainsWithFormat("H:[v0]-8-|", time)
        imageContentView.addConstrainsWithFormat("V:[v0]-8-|", time)
        
        
        
        let width = (self.frame.width - 60)  / 2
        let height = width * 9 / 16
        addSubview(textViewTittle)
        addSubview(textChanel)
        addSubview(textViews)
        
        addConstrainsWithFormat("H:|-16-[v0(\(width))]-16-[v1]-16-|", self.imageContentView, textViewTittle)
        addConstrainsWithFormat("H:[v0]-16-[v1]-16-|", self.imageContentView, textChanel)
        addConstrainsWithFormat("H:[v0]-16-[v1]-16-|", self.imageContentView, textViews)
        addConstrainsWithFormat("V:|-16-[v0(\(height))]", self.imageContentView)
        addConstrainsWithFormat("V:|-16-[v0][v1][v2]", textViewTittle, textChanel, textViews)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
