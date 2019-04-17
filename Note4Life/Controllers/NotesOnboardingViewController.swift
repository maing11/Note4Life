//
//  NotesOnboardingViewController.swift
//  Things+
//
//  Created by Larry Nguyen on 4/2/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import paper_onboarding


class NotesOnboardingViewController: UIViewController {
    
    @IBOutlet var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: NoteTheme.onboardingInfoImages[0],
                           title: NoteTheme.titleArray[0],
                           description: NoteTheme.descArray[0],
                           pageIcon: NoteTheme.onboardingPageIcons[0],
                           color: NoteTheme.onboardingColors[0],
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: NoteTheme.onboardingInfoImages[1],
                           title: NoteTheme.titleArray[1],
                           description: NoteTheme.descArray[1],
                           pageIcon: NoteTheme.onboardingPageIcons[1],
                           color: NoteTheme.onboardingColors[1],
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: NoteTheme.onboardingInfoImages[2],
                           title: NoteTheme.titleArray[2],
                           description: NoteTheme.descArray[2],
                           pageIcon: NoteTheme.onboardingPageIcons[2],
                           color: NoteTheme.onboardingColors[2],
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubviewToFront(skipButton)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension NotesOnboardingViewController {
    
    @IBAction func skipButtonTapped(_: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Defaults.saveFirstTimeOpenBool(false)
        let nav = UINavigationController(rootViewController: CategoryViewController(realmDataPersistence: appDelegate.realmDataPersistence))
        self.present(nav, animated: true) {
            
        }
    }
}

// MARK: PaperOnboardingDelegate

extension NotesOnboardingViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension NotesOnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 4
    }

    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 10
    }
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor.white, UIColor.red, UIColor.green][index]
    }
}


//MARK: Constants
extension NotesOnboardingViewController {
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 34.0)
    private static let descriptionFont = UIFont.systemFont(ofSize: 20.0)
}


