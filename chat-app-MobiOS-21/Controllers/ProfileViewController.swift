//
//  ProfileViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 27.09.2021.
//

import UIKit

class ProfileViewController: UIViewController, ImagePickerDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var editAvatarButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userDescriptionTV: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveBtnContainer: UIStackView!
    
    private lazy var imagePicker: ImagePickerHelper = ImagePickerHelper(presentationController: self, delegate: self)
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultImage()
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.view.frame.origin.y = -1.0 * keyboardHeight
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    final private func setupDefaultImage() {
        guard let userName = userNameTF.text else { return }
        let userInitials = Array(userName.components(separatedBy: " ").compactMap({ $0.first }).prefix(2))
        let initialsFontSize = userAvatar.frame.width / 3
        userAvatar.image = String(userInitials).image(withAttributes: [.font: UIFont.systemFont(ofSize: initialsFontSize, weight: .bold)])
    }
    
    final private func configureUI() {
        editButton.layer.cornerRadius = 14
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        
        userDescriptionTV.layer.borderWidth = 1.0
        userDescriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        userDescriptionTV.layer.cornerRadius = 8
        userDescriptionTV.clipsToBounds = true
    }
    
    @IBAction func tappedEditButton(_ sender: Any) {
        imagePicker.present(from: userAvatar)
    }
    
    @IBAction func tappedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveGCDBtn(_ sender: Any) {
    }
 
    @IBAction func tappedSaveOperationBtn(_ sender: Any) {
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        userAvatar.image = image
        userAvatar.contentMode = .scaleAspectFill
    }
}
