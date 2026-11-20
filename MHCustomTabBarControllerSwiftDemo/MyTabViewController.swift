//
//  MyTabViewController.swift
//  MHCustomTabBarControllerSwiftDemo
//
//  Created by Alexander Kormanovsky on 13.03.2025.
//  Copyright © 2025 Martin Hartl. All rights reserved.
//

import UIKit
import MHCustomTabBarControllerSwift

final class MyTabViewController: MHCustomTabBarController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("%@ | segue identifier: %@", #function, segue.identifier ?? "nil")

        if segue.identifier == "someNonTabViewController" {
            nonTabViewControllers = [segue.destination]
        }

        super.prepare(for: segue, sender: sender)
    }
}
