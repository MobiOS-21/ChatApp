//
//  MessageInputView.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 28.10.2021.
//

import UIKit

class MessageInputView: UIView, UITextFieldDelegate {
    var sendButtonCallback: ((String) -> Void)?
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_send"), for: .normal)
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
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "messageInputBGColor")
        addSubview(sendButton)
        addSubview(textField)
        
        sendButton.addTarget(self, action: #selector(tapToSendBtn), for: .touchUpInside)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 32),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
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
}
