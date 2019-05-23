//
//  SuggestionTableViewCell.swift
//  MyKaraoke
//
//  Created by cuonghx on 11/30/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit
import Alamofire
protocol SuggestionCellDelegate {
    func changeTextRequest(_ text : String)
}

class SuggestionTableViewCell: UITableViewCell {
    
    var relativeValue : String?
    var delegate : SuggestionCellDelegate?
    
    let imageViewLeft : UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = UIColor.red
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "search")
        return iv
    }()
    let imageViewRight : UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = UIColor.red
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "arrow")?.imageWithInsets(insets: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100))
        return iv
    }()
    let textlb : UILabel = {
        let lb = UILabel()
        lb.text = "Heloo0000jaf;ka;akl;akf;lak;lfk;lak;akf;lka;;k;l"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    var searchVC : SearchViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(imageViewLeft)
        addSubview(imageViewRight)
        addSubview(textlb)
        
        imageViewRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerImageRight)))
        imageViewRight.isUserInteractionEnabled = true
        
        addConstrainsWithFormat("H:|-16-[v0(20)]-16-[v1]", imageViewLeft, textlb)
        addConstrainsWithFormat("H:[v0(50)]|", imageViewRight)
        addConstrainsWithFormat("V:|-16-[v0(20)]-16-|", imageViewLeft)
        addConstrainsWithFormat("V:[v0(50)]|", imageViewRight)
        addConstrainsWithFormat("V:|-16-[v0]-16-|", textlb)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @objc func handlerImageRight(){
        self.searchVC?.textChange = self.relativeValue ?? ""
        delegate?.changeTextRequest(self.relativeValue ?? "")
    }
}
