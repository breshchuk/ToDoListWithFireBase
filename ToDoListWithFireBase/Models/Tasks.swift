//
//  Tasks.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import Foundation
import Firebase

struct Tasks {
    let userID : String
    let title: String
    var ref : DatabaseReference?
    var completed = false
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: AnyObject]
        userID = value["userid"] as! String
        title = value["title"] as! String
        completed = value["completed"] as! Bool
        ref = snapshot.ref
    }
    
    init(userID: String, title: String) {
        self.userID = userID
        self.title = title
        self.ref = nil
    }
    
    func convertToDict() -> Any {
        return ["title": title,"userid": userID,"completed": completed ]
    }
}
