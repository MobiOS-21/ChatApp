//
//  MessageInputView.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 28.10.2021.
//

import UIKit

class MessageInputView: UIView, UITextFieldDelegate {
    var sendButtonCallback: ((String) -> Void)?
    var imageBtnCallback: (() -> Void)?
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_send"), for: .normal)
        return btn
    }()
    
    private let addImageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "addImage"), for: .normal)
        return btn
    }()
    
    // TODO: - replace on textView with autoheight
    private let textField: UITextField = {
        let tf = PaddingTextField(insets: .init(top: 0, left: 8, bottom: 0, right: 8))
        tf.placeholder = "Your message hear..."
        tf.font = .systemFont(ofSize: 17)
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.cornerRadius = 16
        return tf
    }()
    
    init(parentVC: ConversationViewController) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "messageInputBGColor")
        addSubview(sendButton)
        addSubview(textField)
        addSubview(addImageBtn)
        
        parentVC.delegate = self
        
        sendButton.addTarget(self, action: #selector(tapToSendBtn), for: .touchUpInside)
        addImageBtn.addTarget(self, action: #selector(tapAddImageBtn), for: .touchUpInside)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addImageBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            addImageBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            addImageBtn.heightAnchor.constraint(equalToConstant: 30),
            addImageBtn.widthAnchor.constraint(equalToConstant: 30),
            addImageBtn.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 32),
            textField.leadingAnchor.constraint(equalTo: addImageBtn.trailingAnchor, constant: 16),
            
            sendButton.heightAnchor.constraint(equalToConstant: 20),
            sendButton.widthAnchor.constraint(equalToConstant: 20),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func tapToSendBtn() {
        guard let message = textField.text, !message.isEmpty else { return }
        sendButtonCallback?(message)
        textField.text = nil
    }
    
    @objc private func tapAddImageBtn() {
        imageBtnCallback?()
    }
}

extension MessageInputView: ConversationProtocol {
    func sendImage(url: URL) {
        textField.text = url.absoluteString
    }
}
