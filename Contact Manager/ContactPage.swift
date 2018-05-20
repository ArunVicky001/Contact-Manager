//
//  ContactPage.swift
//  Contact Manager
//
//  Created by Vignesh on 03/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

let kReUseIdentifier = "UserCell"
class ContactPage: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var appDelegate = AppDelegate()
    var isSearching = false
    var contactArray = [Address]()
    var searchArray = [Address]()
    var people: [NSManagedObject] = []
    var searchpeople : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        setUpSearchBar()
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            fetchUserDatas()
        }
        else{
            print("NO internet connection")
            self.fetchCoredataValues()
        }
    }

    
    // MARK: - Core data
    
    func fetchUserDatas(){
        
        ApiManager.shareInstant.fetchUserDetails(urlString: FETCH_USER_DETAIL_URL, userCount: ["offset": 10]) { ConnectionResult in
            
            switch ConnectionResult {
            case .success(let data):
                do{
                    self.contactArray = try JSONDecoder().decode([Address].self, from: data)
                    self.searchArray = self.contactArray
                    
                    self.deleteAllRecords()
                    self.saveDatas()
                    
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
    
    
    func saveDatas() {
        
        let context  = appDelegate.persistentContainer.viewContext
        for json in self.contactArray{
            
            let entity = NSEntityDescription.entity(forEntityName: "UserContacts", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(json.Name, forKey: "name")
            newUser.setValue(json.Phone, forKey: "phone")
            newUser.setValue(json.Email, forKey: "email")
            newUser.setValue(json.Street, forKey: "street")
            newUser.setValue(json.Company, forKey: "company")
            newUser.setValue(json.City, forKey: "city")
            newUser.setValue(json.ID, forKey: "userid")
            newUser.setValue(json.Age, forKey: "age")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        
    }
    
    func fetchCoredataValues() {
        let context  = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserContacts")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            people = try context.fetch(request) as! [NSManagedObject]
            searchpeople = try context.fetch(request) as! [NSManagedObject]
            print("data count \(searchpeople.count)")
            
            if people.count != 0 {
                for data in people {
                    print(data)
                    print(data.value(forKey: "name") as! String)
                }
                self.tableView.reloadData()
            }
            
        } catch {
            print("Failed")
        }
    }
    
    
    func deleteAllRecords() {
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserContacts")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Connectivity.isConnectedToInternet() {
            if isSearching {
                return self.searchArray.count
            }
            return self.contactArray.count
        }
        else{
            if isSearching {
                return searchpeople.count
            }
            else{
                return people.count}
        }
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCell = tableView.dequeueReusableCell(withIdentifier: kReUseIdentifier, for: indexPath) as! UserCell
        
        if Connectivity.isConnectedToInternet() {
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
        }
        else{
            if isSearching{
                let sperson = searchpeople[indexPath.row]
                print("search person values \(sperson)")
                cell.nameLbl?.text = sperson.value(forKeyPath: "name") as? String
                cell.phoneLbl?.text = sperson.value(forKeyPath: "phone") as? String
                cell.emailLbl?.text = sperson.value(forKeyPath: "email") as? String
            }
            else{
             let person = people[indexPath.row]
            cell.nameLbl?.text = person.value(forKeyPath: "name") as? String
            cell.phoneLbl?.text = person.value(forKeyPath: "phone") as? String
            cell.emailLbl?.text = person.value(forKeyPath: "email") as? String
            }
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailContact = self.storyboard?.instantiateViewController(withIdentifier: "DetailContactPage") as! DetailContactPage
        if Connectivity.isConnectedToInternet() {
            if isSearching {
                detailContact.selectedContact = [self.searchArray[indexPath.row]]
            }
            else{
                detailContact.selectedContact = [self.contactArray[indexPath.row]]
            }
        }
        else{
            if isSearching {
                detailContact.selectedUser = [self.searchpeople[indexPath.row]]
            }
            else{
                detailContact.selectedUser = [self.people[indexPath.row]]
            }
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
            
            if Connectivity.isConnectedToInternet(){
                self.searchArray = self.contactArray.filter({ Address -> Bool in
                    switch searchBar.selectedScopeButtonIndex {
                    case 0:
                        if searchText.isEmpty { return true }
                        return Address.Name.lowercased().contains(searchText.lowercased())
                    default:
                        return false
                    }
                })
            }else{
                    var predicate: NSPredicate = NSPredicate()
                    predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
                    let managedObjectContext = appDelegate.persistentContainer.viewContext
                
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"UserContacts")
                    fetchRequest.predicate = predicate
                    do {
                        searchpeople = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                        print("search result \(searchpeople)")
                    } catch let error as NSError {
                        print("Could not fetch. \(error)")
                    }
            }
            tableView.reloadData()
        }
    }
}


