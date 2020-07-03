//
//  ChatDetailViewController.swift
//  MVP
//
//  Created by Theo Vora on 5/1/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import InputBarAccessoryView
import MessageKit
import Firebase
import FirebaseFirestore
import SDWebImage

class ChatDetailViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate { //InputBarAccessoryViewDelegate
    
    // MARK: - Properties
    
    var currentUser = CurrentUserController.shared.currentUser!
    var thread: Thread?
    
    
    // MARK: - Landing pads
    
    var threadID: String?
    var chat: Chat?
    
    
    // MARK: - Maybe not
    var chatListItem: ChatListItem?
    
    
    // USER2 - the user that currentUser is chatting with
    var user2Object: User?
    var user2ImgUrl: String?
    
    
    private var chatDocReference: DocumentReference?
    
    
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user2ImgUrl = "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/batman_hero_avatar_comics-512.png"
        
        
        navigationItem.title = chat?.postTitle
        messageInputBar.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .purple
        messageInputBar.sendButton.setTitleColor(.systemBlue, for: .normal)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
        guard let threadID = threadID else { return }
        
        ChatThreadController.shared.startListener(threadID: threadID) {
            self.messagesCollectionView.reloadData()
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ChatThreadController.shared.stopListener()
    }
    
    
    // MARK: - Collections View Data Source
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return ChatThreadController.shared.messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if ChatThreadController.shared.messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return ChatThreadController.shared.messages.count
        }
    }
    
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        guard let user2 = user2Object else { return }
        let users = [self.currentUser.userUID, user2.uid]
        let data: [String: Any] = [
            "userUids":users //,
            // "offer":"I have 12 cloth masks"
        ]
        
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func loadChat() {
        print("load chat was run")
//        guard let user2 = user2Object else { return }
        
        
        //Fetch all the chats which has current user in it
//        let db = Firestore.firestore().collection("Chats")
//            .whereField("userUids", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
//
//
//        db.getDocuments { (chatQuerySnap, error) in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            } else {
//
//                //Count the no. of documents returned
//                guard let queryCount = chatQuerySnap?.documents.count else {
//                    return
//                }
//
//                if queryCount == 0 {
//                    //If documents count is zero that means there is no chat available and we need to create a new instance
//                    self.createNewChat()
//                }
//                else if queryCount >= 1 {
//                    //Chat(s) found for currentUser
//                    for doc in chatQuerySnap!.documents {
//
//                        let chat = Chat(dictionary: doc.data())
//                        //Get the chat which has user2 id
//                        if (chat?.userUids.contains(user2.uid))! {
//
//                            self.chatDocReference = doc.reference
//                            //fetch it's thread collection
//                            doc.reference.collection("thread")
//                                .order(by: "created", descending: false)
//                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
//                                    if let error = error {
//                                        print("Error: \(error)")
//                                        return
//                                    } else {
//                                        self.messages.removeAll()
//                                        for message in threadQuery!.documents {
//
//                                            let msg = Message(dictionary: message.data())
//                                            self.messages.append(msg!)
//                                            print("Data: \(msg?.content ?? "No message found")")
//                                        }
//                                        self.messagesCollectionView.reloadData()
//                                        self.messagesCollectionView.scrollToBottom(animated: true)
//                                    }
//                                })
//                            return
//                        } //end of if
//                    } //end of for
//                    self.createNewChat()
//                } else {
//                    print("Let's hope this error never prints!")
//                }
//            }
//        }
    }
    
    
    private func insertNewMessage(_ message: Message) {
        
//        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func save(_ message: Message, completion: @escaping (DocumentReference, String, Timestamp) -> Void) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID
        ]
        
        var ref: DocumentReference? = nil
        
        ref = chatDocReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
            completion(ref!, message.content, message.created)
            
        })
    }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(senderId: currentUser.userUID, displayName: currentUser.fullName)
        
    }
    
    
    
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentUser.userUID {
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
        
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatDetailViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if let chat = chat,
            let threadID = threadID {
            
            
            ChatThreadController.shared.sendMessage(askerUID: chat.askerUID,
                                                    postOwnerUID: chat.postOwnerUID,
                                                    threadID: threadID,
                                                    senderUID: currentUser.userUID,
                                                    text: text)
            
            
            
            
            //        let message = Message(id: "",
            //                              content: text,
            //                              created: Timestamp(),
            //                              senderID: currentUser.userUID)
            
            //        insertNewMessage(message)
            //        save(message, completion: )
            //        save(message) { (lastMsgDocRef, messageText, timestamp) in
            //            // save lastMsgDocRef in Chat document in Firestore
            //
            //            guard let chatListItem = self.chatListItem else { return }
            //
            //            ChatListController.shared.updateLastMsg(chatListItem: chatListItem, lastMsgDocRef: lastMsgDocRef, messageText: messageText, messageTime: timestamp)
            //        }
            
            inputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        } else {
            print("error: something's wrong with either chat or threadID. chat = \(chat). threadID = \(threadID)")
        }
    }
}
