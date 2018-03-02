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
    
    var blurView = UIView {
        $0.alpha = 0.0
        $0.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        $0.frame = CGRect(x: 0 , y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        print($0.frame)
        $0.isOpaque = false
    }
    
    @IBOutlet var sceneDockView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @objc func invokeSubView() {
        sceneDockView.center = self.blurView.center
        self.view.addSubview(blurView)
        sceneDockView.frame.origin.y = 1400
        UIView.animate(withDuration: 2, animations: {
            self.blurView.alpha = 0.9
            self.sceneDockView.alpha = 1
            self.blurView.addSubview(self.sceneDockView)
            self.sceneDockView.frame.origin.y = (self.blurView.frame.origin.y / 2)
            
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                
            })
        }
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            self.blurView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - 600)
            self.blurView.alpha = 0
        }){ [unowned self] _ in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser?.uid
        threadsReference = FirebaseReferences.threads.reference()
        
        //úi
       
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(invokeSubView))
        let cellXib = UINib(nibName: "ChannelsTableViewCell", bundle: nil)
        tableView.register(cellXib, forCellReuseIdentifier: "ChannelCell")
    }
    
    func setupObservers() {
        threadsReference.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            self.threads = []
            self.chatUIDS = []
            if snapshot.exists() {
                let values = snapshot.value as! NSDictionary
                for child in values {
                    self.chatUIDS.append(child.key as! String)
                    let childValues = child.value as! [String : Any]
                    let title = childValues["title"] as! String
                    let users = childValues["users"] as! [String : String]
                    let dataObject = ThreadModel(title: title)
                    dataObject.users = users
                    self.threads.append(dataObject)
                }
            }
        })
        self.tableView.reloadData()
        threadsReference.observe(.childAdded) { [unowned self] (snapshot) in
            if snapshot.exists() {
                if let child = snapshot.value as? NSDictionary {
                    self.chatUIDS.append(snapshot.key)
                    let title = child["title"] as! String
                    let users = child["users"] as! [String : String]
                    let thread = ThreadModel(title: title)
                    thread.users = users
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
        chatUIDS = []
        threadsReference.removeAllObservers()
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
        let threadUsers: Int! = threads[indexPath.row].users?.count
        cell?.setupCell(threadTitle: threadTitle, numberOfUsers: threadUsers)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatUID = chatUIDS[indexPath.row]
        ThreadFunctions.enterChat(chatid: chatUID, userid: userID)
        performSegue(withIdentifier: "FromChannelsToChat", sender: chatUID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromChannelsToChat" {
            let chatController = segue.destination as! ChatViewController
            chatController.threadID = sender as! String
        }
    }
}


