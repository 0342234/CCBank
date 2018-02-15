//
//  ChatViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 26.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Scene Dock Control
    @IBOutlet var sceneDockView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func noButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            self.blurView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - 600)
            self.blurView.alpha = 0
        }){ _ in
            self.blurView.removeFromSuperview()
            self.sceneDockView.removeFromSuperview()
            self.blurView.transform = .identity
        }
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        var chatTitle: String  = ""
        if titleTextField.text!.isEmpty {
            titleTextField.attributedPlaceholder = NSAttributedString(string: "Type title for new chat", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            UIView.animate(withDuration: 3, animations: {
                self.titleTextField.attributedPlaceholder = NSAttributedString(string: "Type title for new chat", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
                self.titleTextField.text = ""
            })
            return
        }
        else {
            chatTitle = titleTextField.text!
            ThreadModel(title: chatTitle).addThread()
        }
        sceneDockView.removeFromSuperview()
        blurView.removeFromSuperview()
        blurView.alpha = 0
    }
    
    // MARK: - Channels Methods
    
    @IBOutlet weak var tableView: UITableView!
    
    private var userID: String!
    private var chatUIDS: [String] = []
    private var threads: [ThreadModel] = []
    private var threadsReference: DatabaseReference!
    private var chatUID = ""
    
    var blurView = UIView {
        $0.alpha = 0.0
        $0.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        $0.frame = CGRect(x: 0 , y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser?.uid
        threadsReference = FirebaseReferences.threads.reference()
        
        //úi
        navigationItem.title = "Channels"
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(invokeSubView))
        let cellXib = UINib(nibName: "ChannelsTableViewCell", bundle: nil)
        tableView.register(cellXib, forCellReuseIdentifier: "ChannelCell")
    }
    
    func setupObservers() {
        threadsReference.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            self.threads = []
            if snapshot.exists() {
                
                let values = snapshot.value as! NSDictionary
                    for child in values {
                        print(child)
                    self.chatUIDS.append(child.key as! String)
                    let childValues = child.value as! [String : Any]
                    let title = childValues["title"] as! String
                    let dataObject = ThreadModel(title: title)
                    self.threads.append(dataObject)
                    
                }
            }
            })
        self.tableView.reloadData()
  
        threadsReference.observe(.childAdded) { [unowned self] (snapshot) in
            if snapshot.exists() {
                self.chatUIDS.append(snapshot.key)
                if let child = snapshot.value as? NSDictionary {
                    let title = child["title"] as! String
                    let thread = ThreadModel(title: title)
                    self.threads.append(thread)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupObservers()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        threads = []
        threadsReference.removeAllObservers()
    }
    
    @objc func invokeSubView() {
        blurView.center = view.center
        sceneDockView.center = blurView.center
        self.view.addSubview(blurView)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0.9
            self.sceneDockView.alpha = 1
        }) { (sucess) in
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.addSubview(self.sceneDockView)
            })
        }
    }
    
    @objc func logOut() {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "FromChatToLogin", sender: nil)
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ChannelCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChannelsTableViewCell
        let threadTitle: String! = threads[indexPath.row].title
        let threadUsers: Int! = threads[indexPath.row].usersAmount
        cell?.setupCell(threadTitle: threadTitle, numberOfUsers: threadUsers)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatUID = chatUIDS[indexPath.row]
        FirebaseReferences.currentThread(threadID: chatUID).reference().runTransactionBlock { [unowned self] (mutableData) -> TransactionResult in
            if var data = mutableData.value as? [String: AnyObject] {
                var usersAmount: Int
                var users: Dictionary<String, Any>
                usersAmount = data["usersAmount"] as? Int ?? 0
                users = data["users"] as? [ String: String] ?? [:]
                usersAmount += 1
                var username: String = ""
                let reference  = FirebaseReferences.users.reference().child(self.userID)
                reference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    if let data = dataSnapshot.value as? [ String : String] {
                        username = data["username"]!
                    }
                })
                users[self.userID] = username
                data["users"] = users as AnyObject?
                data["usersAmount"] = usersAmount as AnyObject?
                mutableData.value = data
            }
            return TransactionResult.success(withValue: mutableData)
        }
        performSegue(withIdentifier: "FromChannelsToChat", sender: chatUID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromChannelsToChat" {
            let chatController = segue.destination as! ChatViewController
            chatController.threadID = sender as! String
        }
    }
}


