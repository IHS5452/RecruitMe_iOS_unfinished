//
//  NoteViewController.swift
//  RecruitLog
//
//  Created by Ian Schrauth on 3/17/21.
//

import Foundation
import UIKit
import Firebase


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var arrays = Leads()
    var info = retreveInfo()
    var HVC = HomeViewController()
    @IBOutlet weak var name: UITextField!

    
    var catagoryType = ""
    var leadName = ""
    
    
    @IBOutlet weak var search_table: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let defaults = UserDefaults.standard
        leadName = arrays.search_results[indexPath.row].replacingOccurrences(of: " ", with: "-").uppercased()
        
        defaults.setValue(leadName, forKey: "searchedName")
        defaults.setValue(catagoryType, forKey: "searchCata")


        
        
        dismiss(animated: true, completion: nil)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
//            let mainSB = UIStoryboard(name: "homePage", bundle: Bundle.main)
//            
//            guard let destinationVC = mainSB.instantiateViewController(identifier: "homePage") as? HomeViewController else {
//                print("error")
//                return
//            }
//            self.navigationController?.pushViewController(destinationVC, animated: true)
//            
//        }
////        {
////            didSet {
////                var info = retreveInfo()
//                info.retreve(name:  arrays.searched_lead, catagory: catagoryType)
////
////            }
////        }
////
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.search_results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = search_table.dequeueReusableCell(withIdentifier: "searchC")!
        
        let text = arrays.search_results[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    

    
    

    var ref: DatabaseReference = Database.database().reference()


    
    @IBAction func search_comp_leads(_ sender: UIButton) {
        catagoryType = "comp-leads"
        var FALNameSeperated = name.text?.components(separatedBy: " ")
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        ref.child(token!).child("comp-recruts").observeSingleEvent(of: .value, with: { [self] snapshot in
          
            
            
            for child in snapshot.children {
                var datasnapshotSplit = ((child as! DataSnapshot).key).components(separatedBy: "-")
              
               
                
    
                
                
                
                
                if (name.text!.replacingOccurrences(of: " ", with: "-").uppercased() == (((child as! DataSnapshot).key))) {
                    arrays.search_results.append("\(datasnapshotSplit[0]) \(datasnapshotSplit[1])")
                    print(arrays.search_results)
                    search_table.reloadData()
                    
                    
                }else {
                    print("NOt similiar")
                    
                }
                
                
                
                
                
               
                
                
                    
                
                
               
                
                
            }
        
            //(child as! DataSnapshot).value(forKey: "fname")

            
            
            
            
            



          // ...
          }) { (error) in
            print(error.localizedDescription)
        }

        
        
        
        
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search_table.dataSource = self
        search_table.delegate = self
        
    }
    

}
