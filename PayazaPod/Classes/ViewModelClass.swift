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
    var hasServerError : LiveData<String?> = LiveData(nil)
    var serverError : LiveData<String?> = LiveData(nil)
    var getChargeResponse : LiveData<ChargeCardResponse?> = LiveData(nil)
    var checkTransactionResponse:LiveData<CheckTransactionResponse?> = LiveData(nil)
    
    
    
    
    
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
    
    func getCurrencyIcon(currency: String) -> String{
        if currency == "NGN"{
            return "₦"
        }else {
            if currency == "USD"{
                return "$"
            }else if currency == "EUR" {
                return "€"
            }
            else if currency == "GBP" {
                return "£"
            }
            else {
                return currency
            }
        }
        
    }
}
