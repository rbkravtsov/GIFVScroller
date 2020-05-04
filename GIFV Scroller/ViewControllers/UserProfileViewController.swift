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
    // MARK: - Constants

    // MARK: - IBOutlets

    // MARK: - Public Properties

    // MARK: - Private Properties
    private lazy var userpicView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()

    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        
    }
    // MARK: - Public methods

    // MARK: - IBActions

    // MARK: - Private Methods
    private func setLabel() {
        view.addSubview(userpicView)
        
        let constraints = [
            userpicView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userpicView.widthAnchor.constraint(equalToConstant: 100),
            userpicView.heightAnchor.constraint(equalToConstant: 100),
            userpicView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUserpic() {
        
    }
    
    private func setButton() {
        
    }
}
