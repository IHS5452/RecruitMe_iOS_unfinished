//
//  newLead.swift
//  RecruitLog
//
//  Created by Ian Schrauth on 3/17/21.
//

import Foundation
import Firebase

class ModifyLeads {
    
    
    func update(full_name: String, em: String, addressOne: String, addressTwo: String, city: String, state: String, zip: String) {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        var ref: DatabaseReference  = Database.database().reference()
        
        
      

        ref.child("\(email!)/pot-recruts/\(full_name)/address1").setValue(addressOne)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(full_name)/address2").setValue(addressTwo)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(full_name)/city").setValue(city)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(full_name)/state").setValue(state)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(full_name)/zip").setValue(zip)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(full_name)/email").setValue(em)
        print("Added")


    }
    
    func add(first_name: String, last_name: String, suffix: String, em: String, addressOne: String, addressTwo: String, city: String, state: String, zip: String) {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        var ref: DatabaseReference  = Database.database().reference()
        
        
        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/fname").setValue(first_name)
        print("Added")
        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/lname").setValue(last_name)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/address1").setValue(addressOne)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/address2").setValue(addressTwo)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/city").setValue(city)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/state").setValue(state)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/zip").setValue(zip)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/email").setValue(em)
        print("Added")

        ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())/suffix").setValue(suffix)
        print("Added")

    }
    
    
    func markAsComplete(first_name: String, last_name: String, suffix: String, em: String, addressOne: String, addressTwo: String, city: String, state: String, zip: String) {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        var ref: DatabaseReference  = Database.database().reference()
        
    
        //Add lead to comp-recrtues


        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/fname").setValue(first_name)
        print("Added")
        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/lname").setValue(last_name)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/address1").setValue(addressOne)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/address2").setValue(addressTwo)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/city").setValue(city)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/state").setValue(state)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/zip").setValue(zip)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/email").setValue(em)
        print("Added")

        ref.child("\(email!)/comp-recruts/\(first_name.uppercased())-\(last_name.uppercased())/suffix").setValue(suffix)
        print("Added")
        
        
        //get the notes and put them in the new section of the datatabsee
        
        getNotesAndPutInArray(name: "\(first_name.uppercased())-\(last_name.uppercased())")
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ref.child("\(email!)/pot-recruts/\(first_name.uppercased())-\(last_name.uppercased())").removeValue()
                    print("Removed")
            
        }
//


        

    }
    
    
    private func getNotesAndPutInArray(name: String) {
        var ref: DatabaseReference = Database.database().reference()
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        var notesArray = [Any?]()
        var noteNumber = 1
      
        ref.child(token!).child("pot-recruts").child(name).child("notes").observeSingleEvent(of: .value, with: { [self] snapshot in
                
                for child in snapshot.children {
                 
                    self.finalStep(name: name, noteKey: (child as! DataSnapshot).key)
                    

                }
              }) { (error) in
                print(error.localizedDescription)
            }
        
      
    }
    
    private func finalStep(name: String, noteKey: String) {
        var ref: DatabaseReference = Database.database().reference()
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "email")
        var notesArray = [Any?]()

      
        ref.child(token!).child("pot-recruts").child(name).child("notes").child(noteKey).observeSingleEvent(of: .value, with: { snapshot in
              // Get user value
                
            
                    
                let value = snapshot.value as? NSDictionary
                let date = value?["date"] as? String ?? ""
                let text = value?["text"] as? String ?? ""
                
                print(date)
               print(text)
               
                    ref.child("\(token!)/comp-recruts/\(name)/notes/\(noteKey)/date").setValue("\(date)")
                ref.child("\(token!)/comp-recruts/\(name)/notes/\(noteKey)/text").setValue(text)
            
                
              }) { (error) in
                print(error.localizedDescription)
            }
        
      
    }
    
    
}




