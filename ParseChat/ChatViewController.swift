//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Kyle Ohanian on 1/29/18.
//  Copyright © 2018 Kyle Ohanian. All rights reserved.
//

import UIKit
import Parse


class Message: PFObject, PFSubclassing {
    // properties/fields must be declared here
    // @NSManaged to tell compiler these are dynamic properties

    @NSManaged var message: String?
    @NSManaged var user: String?
    
    // returns the Parse name that should be used
    class func parseClassName() -> String {
        return "Message"
    }
}


class ChatCell: UITableViewCell {
    @IBOutlet weak var chatTextLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
}

var messages: [PFObject]?

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        let currMessage = messages?[indexPath.row] as! Message?
        chatCell.chatTextLabel.text = currMessage?.message
        chatCell.userLabel.text = currMessage?.user
        return chatCell
    }
    

    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBAction func onSendMessage(_ sender: Any) {
        
        let chatMessage = Message()
        chatMessage.message = messageTextField.text ?? ""
        chatMessage.user = PFUser.current()?.username
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.fetchAllMessages()
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTableView.delegate = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer() {
        fetchAllMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAllMessages() {
        var query = Message.query()
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                messages = posts
                self.chatTableView.reloadData();
            } else {
                print(error?.localizedDescription)
            }
        }
            
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
