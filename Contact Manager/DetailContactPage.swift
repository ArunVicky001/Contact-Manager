//
//  DetailContactPage.swift
//  Contact Manager
//
//  Created by Vignesh on 08/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit

class DetailContactPage: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    
    var selectedContact = [Address]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedContact)
        
        self.nameLbl.text = selectedContact[0].Name
        self.emailLbl.text = selectedContact[0].Email
        self.phoneLbl.text = selectedContact[0].Phone
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
