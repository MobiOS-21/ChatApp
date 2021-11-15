//
//  ConversationTableCell.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit

class ConversationTableCell: UITableViewCell {
    static let reuseIdentifier = "ConversationTableCell"
    private let containerView = UIView()
    
    private let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .orange
        lb.font = .boldSystemFont(ofSize: 16)
        lb.numberOfLines = 1
        return lb
    }()
    
    private let messageLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 13)
        lb.numberOfLines = 0
        return lb
    }()
    
    private let messageStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 4
        sv.axis = .vertical
        return sv
    }()
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(containerView)
        contentView.addSubview(messageStackView)
        messageStackView.addArrangedSubview(userNameLabel)
        messageStackView.addArrangedSubview(messageLabel)
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        let constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 3 / 4 * contentView.frame.width),
            
            messageStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            messageStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    func configureCell(with model: DBMessage) {
        messageLabel.text = model.content
        userNameLabel.text = model.senderName
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString, model.senderId == deviceId {
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
            containerView.backgroundColor = UIColor(named: "myMessageColor")
            userNameLabel.isHidden = true
        } else {
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
            containerView.backgroundColor = UIColor(named: "userMessageColor")
            userNameLabel.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        userNameLabel.text = nil
        userNameLabel.isHidden = false
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = false
    }
}
