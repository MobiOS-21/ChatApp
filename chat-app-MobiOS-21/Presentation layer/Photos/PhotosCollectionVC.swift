//
//  PhotosCollectionVC.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import UIKit

final class PhotosCollectionVC: UIViewController {
    // MARK: - Properties
    var selectImageCallback: ((URL) -> Void)?
    private var dataSource: [URL] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private let photosViewModel: PhotosViewModelProtocol
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(PhotosCollectionCell.self, forCellWithReuseIdentifier: PhotosCollectionCell.reuseIdentifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    init(photosViewModel: PhotosViewModelProtocol) {
        self.photosViewModel = photosViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()
        fetchDataSource()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    private func configureNavBar() {
        title = "Download"
        
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeVC))
        navigationItem.rightBarButtonItems = [item]
    }
    
    private func fetchDataSource() {
        if #available(iOS 15.0, *) {
            Task {
                try await concurencyFetchDataSource()
            }
        } else {
            photosViewModel.fetchImages {[weak self] urls in
                self?.dataSource = urls
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    private func concurencyFetchDataSource() async throws {
        Task {
            do {
                self.dataSource = try await photosViewModel.fetchConcurencyImages()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionCell.reuseIdentifier, for: indexPath) as? PhotosCollectionCell else { fatalError()}
        cell.configureCell(with: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError() }
        let sectionInset = flowLayout.sectionInset
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
        - sectionInset.left
        - sectionInset.right
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        - (flowLayout.minimumLineSpacing * 2)
        let width = referenceWidth / 3
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImageCallback?(dataSource[indexPath.row])
        closeVC()
    }
}
