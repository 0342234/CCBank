//
//  ChatTableViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/29/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var containerViewOutlet: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var chatReference: DatabaseReference!
    var userID: String!
    var threadID: String! = ""
    var messages: [MessageModel] = []
    var containerViewController: SendMessageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser!.uid
        let cellNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        let getMessageNib = UINib(nibName: "FromStrangerTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MessageCell")
        tableView.register(getMessageNib, forCellReuseIdentifier: "FromStrangerTableViewCell")
        chatReference = FirebaseReferences.currentThread(threadID: self.threadID).reference()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(leaveChat) )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        chatReference.removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        tableView.reloadData()
        if self.messages.count > 0 {
            let index = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    
    @objc func leaveChat() {
        ThreadFunctions.leaveChat(chatid:threadID )
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardFrame = view.convert(keyboardSize, to: nil)
            view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let navPlusStatusBarHeight = 64.0
        view.frame.origin.y = CGFloat(navPlusStatusBarHeight)
    }
    
    func loadData() {
        chatReference.child("messages").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if snapshot.exists() {
                for child in snapshot.value as! NSDictionary {
                    if let messageObject = child.value as? [String: Any] {
                        let message = messageObject["payload"] as! String
                        let username = messageObject["username"] as! String
                        let userID = messageObject["userID"] as! String
                        let timestamp = messageObject["timestamp"] as! Int
                        let getData = MessageModel(message: message)
                        getData.timestamp = timestamp
                        getData.userID = userID
                        getData.username = username
                        self?.messages.append(getData)
                    }
                }
            }
            self?.messages.sort(by: { (one, two) -> Bool in
                one.timestamp < two.timestamp
            })
        }
        
        chatReference.child("messages").observe( .childAdded) { [weak self] (snapshot) in
            if snapshot.exists() {
                if let messageObject = snapshot.value as? [String: Any] {
                    let message = messageObject["payload"] as! String
                    let username = messageObject["username"] as! String
                    let userID = messageObject["userID"] as! String
                    let timestamp = messageObject["timestamp"] as! Int
                    let getData = MessageModel(message: message)
                    getData.timestamp = timestamp
                    getData.userID = userID
                    getData.username = username
                    
                    if self != nil {
                        self!.messages.append(getData)
                        self!.tableView.reloadData()
                        let index = IndexPath(row: self!.messages.count - 1, section: 0)
                        self!.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
 
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell() as? MessageTableViewCell
        if messages[indexPath.row].userID != userID  {
            cell = tableView.dequeueReusableCell(withIdentifier: "FromStrangerTableViewCell", for: indexPath) as? MessageTableViewCell
            let messageText = messages[indexPath.row].payload
            let dateInt = Double(messages[indexPath.row].timestamp)
            let dateText = NSDate(timeIntervalSince1970: dateInt).toString(dateFormat: "HH:mm")
            let sender = messages[indexPath.row].username
            cell?.setupCell(message: messageText!, time: String(describing: dateText), sender: sender!)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell
            let messageText = messages[indexPath.row].payload
            let dateInt = Double(messages[indexPath.row].timestamp)
            let dateText = NSDate(timeIntervalSince1970: dateInt).toString(dateFormat: "HH:mm")
            let sender = messages[indexPath.row].username
            cell?.setupCell(message: messageText!, time: String(describing: dateText), sender: sender!)
        }
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromChatToSendContainer" {
            containerViewController = segue.destination as? SendMessageViewController
            containerViewController?.chatID = threadID
        }
    }
}
