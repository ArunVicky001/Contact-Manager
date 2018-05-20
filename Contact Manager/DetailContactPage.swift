//
//  DetailContactPage.swift
//  Contact Manager
//
//  Created by Vignesh on 08/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit
import CoreData

class DetailContactPage: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
   
    var selectedUser: [NSManagedObject] = []    
    var selectedContact = [Address]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedUser)
        if Connectivity.isConnectedToInternet() {
            self.nameLbl.text = selectedContact[0].Name
            self.emailLbl.text = selectedContact[0].Email
            self.phoneLbl.text = selectedContact[0].Phone
        }
        else{
            self.nameLbl.text = selectedUser[0].value(forKeyPath: "name") as? String
            self.phoneLbl.text = selectedUser[0].value(forKeyPath: "phone") as? String
            self.emailLbl.text = selectedUser[0].value(forKeyPath: "email") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
