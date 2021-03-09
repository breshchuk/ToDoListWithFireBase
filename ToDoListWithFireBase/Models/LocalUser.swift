//
//  User.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import Foundation
import Firebase

struct LocalUser {
    private let id: String
    private let email : String
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email!
    }
}
