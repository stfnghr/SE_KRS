//
//  UserModel.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 29/05/25.
//

import Foundation

struct UserModel: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var phone: String
    var email: String
    var password: String
    var balance: Double = 0.0
}
