//
//  PayAzaService.swift
//  DropDown
//
//  Created by KS on 10/09/2022.
//

import Foundation

struct PayAzaService {
    var baseUrl: String?
    var merchantKey : String?
    var connectionMode : String?
    var viewModel : ViewModelClass?
    var forStartUp : Bool = true
    var userInfo : UserInfo?
    var transactionAmount: Int64?
    var socketIoManager : SocketIOManager?
    private var controllers = Controllers()
    
    
    
    func initialiseService(deviceInfo : DeviceInfo) {
         var newRequest : URLRequest?
        newRequest = controllers.configureRequestHeader(baseUrl: baseUrl!, connectionMethod: Variables.ConnectionMethod.post, merchantKey: merchantKey!)
 
        let service_payloadData : [String: Any] = [
            "request_application": "Payaza",
            "request_class": "UseCheckoutRequest",
            "application_module": "USER_MODULE",
            "application_version": "1.0.0",
            "request_channel": "MOBILE_APP",
            "currency_code": "NGN",
            "merchant_key": merchantKey!,
            "connection_mode": connectionMode!,
            "checkout_amount": transactionAmount!,
            "email_address": userInfo!.email_address!,
            "first_name": userInfo!.first_name!,
            "last_name": userInfo!.last_name!,
            "phone_number": userInfo!.phone_number!,
            "transaction_reference": userInfo!.transactionRef!,
            "device_id": deviceInfo.deviceId!,
            "device_name": deviceInfo.deviceName!,
            "device_os": deviceInfo.deviceOs!,
            "request_channel_type": "ANDROID",]

             let body : [String: Any] = [
                "service_type": "Transaction",
                "service_payload": service_payloadData
                 
             ]
         do {
             newRequest?.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
         } catch let error {
             print("An error occured while parsing the bodyinto json, error", error)
         }
         
         let session = URLSession.shared
        let task = session.dataTask(with: newRequest!, completionHandler: { data, response, error -> Void in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                  
                    let responseContent = json["response_content"]
                    let responseCode = json["response_code"] as? Int64
                    if responseCode != 200 {
                        let responseServerMessage  = json["response_message"] as? String
                        viewModel!.hasServerErrror.value = responseServerMessage
                    }else {
                        let transactinnRef = responseContent?["transaction_reference"] as? String
                        let customer = UserInfo(userinfo: responseContent?["customer"] as! NSDictionary)
                        if forStartUp{
                            viewModel!.fetchCustomerInfo.value = customer
                        }
                        if transactinnRef != nil {
                            socketIoManager?.viewModel = viewModel
                            socketIoManager?.establishNewConnection(transactionRef: transactinnRef!)
                            generateDynamicNumberService(transactinnRef!, deviceInfo: deviceInfo )
                          
                        }
                    }
                    
                    
                } catch {
                    print("error")
                }
            }
            else {
                print("Turn On Internet Connections")
                viewModel!.hasServerErrror.value = Variables.status.connectionError
            }
            
        })

        task.resume()
                
    }
    

    
    func generateDynamicNumberService( _ transactionRef: String, deviceInfo: DeviceInfo) {
        var newRequest : URLRequest?
        newRequest = controllers.configureRequestHeader(baseUrl: baseUrl!, connectionMethod: Variables.ConnectionMethod.post, merchantKey: merchantKey!)
      

        let service_payloadData = ["request_application": "Payaza",
                        "request_class": "FetchDynamicVirtualAccountRequest",
                        "application_module": "USER_MODULE",
                        "application_version": "1.0.0",
                        "request_channel": "CUSTOMER_PORTAL",
                        "connection_mode": connectionMode!,
                        "transaction_reference": transactionRef,
                        "device_id": deviceInfo.deviceId,
                        "device_name": deviceInfo.deviceName!,
                        "device_os": deviceInfo.deviceOs,
                        "request_channel_type": "API_CLIENT"]

            let body : [String: Any] = [
                "service_type": "Account",
                "service_payload": service_payloadData,
            ]
        do {
                    newRequest?.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
                } catch let error {
                    print("An error occured while parsing the bodyinto json, error", error)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: newRequest!, completionHandler: { data, response, error -> Void in
//            print(response!)
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                  
                    let responseContent = json["response_content"]
                    if responseContent != nil {
                        let accountResponse = AccountResponse(checkout: responseContent as! NSDictionary)
                        if forStartUp{
                            viewModel?.fetchAccountResponse.value = accountResponse
                        }else{
                            viewModel?.fetchNewAccount.value = accountResponse
                        }
                    }else {
                        let responseServerMessage  = json["response_message"] as? String
                        viewModel!.hasServerErrror.value = responseServerMessage
                    }
                    
                    
                } catch {
                    print("error")
                }
            }else {
                print("Turn On Internet Connections")
                viewModel!.hasServerErrror.value = Variables.status.connectionError
            }
            
        })
        task.resume()
}
    
    
    func fundVirtualAccountService() {
        var newRequest : URLRequest?
        newRequest = controllers.configureRequestHeader(baseUrl: baseUrl!, connectionMethod: Variables.ConnectionMethod.post, merchantKey: Variables.ActionKeys.testFundKey)
        
        let service_payloadData : [String: Any] = ["request_application": "Payaza",
                        "request_class": "MerchantFundTestVirtualAccount",
                        "application_module": "USER_MODULE",
                        "application_version": "1.0.0",
                        "account_number": "9916535853",
                        "initiation_transaction_reference": " DOVPORT1234QWE1",
                        "transaction_amount": 12000,
                        "currency": "NGN",
                        "source_account_number": "4859693408",
                        "source_account_name": "John Doe",
                        "source_bank_name": "Eastern Bank"]
        
        let body : [String: Any] = [
            "service_type": "Account",
            "service_payload": service_payloadData,
        ]
        
        do {
                    newRequest?.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
                } catch let error {
                    print("An error occured while parsing the bodyinto json, error", error)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: newRequest!, completionHandler: { data, response, error -> Void in
//            print(response!)
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                  
                    let responseContent = json["response_content"]
                    if responseContent != nil {
                        print(responseContent)
                    }else {
                        let responseServerMessage  = json["response_message"] as? String
                        print(responseServerMessage)
                    }
                    
                    
                } catch {
                    print("error")
                }
            }else {
                print("Turn On Internet Connections")
                viewModel!.hasServerErrror.value = Variables.status.connectionError
            }
            
        })
        task.resume()
        
    }
    
    func chargeCard(card : CardBody?, cardValues : CardDynamicDataValues, user: UserInfo) {
        var newRequest : URLRequest?
        newRequest = controllers.configureRequestHeader(baseUrl: Variables.BaseURLs.cardURl, connectionMethod: Variables.ConnectionMethod.post, merchantKey: merchantKey!)
    
        
        let service_payloadData : [String: Any] = ["request_application": "Payaza",
                                                   "application_module": "USER_MODULE",
                                                   "application_version": "1.0.0",
                                                   "request_class": "UsdCardChargeRequest",
                                                   "first_name": user.first_name!,
                                                   "last_name": user.last_name!,
                                                   "email_address": user.email_address!,
                                                   "phone_number": user.phone_number!,
                                                   "amount": transactionAmount,
                                                   "transaction_reference": cardValues.transaction_reference!,
                                                   "currency": cardValues.currency!,
                                                   "description": cardValues.transactionDescription!,
                                                   "card": card!.toAnyObject(),
                                                   "callback_url": cardValues.callback_url!
                                            
        ]
       
        let body : [String: Any] = [
            "service_type": "Account",
            "service_payload": service_payloadData,
        ]
        
        do {
            newRequest?.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
            } catch let error {
                print("An error occured while parsing the bodyinto json, error", error)
                }
        let session = URLSession.shared
        let task = session.dataTask(with: newRequest!, completionHandler: { data, response, error -> Void in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    let cardRessponse = ChargeCardResponse(checkout: json as NSDictionary)
                    if cardRessponse.statusOk! {
                        self.viewModel?.getChargeResponse.value = cardRessponse
                    }else{
                        viewModel!.hasServerErrror.value = cardRessponse.debugMessage
                    }
                    
                    
                } catch {
                    print("error")
                    viewModel!.hasServerErrror.value = Variables.status.connectionError
                }
            }else {
                print("Turn On Internet Connections")
                viewModel!.hasServerErrror.value = Variables.status.connectionError
            }
            
        })
        task.resume()
        }
    
}



//        "expiryMonth": "03",
//        "expiryYear": "26",
//        "securityCode": "431",
//        "cardNumber": "5369020002180331"
       
        
    

