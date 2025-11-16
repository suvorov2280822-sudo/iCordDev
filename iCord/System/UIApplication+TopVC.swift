//
//  UIApplication+TopVC.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let root = window.rootViewController else {
            return nil
        }
        return getTopVC(root)
    }

    private func getTopVC(_ vc: UIViewController) -> UIViewController {
        if let nav = vc as? UINavigationController, let visible = nav.visibleViewController {
            return getTopVC(visible)
        }
        if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
            return getTopVC(selected)
        }
        if let presented = vc.presentedViewController {
            return getTopVC(presented)
        }
        return vc
    }
}
