//
//  TestViewController.swift
//  PayAzaSDK_Example
//
//  Created by KS on 12/09/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import PayazaPod

class TestViewController: UIViewController, PayazaCallbackMethods {
    
    
    @IBOutlet weak var merchantName: UITextField!
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var modeText: UILabel!
    @IBOutlet weak var keyField: UITextField!
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var emailAdreess: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    private let baseUrl = "https://router-live.78financials.com/api/request/secure/payloadhandler"
    private let merchantKey = "PZ78-PKLIVE-BCCEB00C-87A4-4F2A-A25B-439315F2EF91"
    //PZ78-PKLIVE-BCCEB00C-87A4-4F2A-A25B-439315F2EF91
    //PZ78-PKLIVE-9402C5AF-54AC-4A10-8C95-7A460CF72C39
    
    @IBOutlet weak var liveSwitch: UISwitch!
    private var isLive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        emailAdreess.delegate = self
        phone.delegate = self
        amount.delegate = self
        keyField.text = merchantKey
        firstName.text = "koslov"
        lastName.text = "getnada"
        emailAdreess.text =  "koslov@getnada.com"
        phone.text = "986755768"
        amount.text = "1"
        
        fieldView.isUserInteractionEnabled = true
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
           fieldView.addGestureRecognizer(tapAction)
        
    }
    
    @objc func closeKeyboard(){
        phone.resignFirstResponder()
        amount.resignFirstResponder()
    }

    @IBAction func checkOutAction(_ sender: Any) {
        let manager = PayazaManager()
        manager.initialize(delegateController: self, viewControler: self)
    
        
        // Perform Checks
        
        if firstName.text == nil || firstName.text == "" {
            showToast(message: "Invalid First name", font: .systemFont(ofSize: 14))
            return
        }
        else if lastName.text == nil || lastName.text == "" {
            showToast(message: "Invalid Last Name", font: .systemFont(ofSize: 14))
            return
        }
        else if emailAdreess.text == nil || emailAdreess.text == "" {
            showToast(message: "Invalid Email Address", font: .systemFont(ofSize: 14))
            return
        }
        else if phone.text == nil || phone.text == "" {
            showToast(message: "Invalid phon number", font: .systemFont(ofSize: 14))
            return
        }
        else if amount.text == nil || amount.text == "" {
            showToast(message: "Invalid transaction amount", font: .systemFont(ofSize: 14))
            return
        }
        
        else if merchantName.text == nil || merchantName.text == "" {
            showToast(message: "Invalid Merchant name", font: .systemFont(ofSize: 14))
            return
        }
        
        let transactionAmount: Double? = Double(amount.text!)
        
        
        manager.PayAzaConfig(merchantKey: keyField.text!, merchantName: merchantName.text!, firstname: firstName.text!, lastname: lastName.text!, email: emailAdreess.text!, phone: phone.text!, transactionRef: "buigbdghy9484", amount: transactionAmount!, isLive: isLive, baseUrl: baseUrl)
        manager.payNow()
        
        
        
        
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if liveSwitch.isOn {
            isLive = true
            self.modeText.text = "Live"
        }else{
            isLive = false
            self.modeText.text = "Test"
        }
    }
    
    @IBAction func okAction(_ sender: Any) {
        showToast(message: "Ok", font: .systemFont(ofSize: 14))
        dialogView.isHidden = true
    }
    
    @IBAction func launchPayAza(_ sender: Any) {
        
        
    }
    
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
             var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

             if (cString.hasPrefix("#")) {
                 cString.remove(at: cString.startIndex)
             }

             if ((cString.count) != 6) {
                 return UIColor.gray
             }

             var rgbValue:UInt64 = 0
             Scanner(string: cString).scanHexInt64(&rgbValue)

             return UIColor(
                 red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                 alpha: CGFloat(1.0)
             )
         }

}

extension TestViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName {
            firstName.resignFirstResponder()
            lastName.becomeFirstResponder()
        }
        
        if textField == lastName {
            lastName.resignFirstResponder()
            emailAdreess.becomeFirstResponder()
        }
        if textField == emailAdreess {
            emailAdreess.resignFirstResponder()
            phone.becomeFirstResponder()
        }
        if textField == phone {
            phone.resignFirstResponder()
            amount.becomeFirstResponder()
        }
        if textField == amount {
            amount.resignFirstResponder()
        }
        
        return false
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-95, width: 250, height: 35))
        toastLabel.backgroundColor = hexStringToUIColor(hex: "#676E7E").withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    
    func onPaymentCancelled(errorMessage: String) {
        showToast(message: errorMessage, font: .systemFont(ofSize: 14))
    }
    
    func onPaymentComplete(response: TransactionResponse) {
        self.dialogView.isHidden = false
        print(response)
    }
    
    }
