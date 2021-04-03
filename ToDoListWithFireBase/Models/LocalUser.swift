//
//  User.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import Foundation
import Firebase

struct LocalUser {
    let id: String
    let email : String
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email!
    }
    
    init(data: [String : Any]) {
        id = data["id"] as! String
        email = data["email"] as! String
    }
}
