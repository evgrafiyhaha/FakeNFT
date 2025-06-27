//
//  ProfileEditPresenter.swift
//  FakeNFT
//
//  Created by Galina evdokimova on 27.06.2025.
//

import UIKit

protocol ProfileEditPresenterProtocol: AnyObject {
    var view: ProfileEditViewControllerProtocol? { get set }

    func closeButtonTapped()
    func alertSaveOkTapped(_ profile: Profile?)
    func profileNameTextFieldChanged(_ nameText: String)
    func profileDescriptionTextFieldChanged(_ descriptionText: String)
    func profileWebsiteTextFieldChanged(_ websiteText: String)

    func updateProfileOnServer(_ profile: Profile?)
    
    func getProfile() -> Profile?
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {

    var profile: Profile?
    
    weak var view: ProfileEditViewControllerProtocol?
    var provider: ProfileProviderProtocol?
}

//MARK: - ProfileEditPresenterProtocol
extension ProfileEditPresenter {
    
    func getProfile() -> Profile? {
        return profile
    }

    func closeButtonTapped() {
        guard let profile else { return }
        view?.showSaveAlert(profile)
    }
    
    func profileNameTextFieldChanged(_ nameText: String) {
        profile = profile?.updateName(nameText)
    }
    
    func profileDescriptionTextFieldChanged(_ descriptionText: String) {
        profile = profile?.updateDescription(descriptionText)
    }
    
    func profileWebsiteTextFieldChanged(_ websiteText: String) {
        profile = profile?.updateWebsite(websiteText)
    }
    
    func alertSaveOkTapped(_ profile: Profile?) {
        updateProfileOnServer(profile)
    }
    
    func updateProfileOnServer(_ profile: Profile?) {
        
        provider?.updateProfile(profile) { [weak self] profile in
            
            guard let self else { return }
            guard let profile else { return }

            NotificationCenter.default.post(
                name: Notification.Name("ProfileUpdatedNotification"),
                object: nil,
                userInfo: ["profile": profile])
            
            self.view?.closeProfileEditScreen()
        }
    }
}

