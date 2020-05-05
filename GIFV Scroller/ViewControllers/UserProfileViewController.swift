//
//  UserProfileViewController.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Types
    enum UserProfileState {
        case loggedIn
        case logInNeeded
    }
    
    // MARK: - Private Properties
    private lazy var userpicView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private lazy var username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        return button
    }()
    
    private var state: UserProfileState = .logInNeeded {
        didSet {
            setButtonState()
        }
    }

    private var userProfile: UserProfile? {
        didSet {
            if userProfile == nil {
                state = .logInNeeded
                userpicView.image = nil
                username.text = "Please log in"
            } else {
                state = .loggedIn
                if let userProfile = userProfile {
                    if let avatarURL = URL(string: userProfile.avatarURL),
                        let imageData = try? Data(contentsOf: avatarURL) {
                        userpicView.image = UIImage(data: imageData)
                    }
                    username.text = userProfile.name
                }
                
            }
            //view.setNeedsDisplay()
        }
    }
    
    private var client = TJournalClient()
    
    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        setUserpic()
        setLabel()
        setButton()
    }

    // MARK: - Private Methods
    private func setLabel() {
        
        view.addSubview(username)
        
        username.text = "Please log in"
        
        let constraints = [
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            username.topAnchor.constraint(equalTo: userpicView.bottomAnchor, constant: 20),
            username.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUserpic() {
        
        view.addSubview(userpicView)
        
        let constraints = [
            userpicView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userpicView.widthAnchor.constraint(equalToConstant: 100),
            userpicView.heightAnchor.constraint(equalToConstant: 100),
            userpicView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setButton() {
        view.addSubview(button)
        setButtonState()
        let constraints = [
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setButtonState() {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        switch state {
        case .loggedIn:
            button.setTitle("Quit", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.layer.borderColor = UIColor.red.cgColor
        case .logInNeeded:
            button.setTitle("Log in", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @objc func buttonTapped(_: UIButton) {
        switch state {
        case .loggedIn:
            userProfile = nil
        case .logInNeeded:
            let qrCodeScannerVC = QRCodeScannerViewController()
            qrCodeScannerVC.delegate = self
            present(qrCodeScannerVC, animated: true, completion: nil)
        }
    }
}

extension UserProfileViewController: QRCodeScannerViewControllerDelegate {
    func didFinishScanning(with result: String) {
        let token = String(result.dropFirst(3))
        let request = UserProfileRequest.getRequest()
        client.logIn(with: request, token: token, completion: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print("something went wrong \(error)")
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.userProfile = response.result
                }
            }
        })
    }
}
