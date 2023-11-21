//
//  ModelClass.swift
//  PayazaSdk
//
//  Created by KS on 08/09/2022.
//

import Foundation

class CheckoutResponse: NSObject  {
   
    public var transaction_amount: String?
    public var transaction_fee_amount: String?
    public var business: Business?
    public var customer: UserInfo?
    public var currency: Currency?
    
    
    init(transaction_amount: String?, transaction_fee_amount: String?, business: Business, customer: UserInfo, currency: Currency) {
        self.transaction_amount = transaction_amount
        self.transaction_fee_amount = transaction_fee_amount
        self.business = business
        self.customer = customer
        self.currency = currency
    }
    
    init(checkout: NSDictionary) {
        transaction_amount = (checkout["transaction_amount"]) as! String?
        transaction_fee_amount = (checkout["transaction_fee_amount"]) as! String?
        business = Business(business: checkout["business"] as! NSDictionary)
        customer = UserInfo(userinfo: checkout["customer"] as! NSDictionary)
        currency = Currency(currency: checkout["currency"] as! NSDictionary)
        
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "transaction_amount" : transaction_amount!,
            "transaction_fee_amount": transaction_fee_amount!,
            "business": business ?? "",
            "customer": customer ?? "",
            "currency": currency ?? "",
        ]
    }
}

class AccountResponse: NSObject  {
    public var id: Int64?
    public var transaction_amount: String?
    public var transaction_fee_amount: String?
    public var account_name: String?
    public var bank_code: String?
    public var bank_name: String?
    public var currency: Currency?
    public var transaction_reference: String?
    public var account_number: String?
    public var transaction_payable_amount: String?
    
    
  
    
    init(id: Int64?, transaction_amount: String?, transaction_fee_amount: String?, account_name: String?, bank_code: String?, currency: Currency, bank_name: String?, transaction_reference: String?, account_number: String?, transaction_payable_amount: String? ) {
        self.id = id
        self.transaction_reference = transaction_reference
        self.transaction_amount = transaction_amount
        self.transaction_fee_amount = transaction_fee_amount
        self.account_name = account_name
        self.account_number = account_number
        self.transaction_payable_amount = transaction_payable_amount
        self.currency = currency
        self.bank_code = bank_code
        self.bank_name = bank_name
    }
    
    init(checkout: NSDictionary) {
        transaction_amount = (checkout["transaction_amount"]) as! String?
        transaction_fee_amount = (checkout["transaction_fee_amount"]) as! String?
        account_name = (checkout["account_name"]) as! String?
        bank_code = (checkout["bank_code"]) as! String?
        currency = Currency(currency: checkout["currency"] as! NSDictionary)
        bank_name = (checkout["bank_name"]) as! String?
        transaction_reference = (checkout["transaction_reference"]) as! String?
        transaction_payable_amount = (checkout["transaction_payable_amount"]) as! String?
        account_number = (checkout["account_number"]) as! String?
        id = (checkout["id"]) as! Int64?
        
        
        
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "transaction_amount" : transaction_amount ?? "",
            "transaction_fee_amount": transaction_fee_amount ?? "",
            "account_name": account_name ?? "",
            "id": id ?? "",
            "currency": currency?.toAnyObject ?? "",
        ]
    }
}

class UserInfo: NSObject  {
    public var first_name: String?
    public var last_name: String?
    public var email_address: String?
    public var phone_number: String?
    public var transactionRef: String?
   
  
    
    init(first_name: String?, last_name: String?, email_address: String?, phone_number : String, transactionRef: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.email_address = email_address
        self.phone_number = phone_number
        self.transactionRef = transactionRef
    }
    
    init(userinfo: NSDictionary) {
        first_name = (userinfo["first_name"]) as! String?
        last_name = (userinfo["last_name"]) as! String?
        email_address = (userinfo["email_address"]) as! String?
        transactionRef = (userinfo["transactionRef"]) as! String?
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "first_name" : first_name ?? "",
            "last_name": last_name ?? "",
            "email_address": email_address ?? "",
        ]
    }
}

class DeviceInfo: NSObject  {
    public var deviceName: String?
    public var deviceId: String?
    public var deviceOs: String?
   
   
  
    
    init(deviceName: String?, deviceId: String?, deviceOs: String?) {
        self.deviceName = deviceName
        self.deviceId = deviceId
        self.deviceOs = deviceOs
    }
    
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "deviceName" : deviceName ?? "",
            "deviceId": deviceId ?? "",
            "deviceOs": deviceOs ?? "",
        ]
    }
}

