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
import NSObject_Rx
import RxDataSources

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    var dataSource: RxTableViewSectionedReloadDataSource<UserSection>!
    let viewModel = UsersViewModel()
    
    struct Constants {
        static var userTableViewCell = "UserTableViewCell"
        static var activitiIndicatorTableViewCell = "ActivitiIndicatorTableViewCell"
        static var countForGetUsers  = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureTableViewCell()
        
        tableView.rx.modelSelected(UsersItem.self)
            .subscribe(onNext: { [unowned self] in
                switch $0 {
                case let .userData(value):
                    self.viewModel.saveUser(user: value)
                    self.dismiss(animated: true)
                case .activity:
                    break
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.driveUsers
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        
        tableView.rx.willDisplayCell
            .filter { [unowned self] in $0.indexPath.row == self.tableView.numberOfRows(inSection: 0) - 1 }
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
    
    func configureTableViewCell() {
        
        dataSource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            
            switch item {
            case let .userData(value):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userTableViewCell, for: indexPath) as! UserTableViewCell
                cell.avatarImageView.kf.setImage(with: value.urlForImage!)
                cell.nameLabel.text = value.fullName
                return cell
            case .activity:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.activitiIndicatorTableViewCell, for: indexPath) as! ActivitiIndicatorTableViewCell
                cell.activitiIndicator.startAnimating()
                return cell
            }
        })
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: Constants.userTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constants.userTableViewCell)
        tableView.register(UINib.init(nibName: Constants.activitiIndicatorTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constants.activitiIndicatorTableViewCell)
    }
    
    func showNoInternetConnectionAlert() {
        let alert = UIAlertController(title: "", message: "No internet connection", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        switch dataSource[indexPath] {
        case .userData:
            return true
        case .activity:
            return false
        }
    }
}


