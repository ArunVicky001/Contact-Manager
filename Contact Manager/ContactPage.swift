//
//  ContactPage.swift
//  Contact Manager
//
//  Created by Vignesh on 03/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit
import Alamofire

let kReUseIdentifier = "UserCell"
class ContactPage: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    var contactArray = [Address]()
    var searchArray = [Address]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate=self
        tableView.dataSource=self
        setUpSearchBar()

        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            fetchUserDatas()
        }
        else{
            print("NO internet connection")
        }
    }

    
    // MARK: - Fetch User Datas
    
    func fetchUserDatas(){
        ApiManager.shareInstant.fetchUserDetails(urlString: FETCH_USER_DETAIL_URL, userCount: ["offset": 10]) { ConnectionResult in
            
            switch ConnectionResult {
            case .success(let data):
                do{
                    self.contactArray = try JSONDecoder().decode([Address].self, from: data)
                    self.searchArray = self.contactArray
                    DispatchQueue.main.async {
                        print("Got response")
                        self.tableView.reloadData()
                    }
                }
                catch let errorValue {
                    print(errorValue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return self.searchArray.count
        }
        return self.contactArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCell = tableView.dequeueReusableCell(withIdentifier: kReUseIdentifier, for: indexPath) as! UserCell
        if isSearching {
            if self.searchArray.count>0 {
                let myUser = self.searchArray[indexPath.row]
                cell.nameLbl.text = myUser.Name
                cell.emailLbl.text = myUser.Email
                cell.phoneLbl.text = myUser.Phone
            }
        }
        else{
            if self.contactArray.count>0 {
                let myUser = self.contactArray[indexPath.row]
                cell.nameLbl.text = myUser.Name
                cell.emailLbl.text = myUser.Email
                cell.phoneLbl.text = myUser.Phone
            }
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailContact = self.storyboard?.instantiateViewController(withIdentifier: "DetailContactPage") as! DetailContactPage
        if isSearching {
            detailContact.selectedContact = [self.searchArray[indexPath.row]]
        }
        else{
            detailContact.selectedContact = [self.contactArray[indexPath.row]]
        }
        self.navigationController?.pushViewController(detailContact, animated: true)
    }
    
    // MARK: - Navigation
   /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserContact"{
            let vc = segue.destination as? DetailContactPage
            vc?.selectedContact = self.myUser
        }
    }
    */
    
    // MARK: - SearchBar
    
    private func setUpSearchBar() {
        searchBar.delegate = self
//        searchBar.showsCancelButton = true
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "Search Contact"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searching")
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else{
            isSearching = true
            self.searchArray = self.contactArray.filter({ Address -> Bool in
                switch searchBar.selectedScopeButtonIndex {
                case 0:
                    if searchText.isEmpty { return true }
                    return Address.Name.lowercased().contains(searchText.lowercased())
                default:
                    return false
                }
            })
            tableView.reloadData()
        }
    }
}