public class TransactionResponse: NSObject  {
    public var message: String?
    public var status: String?
    public var reference: String?
    public var time: String?
    
  
    
    init(message: String?, status: String?, reference: String?, time: String?) {
        self.message = message
        self.status = status
        self.reference = reference
        self.time = time
    }
    
    init(responses: NSDictionary) {
        message = (responses["message"]) as! String?
        status = (responses["status"]) as! String?
        reference = (responses["reference"]) as! String?
        time = (responses["time"]) as! String?
    }
    
  
}

class Business: NSObject  {
    public var id: String?
    public var avatar: String?
    public var name: String?
    public var business_public_id: String?
  
    
    init(id: String?, avatar: String?, name: String?, business_public_id: String?) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.business_public_id = business_public_id
    }
    
    init(business: NSDictionary) {
        id = (business["id"]) as! String?
        avatar = (business["avatar"]) as! String?
        name = (business["name"]) as! String?
        business_public_id = (business["business_public_id"]) as! String?
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "id" : id ?? "",
            "avatar": avatar ?? "",
            "name": name ?? "",
            "business_public_id" : business_public_id ?? "",
        ]
    }
}

class Currency: NSObject  {
    public var id: Int64?
    public var code: String?
    public var name: String?
    public var unicode: String?
    public var html_value: String?
    
  
    
    init(id: Int64?, code: String?, name: String?, unicode: String?, html_value: String? ) {
        self.id = id
        self.code = code
        self.name = name
        self.unicode = unicode
        self.html_value = html_value
    }
    
    init(currency: NSDictionary) {
        id = (currency["id"]) as! Int64?
        code = (currency["code"]) as! String?
        name = (currency["name"]) as! String?
        unicode = (currency["unicode"]) as! String?
        self.html_value = (currency["html_value"]) as! String?
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "id": id ?? "",
            "name": name ?? "",
            "code": code ?? "",
            "unicode": unicode ?? "",
            "html_value": html_value ?? ""
        ]
    }
}

class CardBody: NSObject  {
    public var expiryMonth: String?
    public var expiryYear: String?
    public var securityCode: String?
    public var cardNumber: String?
    
  
    
    init(expiryMonth: String?, expiryYear: String?, securityCode: String?, cardNumber: String? ) {
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.securityCode = securityCode
        self.cardNumber = cardNumber
    }
    
    init(card: NSDictionary) {
        expiryMonth = (card["expiryMonth"]) as! String?
        expiryYear = (card["expiryYear"]) as! String?
        securityCode = (card["securityCode"]) as! String?
        cardNumber = (card["cardNumber"]) as! String?
       
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "expiryMonth": expiryMonth ?? "",
            "expiryYear": expiryYear ?? "",
            "securityCode": securityCode ?? "",
            "cardNumber": cardNumber ?? "",
        ]
    }
}

class ChargeCardResponse: NSObject, Identifiable  {
    public var statusOk: Bool?
    public var message: String?
    public var debugMessage: String?
    public var descriptor: String?
    public var waitForNotification: Bool?
    public var transactionReference: String?
    public var customerReference: String?
    public var do3dsAuth: Bool?
    public var threeDsUrl: String?
    public var formData: String?
    public var threeDsHtml: String?
    public var paymentCompleted: Bool?
    public var amountPaid: Double?
    public var valueAmount: Double?
    public var descriptionn: String?
    
    
  
    
    init(statusOk: Bool?, message: String?, debugMessage: String?, description: String?, descriptor: String?, waitForNotification: Bool? , transactionReference: String?, customerReference: String?, do3dsAuth: Bool?, threeDsUrl: String?, formData : String?, threeDsHtml : String?, paymentCompleted : Bool?, amountPaid: Double?, valueAmount : Double? ) {
        self.statusOk = statusOk
        self.message = message
        self.debugMessage = debugMessage
        self.descriptionn = description
        self.descriptor = descriptor
        self.waitForNotification = waitForNotification
        self.transactionReference = transactionReference
        self.customerReference = customerReference
        self.do3dsAuth = do3dsAuth
        self.threeDsUrl = threeDsUrl
        self.formData = formData
        self.threeDsHtml = threeDsHtml
        self.paymentCompleted = paymentCompleted
        self.amountPaid = amountPaid
        self.valueAmount = valueAmount
    }
    
