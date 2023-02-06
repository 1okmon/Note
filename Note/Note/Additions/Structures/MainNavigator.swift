//
//  MainNavigator.swift
//  School
//
//  Created by 1okmon on 01.05.2022.
//

import UIKit
struct MainNavigator {
    static func getVCFromMain(withIdentifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let targetVC = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return targetVC
    }
}
