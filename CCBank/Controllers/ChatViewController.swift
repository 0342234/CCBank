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
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser!.uid
        let cellNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MessageCell")
        chatReference = FirebaseReferences.currentThread(threadID: self.threadID).reference()
    }

    func loadData() {
        chatReference.child("messages").observeSingleEvent(of: .value) {(snapshot) in
            if snapshot.exists() {
                for child in snapshot.value as! NSDictionary {
                    if let messageObject = child.value as? [String: Any] {
                        let message = messageObject["payload"] as! String
                        let username = messageObject["username"] as! String
                        let userID = messageObject["userID"] as! String
                        let timestamp = messageObject["timestamp"] as! Int
                        let getData = Message(message: message)
                        getData.timestamp = timestamp
                        getData.userID = userID
                        getData.username = username
                        self.messages.append(getData)
                    }
                }
            }
            self.messages.sort(by: { (one, two) -> Bool in
                one.timestamp < two.timestamp
            })
        }
        
        chatReference.child("messages").observe( .childAdded) {(snapshot) in
            if snapshot.exists() {
                if let messageObject = snapshot.value as? [String: Any] {
                    let message = messageObject["payload"] as! String
                    let username = messageObject["username"] as! String
                    let userID = messageObject["userID"] as! String
                    let timestamp = messageObject["timestamp"] as! Int
                    let getData = Message(message: message)
                    getData.timestamp = timestamp
                    getData.userID = userID
                    getData.username = username
                    self.messages.append(getData)
                    self.tableView.reloadData()
                    let index = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let messageText = messages[indexPath.row].payload
        let dateInt = Double(messages[indexPath.row].timestamp)
        let dateText = NSDate(timeIntervalSince1970: dateInt).toString(dateFormat: "HH:mm")
        cell.setupCell(message: messageText!, time: String(describing: dateText))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let messageContainerController = segue.destination as? SendMessageViewController else { return }
        messageContainerController.chatID = threadID
    }
}