    init(checkout: NSDictionary) {
        statusOk = (checkout["statusOk"]) as! Bool?
        message = (checkout["message"]) as! String?
        debugMessage = (checkout["debugMessage"]) as! String?
        descriptionn = (checkout["description"]) as! String?
        descriptor = (checkout["descriptor"]) as! String?
        waitForNotification = (checkout["waitForNotification"]) as! Bool?
        transactionReference = (checkout["transactionReference"]) as! String?
        customerReference = (checkout["customerReference"]) as! String?
        do3dsAuth = (checkout["do3dsAuth"]) as! Bool?
        threeDsUrl = (checkout["threeDsUrl"]) as! String?
        threeDsHtml = (checkout["threeDsHtml"]) as! String?
        paymentCompleted = (checkout["paymentCompleted"]) as! Bool?
        amountPaid = (checkout["paymentCompleted"]) as! Double?
        valueAmount = (checkout["valueAmount"]) as! Double?
        
        
        
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "statusOk" : statusOk ?? "",
            "message": message ?? "",
            "debugMessage": debugMessage ?? "",
            "description": descriptionn ?? "",
            "descriptor": descriptor ?? "",
            "waitForNotification" : waitForNotification ?? "",
            "transactionReference" : transactionReference ?? "",
            "customerReference" : customerReference ?? "",
            "do3dsAuth" : do3dsAuth ?? "",
            "threeDsUrl" : threeDsUrl ?? "",
            "formData" : formData ?? "",
            "threeDsHtml" : threeDsHtml ?? "",
            "amountPaid" : amountPaid ?? "",
            "valueAmount" : valueAmount ?? ""
            
        ]
    }
}

class CardDynamicDataValues: NSObject, Identifiable {
    public var currency: String?
    public var callback_url: String?
    public var transaction_reference: String?
    public var transactionDescription: String?
    
  
    
    init(currency: String?, callback_url: String?, transaction_reference: String?, transactionDescription: String?) {
        self.currency = currency
        self.callback_url = callback_url
        self.transaction_reference = transaction_reference
        self.transactionDescription = transactionDescription
    }
    
    init(card: NSDictionary) {
        currency = (card["currency"]) as! String?
        callback_url = (card["callback_url"]) as! String?
        transaction_reference = (card["transaction_reference"]) as! String?
        transactionDescription = (card["description"]) as! String?
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "currency": currency ?? "",
            "callback_url": callback_url ?? "https://payaza.africa/",
            "transaction_reference": transaction_reference ?? "",
            "description": transactionDescription ?? "Test"
        ]
    }
    
}


class CheckTransactionResponse: NSObject, Identifiable {
    public var transaction_amount: Double?
    public var debug_message: String?
    public var transaction_fee: Double?
    public var created_at: String?
    public var transaction_reference: String?
    public var payment_date: String?
    public var transaction_status: String?
    
    
//    init(id: Int64?, transaction_amount: String?, transaction_fee_amount: String?, account_name: String?, bank_code: String?, currency: Currency, bank_name: String?, transaction_reference: String?, account_number: String?, transaction_payable_amount: String? ) {
//        self.id = id
//        self.transaction_reference = transaction_reference
//        self.transaction_amount = transaction_amount
//        self.transaction_fee_amount = transaction_fee_amount
//        self.account_name = account_name
//        self.account_number = account_number
//        self.transaction_payable_amount = transaction_payable_amount
//        self.currency = currency
//        self.bank_code = bank_code
//        self.bank_name = bank_name
//    }
    
    
    init(respons: NSDictionary){
        transaction_amount = (respons["transaction_amount"]) as! Double?
        debug_message = (respons["debug_message"]) as! String?
        transaction_fee = (respons["transaction_fee"]) as! Double?
        created_at = (respons["created_at"]) as! String?
        transaction_reference = (respons["transaction_reference"]) as! String?
        payment_date = (respons["payment_date"]) as! String?
        transaction_status = (respons["transaction_status"]) as! String?
        
    }
    
    func toAnyObject() -> Dictionary<String, Any>
    {
        return [
            "debug_message": debug_message ?? "",
            "debug_message": debug_message as Any,
            "transaction_reference": transaction_reference as Any,
            "created_at": created_at as Any,
            
        ]
    }
}

