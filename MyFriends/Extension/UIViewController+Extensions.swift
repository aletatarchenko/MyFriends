//
//  UIViewController+Extensions.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 20.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showNoInternetConnectionAlert() {
           let alert = UIAlertController(title: "", message: "No internet connection", preferredStyle: .alert)
           alert.addAction(.init(title: "Ok", style: .default))
           self.present(alert, animated: true)
       }
}
