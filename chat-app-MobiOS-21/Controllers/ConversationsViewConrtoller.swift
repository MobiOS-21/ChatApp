//
//  ConversationsViewConrtoller.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.10.2021.
//

import UIKit
import FirebaseFirestore

class ConversationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var channels: [Channel] = []
    private lazy var reference = db.collection("channels")
    
    private lazy var db = Firestore.firestore()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchChanellsData()
    }
    
    // MARK: - Private
    private func configureUI() {
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchChanellsData() {
        reference.addSnapshotListener {[weak self] querySnapshot, error in
            guard let self = self,
                  let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            snapshot.documents.forEach { document in
                var name: String = ""
                var lastActivity: Date?
                if let documentName = document["name"] as? String {
                    name = documentName
                }
                if let documentDate = document["lastActivity"] as? Timestamp {
                    lastActivity = Date(timeIntervalSince1970: TimeInterval(documentDate.seconds))
                }
                self.channels.append(Channel(identifier: document.documentID,
                                             name: name,
                                             lastMessage: document["lastMessage"] as? String,
                                             lastActivity: lastActivity))
            }
            self.updateTableView()
//            snapshot.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                    print("New city: \(diff.document.data())")
//                }
//                if (diff.type == .modified) {
//                    print("Modified city: \(diff.document.data())")
//                }
//                if (diff.type == .removed) {
//                    print("Removed city: \(diff.document.data())")
//                }
//            }
        }
    }
    
    private func updateTableView() {
        channels.sort(by: { $0.lastActivity ?? Date(timeIntervalSince1970: 0) > $1.lastActivity ?? Date(timeIntervalSince1970: 0) })
        tableView.reloadData()
    }
    
    private func logThemeChanging(selectedTheme: UIColor) {
        debugPrint("Theme is \(String(describing: selectedTheme))")
        save(selectedTheme: selectedTheme)
    }
    
    private func save(selectedTheme: UIColor) {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.setColor(color: selectedTheme, forKey: UserDefaults.UDKeys.selectedTheme.rawValue)
        }
    }
    
    private func showAlertForThemesVC() {
        let showThemesSwiftVC: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVCSwift")
            (vc as? ThemesViewControllerSwift)?.didSelectThemeClosure = self.logThemeChanging(selectedTheme:)
            self.present(vc, animated: true)
        }
        
        let showThemesObjcVC: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVC")
            (vc as? ThemesViewController)?.delegate = self
            self.present(vc, animated: true)
        }
        self.openAlert(message: "Select themes view controller type",
                       actionTitles: ["ThemesVC Swift", "Themes VC Objective-c"],
                       actionStyles: [.default, .default],
                       actions: [showThemesSwiftVC, showThemesObjcVC])
    }
    // MARK: - IBActions
    @IBAction func tapProfileBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(vc, animated: true)
    }
    
    @IBAction func tapThemesBtn(_ sender: Any) {
        showAlertForThemesVC()
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableCell.reuseIdentifire, for: indexPath) as? ConversationsTableCell else { fatalError() }
        
        cell.configureCell(with: channels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatName = channels[indexPath.row].name
        let vc = ConversationViewController()
        vc.title = chatName
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}
