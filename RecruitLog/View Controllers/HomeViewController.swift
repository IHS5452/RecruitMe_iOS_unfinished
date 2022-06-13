//
//  ViewController.swift
//  RecruitLog
//
//  Created by Ian Schrauth on 3/15/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var leads = Leads()

    var selectedRowNumber = 0
    var leadName = ""
    var seledctedName = ""
    var isSearching = false
    
    var first_name: String?
    var last_name: String?
    var sfx: String?
    var em: String?
    var addr1: String?
    var addr2: String?
    var cit: String?
    var st: String?
    var zp: String?
    

    
    var info = retreveInfo()

    var ref: DatabaseReference = Database.database().reference()
    var actionButton : ActionButton!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leads.users_in_database.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leads_table.dequeueReusableCell(withIdentifier: "cell")!
        
        let text = leads.users_in_database[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        clear()
        disableAllInfoFields()
        
        let cell = leads_table.dequeueReusableCell(withIdentifier: "cell")!
        
        
        leadName = leads.users_in_database[indexPath.row]
        
        var leadSep = leadName.components(separatedBy: ": ")

        retreve(name: leadSep[0].replacingOccurrences(of: " ", with: "-"), catagory: leadSep[1],showPopup: "no")
      seledctedName =  leadSep[0].replacingOccurrences(of: " ", with: "-")
        selectedRowNumber = indexPath.row
        print(selectedRowNumber)
        
        //search for the notes
        //insert he notes into the scroolable text feild
        
        
        
    }
    var fnameDB = ""
    var lnameDB = ""
    var add1DB = ""
    var add2DB = ""
    var cityDB = ""
    var stateDB = ""
    var zipDB = ""
    var suffixDB = ""
    var emailDB = ""
    
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var suffix: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var newnote_TXT: UITextField!
    @IBOutlet weak var leads_table: UITableView!
    @IBOutlet weak var searchBox: UITextField!
    

    @IBAction func search(_ sender: UIButton) {
        
        retreve(name: searchBox.text!.replacingOccurrences(of: " ", with: "-").uppercased().trimmingCharacters(in: .whitespacesAndNewlines), catagory: "Both", showPopup: "yes")

    }
    
   func gotoNoteVC() {
//        let vc = storyboard!.instantiateViewController(withIdentifier: "notes") as! NoteViewController
//        let nc = UINavigationController(rootViewController: vc)
//
//        self.present(nc, animated: true)
    let alert = UIAlertController(title: "Not avalabe in the free edition", message: "In order to save notes about this client, you must purchase the full version of RecruteMe. Don't worry, your leads are saved and all you need to do is login to your account in the piad version.", preferredStyle: .alert)

alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

    self.present(alert, animated: true)
        
        
    }

    func new_blank_lead() {
       clear()
        enableAllInfoFields()
        
        
    }
    
    func add_lead_to_database() {
        var lead = ModifyLeads()

        
        lead.add(first_name: self.fname.text!, last_name: self.lname.text!, suffix: self.suffix.text!, em: self.email.text!, addressOne: self.address1.text!, addressTwo: self.address2.text!, city: self.city.text!, state: self.state.text!, zip: self.zip.text!)
        leads.users_in_database.append("\(self.fname.text!.uppercased()) \(self.lname.text!.uppercased()): In Progress")
        self.leads_table.reloadData()
        clear()
  
        
        
    }
    
  
    func moveToCompleted() {
        var lead = ModifyLeads()

        
        lead.markAsComplete(first_name: self.fname.text!, last_name: self.lname.text!, suffix: self.suffix.text!, em: self.email.text!, addressOne: self.address1.text!, addressTwo: self.address2.text!, city: self.city.text!, state: self.state.text!, zip: self.zip.text!)
        leads.users_in_database.append("\(self.fname.text!.uppercased()) \(self.lname.text!.uppercased()): In Progress")
        self.leads_table.reloadData()
        clear()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            self.leads.users_in_database.removeAll()
            self.retreveAllLeads()
            print(self.leads.users_in_database)
            self.leads_table.reloadData()

        }
        
        
    }
    
    
    
    func updateLead() {
        var lead = ModifyLeads()

        lead.update(full_name: seledctedName, em: self.email.text!, addressOne: self.address1.text!, addressTwo: self.address2.text!, city: self.city.text!, state: self.state.text!, zip: self.zip.text!)
        clear()
        
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        leads_table.dataSource = self
        leads_table.delegate = self
        retreveAllLeads()

 
        
        
        
//        self.fname.delegate = self
//        self.lname.delegate = self
//        self.address1.delegate = self
//        self.address2.delegate = self
//        self.city.delegate = self
//        self.state.delegate = self
//        self.zip.delegate = self
//        self.suffix.delegate = self
//        self.email.delegate = self
        
        //get the leads in the database
        //put them in the users_in_database array
        
        
        
        
        // Do any additional setup after loading the view.
    }

    func retreveAllLeads() {
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        
        
        ref.child(token!).child("pot-recruts").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            
            for child in snapshot.children {

                
      //          let username = value?["username"] as? String ?? "NO NAME"
               print((child as! DataSnapshot).key)
                self.leads.users_in_database.append("\((child as! DataSnapshot).key.replacingOccurrences(of: "-", with: " ")): In Progress")
                self.leads_table.reloadData()

            }
   

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child(token!).child("comp-recruts").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            
            for child in snapshot.children {

                
      //          let username = value?["username"] as? String ?? "NO NAME"
               print((child as! DataSnapshot).key)
                self.leads.users_in_database.append("\((child as! DataSnapshot).key.replacingOccurrences(of: "-", with: " ")): Complete")
                self.leads_table.reloadData()

            }
   

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func retreveCompletedONLY() {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        
        ref.child(token!).child("comp-recruts").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            
            for child in snapshot.children {

                
      //          let username = value?["username"] as? String ?? "NO NAME"
               print((child as! DataSnapshot).key)
                self.leads.users_in_database.append("\((child as! DataSnapshot).key.replacingOccurrences(of: "-", with: " ")): Complete")
                self.leads_table.reloadData()

            }
   

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrevePotetionalONLY() {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        
        ref.child(token!).child("pot-recruts").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            
            for child in snapshot.children {

                
      //          let username = value?["username"] as? String ?? "NO NAME"
               print((child as! DataSnapshot).key)
                self.leads.users_in_database.append("\((child as! DataSnapshot).key.replacingOccurrences(of: "-", with: " ")): In Progress")
                self.leads_table.reloadData()

            }
   

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func disableAllInfoFields() {
        fname.isEnabled = false
        lname.isEnabled = false
        suffix.isEnabled = false
        email.isEnabled = false
        address1.isEnabled = false
        address2.isEnabled = false
        city.isEnabled = false
        state.isEnabled = false
        zip.isEnabled = false
        
    }
 
    func enableAllInfoFields() {
        fname.isEnabled = true
        lname.isEnabled = true
        suffix.isEnabled = true
        email.isEnabled = true
        address1.isEnabled = true
        address2.isEnabled = true
        city.isEnabled = true
        state.isEnabled = true
        zip.isEnabled = true
        
    }
    
    
    func clear() {
        fname.text = ""
        lname.text = ""
        suffix.text = ""
        email.text = ""
        address1.text = ""
        address2.text = ""
        city.text = ""
        state.text = ""
        zip.text = ""
        
    }
    
    
    
    
    
    func openSearchVC() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "search") as! SearchViewController

        self.present(vc, animated: true)
        
        
//        let vc = storyboard!.instantiateViewController(withIdentifier: "search") as! SearchViewController
//        let nc = UINavigationController(rootViewController: vc)
//
//        self.present(nc, animated: true)
//
    }
    
    
    
    
    func search(lead_name: String) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        
        
        ref.child(token!).child("pot-recruts").child(lead_name).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary

            let fnameDB = value?["fname"] as? String ?? "NOT LOADED"
            let lnameDB = value?["lname"] as? String ?? "NOT LOADED"
            let add1DB = value?["address1"] as? String ?? "NOT LOADED"
            let add2DB = value?["address2"] as? String ?? "NOT LOADED"
            let cityDB = value?["city"] as? String ?? "NOT LOADED"
            let stateDB = value?["state"] as? String ?? "NOT LOADED"
            let zipDB = value?["zip"] as? String ?? "NOT LOADED"
            let suffixDB = value?["suffix"] as? String ?? "NOT LOADED"
            let emailDB = value?["email"] as? String ?? "NOT LOADED"

            if (fnameDB == nil) {
                let alert = UIAlertController(title: "No User Found", message: "We did not find a lead named \(lead_name). Please check the speling and try again.", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
                self.present(alert, animated: true)
            }
            
            
            self.fname.text = fnameDB
            self.lname.text = lnameDB
            self.address1.text = add1DB
            self.address2.text = add2DB
            self.city.text = cityDB
            self.state.text = stateDB
            self.zip.text = zipDB
            self.suffix.text = suffixDB
            self.email.text = emailDB



          // ...
          }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    func setupButtons(){
        let AN = ActionButtonItem(title: "Add Note", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let AL = ActionButtonItem(title: "Start New Lead", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let SNL = ActionButtonItem(title: "Save New Lead", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let ECL = ActionButtonItem(title: "Edit current lead", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let SAVE = ActionButtonItem(title: "Save Current Lead", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let MLAS = ActionButtonItem(title: "Mark Lead as COMPLETE", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))
        let S = ActionButtonItem(title: "Quick Search", image: #imageLiteral(resourceName: "floatinghButtonMain.png"))


        AN.action = { [self] item in gotoNoteVC(); actionButton.toggleMenu() }
        AL.action = { [self] item in new_blank_lead(); actionButton.toggleMenu() }

        SNL.action = { [self] item in add_lead_to_database(); actionButton.toggleMenu()  }
        ECL.action = { [self] item in enableAllInfoFields(); actionButton.toggleMenu()  }
        
        SAVE.action = { [self] item in updateLead(); actionButton.toggleMenu()  }
        MLAS.action = { [self] item in moveToCompleted(); actionButton.toggleMenu()  }
        S.action = { [self] item in openSearchVC(); actionButton.toggleMenu()  }

        
        actionButton = ActionButton(attachedToView: self.view, items: [AN, AL, SNL, ECL, SAVE, MLAS, S])
        actionButton.setTitle("+", forState: UIControl.State())
        actionButton.action = { button in button.toggleMenu()}
    }

    
    
    func retreve(name: String, catagory: String, showPopup: String) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        var ref: DatabaseReference = Database.database().reference()
        let home = HomeViewController()


        
        if (catagory == "In Progress") {
            ref.child(token!).child("pot-recruts").child(name).observeSingleEvent(of: .value, with: { snapshot in
              // Get user value
                let value = snapshot.value as? NSDictionary

                self.fnameDB = value?["fname"] as? String ?? "NOT LOADED"
                self.lnameDB = value?["lname"] as? String ?? "NOT LOADED"
                self.add1DB = value?["address1"] as? String ?? "NOT LOADED"
                self.add2DB = value?["address2"] as? String ?? "NOT LOADED"
                self.cityDB = value?["city"] as? String ?? "NOT LOADED"
                self.stateDB = value?["state"] as? String ?? "NOT LOADED"
                self.zipDB = value?["zip"] as? String ?? "NOT LOADED"
                self.suffixDB = value?["suffix"] as? String ?? "NOT LOADED"
                self.emailDB = value?["email"] as? String ?? "NOT LOADED"

                
                self.filInTextBoxes(fname: self.fnameDB, lname: self.lnameDB, add1: self.add1DB, add2: self.add2DB, city: self.cityDB, state: self.stateDB, zip: self.zipDB, suffix: self.suffixDB, email: self.emailDB)

                
               



              // ...
              }) { (error) in
                print(error.localizedDescription)
            }

        } else if (catagory == "Complete") {
            ref.child(token!).child("comp-recruts").child(name).observeSingleEvent(of: .value, with: { [self] snapshot in
              // Get user value
                let value = snapshot.value as? NSDictionary

                self.fnameDB = value?["fname"] as? String ?? "NOT LOADED"
                self.lnameDB = value?["lname"] as? String ?? "NOT LOADED"
                self.add1DB = value?["address1"] as? String ?? "NOT LOADED"
                self.add2DB = value?["address2"] as? String ?? "NOT LOADED"
                self.cityDB = value?["city"] as? String ?? "NOT LOADED"
                self.stateDB = value?["state"] as? String ?? "NOT LOADED"
                self.zipDB = value?["zip"] as? String ?? "NOT LOADED"
                self.suffixDB = value?["suffix"] as? String ?? "NOT LOADED"
                self.emailDB = value?["email"] as? String ?? "NOT LOADED"

                
                self.filInTextBoxes(fname: self.fnameDB, lname: self.lnameDB, add1: self.add1DB, add2: self.add2DB, city: self.cityDB, state: self.stateDB, zip: self.zipDB, suffix: self.suffixDB, email: self.emailDB)

                
                


              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        

        } else if (catagory == "Both") {
            
            
                    
                    ref.child(token!).child("pot-recruts").child(name).observeSingleEvent(of: .value, with: { snapshot in
                      // Get user value
                        let value = snapshot.value as? NSDictionary

                        self.fnameDB = value?["fname"] as? String ?? "NOT LOADED"
                        self.lnameDB = value?["lname"] as? String ?? "NOT LOADED"
                        self.add1DB = value?["address1"] as? String ?? "NOT LOADED"
                        self.add2DB = value?["address2"] as? String ?? "NOT LOADED"
                        self.cityDB = value?["city"] as? String ?? "NOT LOADED"
                        self.stateDB = value?["state"] as? String ?? "NOT LOADED"
                        self.zipDB = value?["zip"] as? String ?? "NOT LOADED"
                        self.suffixDB = value?["suffix"] as? String ?? "NOT LOADED"
                        self.emailDB = value?["email"] as? String ?? "NOT LOADED"
                        
                    

                        self.filInTextBoxes(fname: self.fnameDB, lname: self.lnameDB, add1: self.add1DB, add2: self.add2DB, city: self.cityDB, state: self.stateDB, zip: self.zipDB, suffix: self.suffixDB, email: self.emailDB)
                       



                      // ...
                      }) { (error) in
                        print(error.localizedDescription)
                    }
            if (self.fnameDB == "NOT LOADED") {
                        ref.child(token!).child("comp-recruts").child(name).observeSingleEvent(of: .value, with: { [self] snapshot in
                          // Get user value
                            let value = snapshot.value as? NSDictionary

                            self.fnameDB = value?["fname"] as? String ?? "NOT LOADED"
                            self.lnameDB = value?["lname"] as? String ?? "NOT LOADED"
                            self.add1DB = value?["address1"] as? String ?? "NOT LOADED"
                            self.add2DB = value?["address2"] as? String ?? "NOT LOADED"
                            self.cityDB = value?["city"] as? String ?? "NOT LOADED"
                            self.stateDB = value?["state"] as? String ?? "NOT LOADED"
                            self.zipDB = value?["zip"] as? String ?? "NOT LOADED"
                            self.suffixDB = value?["suffix"] as? String ?? "NOT LOADED"
                            self.emailDB = value?["email"] as? String ?? "NOT LOADED"

                            print("Switched to completed recruts")
                                   
                            self.filInTextBoxes(fname: self.fnameDB, lname: self.lnameDB, add1: self.add1DB, add2: self.add2DB, city: self.cityDB, state: self.stateDB, zip: self.zipDB, suffix: self.suffixDB, email: self.emailDB)


                          // ...
                          }) { (error) in
                            print(error.localizedDescription)
                        }
                    

                    
                    

                
                    
                    
                    
                    
                
            }else {
                
            }
            

           
            
        } else if (showPopup == "yes") {
            let alert = UIAlertController(title: "No User Found", message: "We did not find a lead named \(searchBox.text!). Please check the speling and try again.", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    
            self.present(alert, animated: true)
        } else {
            //nothing
        }
        
        
  
    }

    
    func filInTextBoxes(fname: String, lname: String, add1: String, add2: String, city: String, state: String, zip: String, suffix: String, email: String ){
        
        self.fname.text = fname
        self.lname.text = lname
        self.address1.text = add1
        self.address2.text = add2
        self.city.text = city
        self.state.text = state
        self.zip.text = zip
        self.suffix.text = suffix
        self.email.text = email
        
        
        
    }
    
    
}




