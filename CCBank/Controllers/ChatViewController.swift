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
    let userID: String = { return  Auth.auth().currentUser!.uid }()
    var threadID: String! = ""
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatReference = FirebaseReferences.currentThread(threadID: self.threadID).reference()
        

chatReference.child("messages").queryOrderedByKey().observe(.value) { (snapshot) in
    self.messages = []
            if snapshot.exists() {
                for child in snapshot.value as! NSDictionary {
                    let messageObject = child.value as? [String: Any]
                    if let messageObject = messageObject {
                        let message = messageObject["payload"] as? String  ?? ""
                        let timestamp = messageObject["timestamp"] as? Int ?? 0
                        let userID = messageObject["userID"] as? String ?? " Unknown"
                        let getData = Message(payload: message, timestamp: timestamp , userID: userID)
                        self.messages.append(getData)
                    }
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
        let cellNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MessageCell")
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
        cell.messageText.text = messages[indexPath.row].payload
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let messageContainerController = segue.destination as? SendMessageViewController else { return }
        messageContainerController.chatID = threadID
    }
}
