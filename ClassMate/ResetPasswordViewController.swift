//
//  ResetPasswordViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/19/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var Email: AMInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: Email.textFieldView.text!) { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "No account was found for \(self.Email.textFieldView.text!)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }
            else {
                let alert = UIAlertController(title: "Reset Link Sent", message: "A reset password email has been sent to \(self.Email.textFieldView.text!)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
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
