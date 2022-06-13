//
//  ViewController.swift
//  RecruitLog
//
//  Created by Ian Schrauth on 3/15/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    
    @IBOutlet weak var saveEmail: UISwitch!
    @IBOutlet weak var autoLogin: UISwitch!

    @IBAction func login_clicked(_ sender: UIButton) {
        
        login(email: email.text!, pass: password.text!)

        
       
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "autoLoggedInEnabled")
        let email = defaults.string(forKey: "email")
        let password = defaults.string(forKey: "password")
        
        print(email!)
        print(password!)
        
        checkForAutoLogin()
        checkforSavedVars()
        
        // Do any additional setup after loading the view.
    }


    
    func goToHomeViewController() {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "homePage") as! HomeViewController
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
        
    }
    
    
    func checkForAutoLogin() {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "autoLoggedInEnabled")
        let email = defaults.string(forKey: "emailForLogin")
        let password = defaults.string(forKey: "password")

        
        if (token == "false") {
            //nothing
        } else {
            login(email: email!, pass: password!)
            
        }
    }
    
    
    
    func checkforSavedVars() {
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")

        var modToken = email!.replacingOccurrences(of: "(at)", with: "@")
        var savedEmail = modToken.replacingOccurrences(of: "(dot)", with: ".")
        
        if (email == "") {
            saveEmail.isOn = false
        } else {
            self.email.text = savedEmail
            saveEmail.isOn = true
        }
        
        
    }
    
    
    
    
    func login(email: String, pass: String) {
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
          
            if (error != nil) {
                let alert = UIAlertController(title: "Problem with your Email or password", message: "Please make sure you typed your email, password, or IBO number correctly. If it is correct, try again. If the problem continues, email starboatllc@gmail.com for support. If you have not registered with us to use the app, please register first BEFORE logging in.", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
                self!.present(alert, animated: true)
                
            }else {
                
                if (self!.autoLogin.isOn) {
                    let defaults = UserDefaults.standard
                    defaults.set("true", forKey: "autoLoggedInEnabled")
                    let password = defaults.string(forKey: "password")

                    self!.saveEmailToDevice(email: email)
                    self!.savePasswordToDevice(password: password!)
                    self!.goToHomeViewController()

                } else if (self!.saveEmail.isOn) {
                    self!.saveEmailToDevice(email: email)
                    let defaults = UserDefaults.standard
                    defaults.set("true", forKey: "saveEAP")
                    self!.goToHomeViewController()
                }else {
                    let defaults = UserDefaults.standard
                    defaults.set("false", forKey: "autoLoggedInEnabled")
                    defaults.set("false", forKey: "saveEIP")
                    self!.goToHomeViewController()

                }
                
                
                
            }
          
        }
    }
    
    
    func saveEmailToDevice(email: String) {
        let defaults = UserDefaults.standard
        var emailModified = email.replacingOccurrences(of: "@", with: "(at)")
        var emailDatabaseCompliant = emailModified.replacingOccurrences(of: ".", with: "(dot)")
        defaults.set(emailDatabaseCompliant, forKey: "email")
        defaults.set(email, forKey: "emailForLogin")
    }
    
    func savePasswordToDevice(password: String) {
        let defaults = UserDefaults.standard
 
        defaults.set(password, forKey: "password")
 
    }
    
    
    
    
  
    
    
}

