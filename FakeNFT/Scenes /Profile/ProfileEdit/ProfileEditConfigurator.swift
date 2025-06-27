//
//  ProfileEditConfigurator.swift
//  FakeNFT
//
//  Created by Galina evdokimova on 27.06.2025.
//

import UIKit

final class ProfileEditConfigurator {
    
    func configure(_ profile: Profile?) -> ProfileEditViewController {
        
        let profileEditProvider = ProfileProvider(networkClient: DefaultNetworkClient())
        let profileEditVC = ProfileEditViewController()
        let profileEditPresenter = ProfileEditPresenter()

        profileEditVC.presenter = profileEditPresenter
        profileEditPresenter.view = profileEditVC
        profileEditPresenter.provider = profileEditProvider

        profileEditPresenter.profile = profile
        
        return profileEditVC
    }
}
