//
//  RecipeDelegate.swift
//  Recipe_Assignment
//
//  Created by Bassuni on 9/19/19.
//  Copyright © 2019 Mahmoud. All rights reserved.
//

import Foundation
import Foundation
protocol RecipeDelegate{
    func showLoading()
    func hideLoading()
    func showAlert(messgae : String)
    func dataBind()
}
