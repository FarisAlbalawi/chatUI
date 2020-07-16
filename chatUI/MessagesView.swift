//
//  MessagesView.swift
//  chatUI
//
//  Created Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.


import UIKit


class chatUI: MessagesUI {
    var sgView = chatStickersView()
    
    override var style: MessegesStyle {
        var style = ChatKit.Styles
            style.showingAvataer = false
//          style.isSupportAudio = false
//          style.isSupportImages = false
//          style.isSupportQuickEmoji = false

        return style
    }
    
   override func updateUIElements() {
        sgView.backgroundColor = .systemGray6
        self.stickersView = sgView
    }
    
}

class MessagesView: UIViewController {
    
    
    let userTim = User(userId: "1", fullname: "Time", avatar: #imageLiteral(resourceName: "audio_icon"))
    let userFaris = User(userId: "2", fullname: "Faris", avatar: #imageLiteral(resourceName: "emoji_3"))
    let goh = User(userId: "3", fullname: "goh", avatar: #imageLiteral(resourceName: "emoji_3"))
    
    let image1 = UIImage(named: "image1")
    let image2 = UIImage(named: "image2")
    let image3 = UIImage(named: "me")
    
    private var ui = chatUI()
    var viewModel = MessagesViewModel()

    override func viewWillDisappear(_ animated: Bool) {
        view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
    }
    
     var messagesData = [[Messages]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func loadView() {
        ui.parentViewController = self
        ui.dataSource = self
        ui.inputDelegate = self
        ui.sgView.stickerGifDelegate = self
        view = ui
    
        ui.currentUser = userTim
        setNavigationBar()
        // test array
         let messagesFromServer = [
            
            Messages(objectId: "1331", user: userTim, image: image1!, text: "text", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: false),
            
            Messages(objectId: "1323", user: userTim, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: false),
            
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: true),
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
            
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
            
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
            
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
            
            Messages(objectId: "1323", user: goh, text: "Lorem Ipsum is simply", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
         ]
        
        
        MessagesViewModel.shared.GroupedMessages(Messages: messagesFromServer) { (messages) in
             self.messagesData = messages
            self.ui.tableView.reloadData()
             DispatchQueue.main.async {
                self.ui.tableView.scrollToBottom(animated: false)
                self.ui.tableView.layoutIfNeeded()
                self.ui.tableView.setContentOffset(CGPoint(x: 0, y: self.ui.tableView.contentSize.height - self.ui.tableView.frame.height - 20), animated: false)
    
             }
         }
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.ui.setUsersTyping([self.userFaris])
            self.ui.tableView.setContentOffset(CGPoint(x: 0, y: self.ui.tableView.contentSize.height - self.ui.tableView.frame.height), animated: true)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let now = Date()
            let NewMessages = Messages(objectId: "12321", user: self.userFaris, text: "Welcome to chatKit ❤️", createdAt: now, isIncoming: true)
                self.insert(NewMessages)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
           self.ui.setUsersTyping([])
           let now = Date()
           let NewMessages = Messages(objectId: "12321", user: self.userFaris, text: "I'm still working on it, I will get it done as soon as possible.", createdAt: now, isIncoming: true)
             self.insert(NewMessages)
           }
        

        
    }
    

    func setNavigationBar() {
        navigationItem.title = "Messages"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.tintColor = .systemBackground
    }
    
    func insert(_ NewMessages: Messages) {
        
         let diff = Calendar.current.dateComponents([.day], from: Date(), to: ( messagesData.last?.last?.createdAt)!)
          if diff.day == 0 {
             MessagesViewModel.shared.object[self.messagesData.count - 1].append(NewMessages)
               self.messagesData[self.messagesData.count - 1].append(NewMessages)
               let loc =  self.ui.tableView.contentOffset
                 UIView.performWithoutAnimation {
                   self.ui.tableView.reloadData()
                   self.ui.tableView.layoutIfNeeded()
                   self.ui.tableView.beginUpdates()
                   self.ui.tableView.endUpdates()
                   self.ui.tableView.layer.removeAllAnimations()
                 }
               self.ui.tableView.setContentOffset(loc, animated: true)
               DispatchQueue.main.async {
                    self.ui.tableView.scrollToBottom(animated: true)
                    self.ui.tableView.layoutIfNeeded()
                    self.ui.tableView.setContentOffset(CGPoint(x: 0, y: self.ui.tableView.contentSize.height - self.ui.tableView.frame.height - 20), animated: true)
               }
             
         } else {
             MessagesViewModel.shared.object.insert([NewMessages], at: self.messagesData.count)
             self.messagesData.insert([NewMessages], at: self.messagesData.count)
             
            let loc =  self.ui.tableView.contentOffset
              UIView.performWithoutAnimation {
                self.ui.tableView.reloadData()
                self.ui.tableView.layoutIfNeeded()
                self.ui.tableView.beginUpdates()
                self.ui.tableView.endUpdates()
                self.ui.tableView.layer.removeAllAnimations()
              }
             self.ui.tableView.setContentOffset(loc, animated: true)
             DispatchQueue.main.async {
                 self.ui.tableView.scrollToBottom(animated: true)
                 self.ui.tableView.layoutIfNeeded()
                 self.ui.tableView.setContentOffset(CGPoint(x: 0, y: self.ui.tableView.contentSize.height - self.ui.tableView.frame.height), animated: true)
             }
            
  

         }
    }

    
}


extension MessagesView: DataSource {
    func message(for indexPath: IndexPath) -> Messages {
        return self.messagesData[indexPath.section][indexPath.row]
    }
    
    func headerTitle(for section: Int) -> [Messages] {
        return self.messagesData[section]
    }
    
    func numberOfSections() -> Int {
        return self.messagesData.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return self.messagesData[section].count
    }
    

    
}

// MARK: - MessageLabelDelegate

extension MessagesView {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }

}


extension MessagesView: inputDelegate {
    
    func startTyping() {
        print("Debug: start Typing")
    }
    
    func stopTyping() {
        print("Debug: stop Typing")
    }
    
    func sendText(text: String) {
        let now = Date()
        let NewMessages = Messages(objectId: "12321", user: userTim, text: text, createdAt: now, isIncoming: false)
        self.insert(NewMessages)
        
    }
    
    func SendAudio(url: URL) {
        let now = Date()
        let NewMessages = Messages(objectId: "12321", user: userTim, audio: url, createdAt: now, isIncoming: false)
        self.insert(NewMessages)
    }
    
    func SendEmoji(emoji: String) {
        let image = UIImage(named: emoji)!
        let now = Date()
        let NewMessages = Messages(objectId: "23223", user: userTim, sticker: image, createdAt: now, isIncoming: false)
        self.insert(NewMessages)
    }
    
    func SendImage(image: UIImage, caption: String?) {
        let now = Date()
        if caption == nil {
            let NewMessages = Messages(objectId: "324243", user: userTim, image: image, createdAt: now, isIncoming: false)
            self.insert(NewMessages)
        } else {
            let NewMessages = Messages(objectId: "324243", user: userTim, image: image, text: caption, createdAt: now, isIncoming: false)
            self.insert(NewMessages)
        }
        
    }
}
extension MessagesView: stickersGifDelegate {
    func sendSticker(name: String) {
        let image = UIImage(named: name)!
        let now = Date()
        let NewMessages = Messages(objectId: "23223", user: userTim, sticker: image, createdAt: now, isIncoming: false)
        self.insert(NewMessages)
    }
    func SendGif(name: String) {
        let image = UIImage.gif(name: name)!
        let now = Date()
        let NewMessages = Messages(objectId: "23223", user: userTim, sticker: image, createdAt: now, isIncoming: false)
        self.insert(NewMessages)
    }
}
