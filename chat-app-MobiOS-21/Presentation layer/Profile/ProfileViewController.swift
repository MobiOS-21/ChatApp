//
//  ProfileViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 27.09.2021.
//

import UIKit

enum ProfileScreenState {
    case saving, editStart, disabled, changeProfile
}

final class ProfileViewController: UIViewController, ImagePickerDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var editAvatarButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userDescriptionTV: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveBtnContainer: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    
    private lazy var imagePicker: ImagePickerHelper = ImagePickerHelper(presentationController: self, delegate: self)
    private var currentState: ProfileScreenState = .disabled
    private var currentProfile: ProfileModel? {
        didSet {
            DispatchQueue.main.async {
                self.setupProfileInfo()
            }
        }
    }
    private lazy var currentFileManager: ProfileDataServiceProtocol? = gcdService
    private var gcdService: ProfileDataServiceProtocol?
    private var operationService: ProfileDataServiceProtocol?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getProfile()
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        userNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight + 60, right: 0)
            scrollView.setContentOffset(.init(x: 0, y: keyboardHeight), animated: true)
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFieldsChanges()
    }
    
    func setupServices(gcdService: ProfileDataServiceProtocol?, operationService: ProfileDataServiceProtocol?) {
        self.gcdService = gcdService
        self.operationService = operationService
    }
    
    // MARK: - Private
    private func getProfile() {
        currentFileManager?.readData { [weak self] status in
            guard let self = self, status == .success else {
                self?.currentProfile = nil
                return
            }
            self.currentProfile = self.currentFileManager?.currentProfile
        }
    }
    
    private func checkFieldsChanges() {
        if currentState != .changeProfile {
            currentState = .changeProfile
            updateUI()
        }
    }
    
    final private func setupDefaultImage() {
        guard let userName = userNameTF.text else { return }
        let userInitials = Array(userName.components(separatedBy: " ").compactMap({ $0.first }).prefix(2))
        let initialsFontSize = userInitials.count == 2 ? userAvatar.frame.width / 3 : userAvatar.frame.width / 4
        userAvatar.image = String(userInitials).image(withAttributes: [.font: UIFont.systemFont(ofSize: initialsFontSize, weight: .bold)])
    }
    
    private func setupProfileInfo() {
        userNameTF.text = currentProfile?.userName
        userDescriptionTV.text = currentProfile?.userDecription
        if let imageData = currentProfile?.userAvater {
            userAvatar.image = UIImage(data: imageData)
        } else {
            setupDefaultImage()
        }
    }
    
    final private func configureUI() {
        editButton.layer.cornerRadius = 14
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        
        userDescriptionTV.layer.borderWidth = 1.0
        userDescriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        userDescriptionTV.layer.cornerRadius = 8
        userDescriptionTV.clipsToBounds = true
    }
    
    private func updateUI() {
        switch currentState {
        case .saving:
            activityIndicator.startAnimating()
            saveBtnContainer.isHidden = false
            editButton.setTitle("Cancel", for: .normal)
            editButton.isEnabled = true
            editAvatarButton.isEnabled = false
            userDescriptionTV.isUserInteractionEnabled = false
            saveBtnContainer.isUserInteractionEnabled = false
            userNameTF.isUserInteractionEnabled = false
        case .editStart:
            activityIndicator.stopAnimating()
            saveBtnContainer.isHidden = false
            editButton.setTitle("Cancel", for: .normal)
            editButton.isEnabled = true
            editAvatarButton.isEnabled = true
            userDescriptionTV.isUserInteractionEnabled = true
            saveBtnContainer.isUserInteractionEnabled = false
            userNameTF.isUserInteractionEnabled = true
        case .disabled:
            activityIndicator.stopAnimating()
            saveBtnContainer.isHidden = true
            editButton.setTitle("Edit", for: .normal)
            editButton.isEnabled = true
            editAvatarButton.isEnabled = true
            userDescriptionTV.isUserInteractionEnabled = false
            saveBtnContainer.isUserInteractionEnabled = false
            userNameTF.isUserInteractionEnabled = false
        case .changeProfile:
            activityIndicator.stopAnimating()
            saveBtnContainer.isHidden = false
            editButton.setTitle("Cancel", for: .normal)
            editButton.isEnabled = true
            editAvatarButton.isEnabled = true
            userDescriptionTV.isUserInteractionEnabled = true
            saveBtnContainer.isUserInteractionEnabled = true
            userNameTF.isUserInteractionEnabled = true
        }
    }
    
    private func configureNewProfile() -> ProfileModel {
        return ProfileModel(userName: userNameTF.text,
                            userDecription: userDescriptionTV.text,
                            userAvater: userAvatar.image?.pngData())
    }
    
    private func showOKAlert() {
        let action: (UIAlertAction) -> Void = { _ in }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.openAlert(title: "Data saved", actionTitles: ["OK"], actionStyles: [.default], actions: [action])
        }
    }
    
    private func showErrorAlert(saveAction: @escaping () -> Void) {
        let okaction: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self else { return }
            self.currentState = .editStart
            self.updateUI()
        }
        let retryAction: (UIAlertAction) -> Void = { _ in
            saveAction()
        }
        
        self.openAlert(title: "Error", message: "failed to save data",
                       actionTitles: ["OK", "Retry"], actionStyles: [.default, .default],
                       actions: [okaction, retryAction])
    }
    
    private func saveProfileInfo() {
        currentFileManager?.saveData(profile: configureNewProfile()) {[weak self] status in
            guard let self = self else { return }
            switch status {
            case .success:
                DispatchQueue.main.async {
                    self.showOKAlert()
                    self.currentState = .disabled
                    self.updateUI()
                }
            case .error:
                DispatchQueue.main.async {
                    self.showErrorAlert(saveAction: self.saveProfileInfo)
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func tappedEditAvaterButton(_ sender: Any) {
        imagePicker.present(from: userAvatar)
    }
    
    @IBAction func tappedCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveGCDBtn(_ sender: Any) {
        currentState = .saving
        currentFileManager = gcdService
        updateUI()
        saveProfileInfo()
    }
    
    @IBAction func tappedSaveOperationBtn(_ sender: Any) {
        currentState = .saving
        currentFileManager = operationService
        updateUI()
        saveProfileInfo()
    }
    
    @IBAction func tappedEditBtn(_ sender: Any) {
        currentState = currentState == .disabled ? .editStart : .disabled
        
        updateUI()
        
        if currentState == .editStart {
            userNameTF.becomeFirstResponder()
        } else {
            setupProfileInfo()
        }
    }
    
    // MARK: - ImagePickerDelegate
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        currentState = .changeProfile
        updateUI()
        userAvatar.image = image
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkFieldsChanges()
    }
}
