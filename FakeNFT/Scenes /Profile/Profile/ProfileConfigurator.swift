//
//  ProfileConfigurator.swift
//  FakeNFT
//
//  Created by Galina evdokimova on 27.06.2025.
//

import UIKit

final class ProfileConfigurator {
    
    func configure() -> ProfileViewController {
        
        let profileProvider = ProfileProvider(networkClient: DefaultNetworkClient())
        let profileVC = ProfileViewController()
        let profilePresenter = ProfilePresenter()

        profileVC.presenter = profilePresenter
        profilePresenter.view = profileVC
        profilePresenter.provider = profileProvider
        
        return profileVC
    }
}
