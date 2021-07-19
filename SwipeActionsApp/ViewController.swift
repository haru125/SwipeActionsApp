//
//  ViewController.swift
//  SwipeActionsApp
//
//  Created by Satoshi Ota on 2021/07/17.
//

import UIKit

class User {
    let name: String
    var isFavorite: Bool
    var isMuted: Bool
    
    init(name: String, isFavorite: Bool, isMuted: Bool) {
        self.name = name
        self.isFavorite = isFavorite
        self.isMuted = isMuted
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    private let table: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    var users: [User] = [
        "jhon Smith",
        "Dan Smith",
        "Ben Smith",
        "Rob Smith",
        "Amy Smith",
        "Jill Smith",
    ].compactMap({
        User(name: $0, isFavorite: false, isMuted: false)
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        title = "Swipe Actions"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            self.users.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
        let user = users[indexPath.row]
        let favoriteActionTitle = user.isFavorite ? "Unfavorite" : "Favorite"
        let muteActionTitle = user.isMuted ? "Unmute" : "Mute"
        
        let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteActionTitle) { _, indexPath in
            self.users[indexPath.row].isFavorite.toggle()
            self.table.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let muteAction = UITableViewRowAction(style: .normal, title: muteActionTitle) { _, indexPath in
            self.users[indexPath.row].isMuted.toggle()
            self.table.reloadRows(at: [indexPath], with: .automatic)
        }
        
        favoriteAction.backgroundColor = .systemBlue
        muteAction.backgroundColor = .systemOrange
        
        return [muteAction, favoriteAction, deleteAction]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        if user.isFavorite {
            cell.backgroundColor = .systemBlue
        } else if user.isMuted {
            cell.backgroundColor = .systemOrange
        } else {
            cell.backgroundColor = nil
        }
        return cell
    }
}

