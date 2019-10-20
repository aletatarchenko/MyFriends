//
//  ProfileTableViewController.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 19.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var doneDidTappedBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelDidTappedBarButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.masksToBounds = false
            avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
            avatarImage.clipsToBounds = true
        }
    }
    
    var viewModel: ProfileViewModel?
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        avatarImage.image = UIImage(data: (viewModel?.friendData.image)!)
        
        avatarImage.rx.anyGesture(.tap())
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                let vc = UIImagePickerController()
                vc.delegate = self
                self.show(vc, sender: nil)
            })
            .disposed(by: rx.disposeBag)
        
        textFields = [
            firstNameTextField,
            lastNameTextField,
            mailTextField,
            phoneNumberTextField
        ]
                
        textFields.forEach { (textField) in
            textField.delegate = self
            
            if let item = self.item(for: textField) {
                textField.text = self.viewModel?.getData(for: item)
            }
            
            textField.rx.controlEvent(.editingChanged)
                .asObservable()
                .subscribe(onNext: { [unowned self] in
                    if let item = self.item(for: textField) {
                        self.doneDidTappedBarButton.isEnabled = true
                        self.viewModel?.updateData(with: item, value: textField.text ?? "")
                    }
                })
                .disposed(by: rx.disposeBag)
        }
        
        cancelDidTappedBarButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        doneDidTappedBarButton.rx.tap
            .subscribe(onNext: {  [unowned self] _ in
                self.viewModel?.updateFriend()
                self.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
    }
    
}

extension ProfileTableViewController: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneNumberTextField  {
            return textField.validationPhone(string: string)
        }
        
        if textField == firstNameTextField || textField == lastNameTextField {
            return textField.validationName(string: string)
        }        
        return true
    }
    
    func item(for textField: UITextField) -> FriendTextItemType? {
           
           return textField.itemType
       }
}


fileprivate extension UITextField {
    
    var itemType: FriendTextItemType? {
        
        return FriendTextItemType(rawValue: tag)
    }
    
    func validationPhone(string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func validationName(string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let data = image?.pngData() else { return }
        viewModel?.updateAvatar(data: data)
        avatarImage.image = image
        doneDidTappedBarButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}
