//
//  ViewModelClass.swift
//  PayAzaSDK
//
//  Created by KS on 10/09/2022.
//

import Foundation


class ViewModelClass: ObservableObject {
    var loadedAccountNumber : LiveData<Bool> = LiveData(false)
    var userInfoLiveData : LiveData<Bool> = LiveData(false)
    var fetchCustomerInfo: LiveData<UserInfo?> = LiveData(nil)
    var fetchAccountResponse: LiveData<AccountResponse?> = LiveData(nil)
    var fetchNewAccount: LiveData<AccountResponse?> = LiveData(nil)
    var paymentVerifiedByPayAza : LiveData<TransactionResponse?> = LiveData(nil)
    var paymentComplete : LiveData<TransactionResponse?> = LiveData(nil)
    var hasServerErrror : LiveData<String?> = LiveData(nil)
    var serverError : LiveData<String?> = LiveData(nil)
    var getChargeResponse : LiveData<ChargeCardResponse?> = LiveData(nil)
    var threeDSResponse:LiveData<Bool?> = LiveData(nil)
    
    
    
    
    
    func cardFormValidation(cardNum: UITextField, cardDate: UITextField, cardCVV: UITextField, controllers: Controllers, vc: UIViewController) -> Bool{
        if !controllers.isFieldValid(editField: cardNum, vc: vc, errorText: Variables.ErrorMessage.invalidCardNum) {
             return false
        }
        if !controllers.isFieldValid(editField: cardDate, vc: vc, errorText: Variables.ErrorMessage.invalidCardDate) {
            return false
        }
        if !controllers.isFieldValid(editField: cardCVV, vc: vc, errorText: Variables.ErrorMessage.invalidCardCvv) {
            return false
        }
        if cardNum.text!.count > 16 {
            vc.showToast(message: Variables.ErrorMessage.invalidCardNum, font: .systemFont(ofSize: 14))
            return false
        }
        if cardDate.text!.count !=  5 {
            vc.showToast(message: Variables.ErrorMessage.invalidCardDate, font: .systemFont(ofSize: 14))
            return false
        }
       
        if cardCVV.text!.count != 3 {
            vc.showToast(message: Variables.ErrorMessage.invalidCardCvv, font: .systemFont(ofSize: 14))
            return false
        }

        return true
    }
    
    func cardTypeValidator(cardField: UITextField){
//        if let type = CreditCardValidator(number).type {
//            print(type.name) // Visa, Mastercard, Amex etc.
//        } else {
//            // I Can't detect type of credit card
//        }
        
        
    }
}
