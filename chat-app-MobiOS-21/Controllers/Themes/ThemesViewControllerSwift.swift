//
//  ThemesViewControllerSwift.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 13.10.2021.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    var didSelectThemeClosure: ((_ selectedTheme: UIColor) -> Void)?
    private let themesModel = ThemesSwift(theme1: .systemGray, theme2: .white, theme3: .systemPink)
    
    // MARK: - Private
    private func updateVavBar() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
    
    private func updateTheme(with color: UIColor) {
        view.backgroundColor = color
        didSelectThemeClosure?(color)
        UINavigationBar.appearance().backgroundColor = color
        updateVavBar()
    }
    // MARK: - IBActions
    @IBAction private func tapToCloseBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func setTheme1() {
        updateTheme(with: themesModel.theme1)
    }
    
    @IBAction private func setTheme2() {
        updateTheme(with: themesModel.theme2)
    }
    
    @IBAction private func setTheme3() {
        updateTheme(with: themesModel.theme3)
    }
}
