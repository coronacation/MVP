//
//  ChatListTableViewCell.swift
//  MVP
//
//  Created by Theo Vora on 7/6/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import SDWebImage

class ChatListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var chat: Chat? {
        didSet {
            guard let chat = chat else { return }
            
            firstNameLabel.text = chat.otherUserFirstName
            offerLabel.text = chat.postTitle
            lastMessageLabel.text = chat.lastMsg
            timeAgoLabel.text = chat.lastMsgTimeAgo
            SDWebImageManager.shared.loadImage(with: URL(string: chat.otherUserPhotoURL), options: .highPriority, progress: nil) { (image, _, _, _, _, _) in
                self.avatarImageView.image = image
            }
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
