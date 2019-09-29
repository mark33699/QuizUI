//
//  TeamMemberTableViewCell.swift
//  QuizUI
//
//  Created by Mark33699 on 2019/9/26.
//  Copyright © 2019 eLove_ePhone. All rights reserved.
//

import UIKit

class TeamMemberTableViewCell: UITableViewCell
{
    
    let avatar = UIImageView()
    let name = UILabel()
    let title = UILabel()
    let bio = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        func setupView(_ view: UIView, visualFormatH: String, visualFormatV: String)
        {
            view.backgroundColor = .lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
            
            let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: visualFormatH,
                                                              options: .init(),
                                                              metrics: nil,
                                                              views: ["avatar": avatar, "name": name, "title": title, "bio": bio])
            let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: visualFormatV,
                                                              options: .init(),
                                                              metrics: nil,
                                                              views: ["avatar": avatar, "name": name, "title": title, "bio": bio])
            self.contentView.addConstraints(constraintsH)
            self.contentView.addConstraints(constraintsV)
        }
        
        let views: [(UIView,String,String)] =  [(avatar , "H:|-16-[avatar(100)]", "V:|-16-[avatar(100)]"),
                                                (name, "H:[avatar]-16-[name]-16-|", "V:|-16-[name]"),
                                                (title, "H:[avatar]-16-[title]-16-|", "V:[name]-16-[title]"),
                                                (bio, "H:|-16-[bio]-16-|", "V:[avatar]-16-[bio]-16-|")]
        
        views.forEach
        { (view, horizontal, vertical) in
            
            setupView(view, visualFormatH: horizontal, visualFormatV: vertical)
        }
        bio.numberOfLines = 0
        
    }
    
    func updateUIWith(_ teamMember: TeamMember)
    {
        name.text = teamMember.firstName + " " + teamMember.lastName
        title.text = teamMember.title
        bio.text = teamMember.bio
        avatar.image = UIImage.init(named: "defaultAvatar")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
