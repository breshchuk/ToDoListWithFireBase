//
//  TabBarViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.04.21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [UINavigationController(rootViewController:  TasksViewController()),UserViewController()]
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
