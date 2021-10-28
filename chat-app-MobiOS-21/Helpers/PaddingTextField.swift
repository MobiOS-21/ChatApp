//
//  PaddingTextField.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 28.10.2021.
//

import UIKit

class PaddingTextField: UITextField {
    private let textInsets: UIEdgeInsets
    init(insets: UIEdgeInsets) {
        textInsets = insets
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textInsets)
    }
}
