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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private lazy var imagePicker: ImagePickerHelper = ImagePickerHelper(presentationController: self, delegate: self)
    //MARK: - Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("В данном методе невозможно распечатать фрейм кнопки, так как кнопка еще не инициализированна")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(editAvatarButton.frame)
        setupDefaultImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(editAvatarButton.frame)
        print("""
Фрейм кнопки в методах viewDidLoad и viewDidAppear отличается, так как на этом этапе уже отработал метод viewDidLayoutSubviews
Autolayout считается не сразу, а данный метод сигнализирует о том, что произошел расчет фреймов у вьюшек вьюконтроллера на основании констрейнтов
"""
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    final private func setupDefaultImage() {
        guard let userName = userNameLabel.text else { return }
        let userInitials = Array(userName.components(separatedBy: " ").compactMap({ $0.first }).prefix(2))
        let initialsFontSize = userAvatar.frame.width / 2
        userAvatar.image = String(userInitials).image(withAttributes: [.font: UIFont.systemFont(ofSize: initialsFontSize, weight: .bold)])
    }
    
    final private func configureUI() {
        saveButton.layer.cornerRadius = 14
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
    }
    
    @IBAction func tappedEditButton(_ sender: Any) {
        imagePicker.present(from: userAvatar)
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        userAvatar.image = image
        userAvatar.contentMode = .scaleAspectFill
    }
}
