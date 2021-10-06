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
    private let messageLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 16)
        lb.numberOfLines = 0
        return lb
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
        containerView.addSubview(messageLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 3 / 4 * contentView.frame.width),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    func configureCell(with model: MessageCellConfiguration) {
        messageLabel.text = model.text
        if model.isMyMessage {
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
            containerView.backgroundColor = UIColor(named: "myMessageColor")
        } else {
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
            containerView.backgroundColor = UIColor(named: "userMessageColor")
        }
    }
    
    override func prepareForReuse() {
        messageLabel.text = nil
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = false
    }
}
