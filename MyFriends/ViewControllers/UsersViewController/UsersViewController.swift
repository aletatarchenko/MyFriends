//
//  ViewController.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    let viewModel = UsersViewModel()
    
    struct Constants {
        static var userTableViewCell = "UserTableViewCell"
        static var countForGetUsers  = 50
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        tableView.rx.modelSelected(UserData.self)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.saveUser(user: $0)
                self.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: Constants.userTableViewCell)) { (index: Int, model: UserData, cell: UserTableViewCell) in
            cell.avatarImageView.kf.setImage(with: model.urlForImage)
            cell.nameLabel.text = model.fullName
        }
        .disposed(by: rx.disposeBag)
        
        tableView.rx.willDisplayCell
            .filter { [unowned self] in
                $0.indexPath.row > (self.viewModel.countUsers) - 25 }
            .filter{ [unowned self] _ in
                !self.viewModel.isDownload }
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.getUsers(count: Constants.countForGetUsers)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.networkConnectionError
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showNoInternetConnectionAlert() })
            .disposed(by: rx.disposeBag)
    }
}

extension UsersViewController {
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: Constants.userTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constants.userTableViewCell)
    }
    
    func showNoInternetConnectionAlert() {
        let alert = UIAlertController(title: "", message: "No internet connection", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}


