//
//  FriendsViewController.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 18.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import CoreData

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showUsersListBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var noFriendsListLabel: UILabel!
    
    var viewModel = FriendsViewModel()
    
    struct Constants {
        static var userTableViewCell             = "UserTableViewCell"
        static var usersViewController           = "UsersViewController"
        static var profileTableViewController    = "ProfileTableViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        showUsersListBarButtonItem.rx.tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: Constants.usersViewController, sender: nil)
            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(UserData.self)
            .subscribe(onNext: {
                self.performSegue(withIdentifier: Constants.profileTableViewController, sender: $0)
            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelDeleted(UserData.self)
            .subscribe(onNext: {
                self.viewModel.markFriends(uuid: $0.uuid)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.friends.bind(to: tableView.rx.items(cellIdentifier: Constants.userTableViewCell)) { (index: Int, model: UserData, cell: UserTableViewCell) in
            cell.nameLabel.text = "\(model.firstName) \(model.lastName)"
            guard let image = model.image else { return }
            cell.avatarImageView.image = UIImage(data: image)
        }
        .disposed(by: rx.disposeBag)
        
        viewModel.noFriendsText
            .bind(to: noFriendsListLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.hasFriends
            .bind(to: noFriendsListLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
}

extension FriendsViewController: UITableViewDelegate {
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.allowsSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.register(UINib.init(nibName: Constants.userTableViewCell, bundle: nil),forCellReuseIdentifier: Constants.userTableViewCell)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UserData,
            segue.identifier == Constants.profileTableViewController,
            let navigationController = segue.destination as? UINavigationController,
            let vc = navigationController.viewControllers.first as? ProfileTableViewController{
            vc.viewModel = ProfileViewModel(friend: sender)
        }
    }
}
