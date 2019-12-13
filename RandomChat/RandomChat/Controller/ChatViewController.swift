//
//  ViewController.swift
//  RandomChat
//
//  Created by Ziping Huang on 12/5/19.
//  Copyright © 2019 Ziping Huang. All rights reserved.
//


// tutorial source: https://learnappmaking.com/chat-app-ios-firebase-swift-xcode/

import UIKit
import JSQMessagesViewController
import Photos

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    
    //chat bubble colors
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()

    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard

        if  let id = defaults.string(forKey: "jsq_id"),
            let name = defaults.string(forKey: "jsq_name")
        {
            senderId = id
            senderDisplayName = name
        }
        else
        {
            senderId = String(arc4random_uniform(999999))
            senderDisplayName = ""

            defaults.set(senderId, forKey: "jsq_id")
            defaults.synchronize()

            showDisplayNameDialog()
        }

        title = "RandomChat: [\(senderDisplayName!)]"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1

        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        
       
        //inputToolbar.contentView.leftBarButtonItem = nil
        
          //avatar
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.init(width: 30, height: 30)
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.init(width: 30, height: 30)
        
        
        
        
        // observing Firebase data
        let query = channel.refs.databaseChats.queryLimited(toLast: 10)

        _ = query.observe(.childAdded, with: { [weak self] snapshot in

            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)

                    self?.finishReceivingMessage()
                }
            }
        })
        
    }
    
    //setting display name with alert
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard

        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)

        alert.addTextField { textField in

            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                let names = ["anonymous", "bob", "monkey"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in

            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {

                self?.senderDisplayName = textField.text

                self?.title = "RandomChat: [\(self!.senderDisplayName!)]"

                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))

        present(alert, animated: true, completion: nil)
    }
    
    
    //message collection
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    //avatar collection view
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let AvatarImg = JSQMessagesAvatarImage.init(avatarImage: #imageLiteral(resourceName: "Image"), highlightedImage: #imageLiteral(resourceName: "Image"), placeholderImage: #imageLiteral(resourceName: "Image"))
        
        return AvatarImg
    }
    
    //Set the name label for message bubbles
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    //sending a chat message
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = channel.refs.databaseChats.childByAutoId()

        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]

        ref.setValue(message)

        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Send Image")
    }

    
    
    
    
    
}

