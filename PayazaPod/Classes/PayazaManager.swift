

import UIKit

 protocol PayAzaCallback {
    func onPaymentComplete() -> TransactionResponse?
    func onPaymentFailed() -> String?
}



public protocol PayazaCallbackMethods {
    func onPaymentComplete(response: TransactionResponse)
    
   func onPaymentCancelled(errorMessage: String)

}


public protocol AudioManagerProtocol {
    var callBacks: PayazaCallbackMethods { get }
    
    
}


public class PayazaManager : PayAzaCallback {
   
     func onPaymentComplete() -> TransactionResponse? {
        return transactionResponse
    }
    
    func onPaymentFailed() -> String? {
        return errorMessage
    }
    
    private var userMerchantKey: String?
    private var merchantInfo: UserInfo?
    private var transactionAmount: Int64?
    private var viewModelCalss = ViewModelClass()
    private var transactionResponse : TransactionResponse?
    private var errorMessage: String?
     var externalListener = ViewModelClass()
    private var vc: UIViewController?
    private var connectionMode : String?
    private var baseUrl : String?

    
    public init () {
       
    }
    
    public func PayAzaConfig(merchantKey : String, firstname: String, lastname: String, email: String, phone: String, transactionRef: String, amount: Int64, isLive: Bool, baseUrl: String){
        let userInfo = UserInfo(first_name: firstname, last_name: lastname, email_address: email, phone_number: phone, transactionRef: transactionRef)
          userMerchantKey = merchantKey
          merchantInfo = userInfo
        transactionAmount =  amount
        self.baseUrl = baseUrl
        if isLive == true{
            connectionMode = Variables.status.live
        }else {
            connectionMode = Variables.status.test
        }
    }
        
    
    public func initialize(delegateController :PayazaCallbackMethods, viewControler: UIViewController){
        self.vc = viewControler
        viewModelCalss.paymentComplete.observe{(response) in
            if response != nil {
                self.transactionResponse = response
                delegateController.onPaymentComplete(response: self.transactionResponse!)
            }
        }
        
        viewModelCalss.serverError.observe{(response) in
            if response != nil {
                self.errorMessage = response
                delegateController.onPaymentCancelled(errorMessage: self.errorMessage!)
            }
        }
    }
   
        public func payNow () {
            let bundle = Bundle(for: ParentViewController.self)
            let mainVC = ParentViewController(nibName: "ParentViewController", bundle: bundle)
            mainVC.userMerchantKey = userMerchantKey
            mainVC.userinfo = merchantInfo
            mainVC.viewModel = viewModelCalss
            mainVC.payAzaManager = self
            mainVC.amount = transactionAmount
            mainVC.connectionMode = connectionMode
            mainVC.baseUrl = baseUrl
            self.vc?.overrideUserInterfaceStyle = .light
            self.vc?.present(mainVC, animated: true, completion: nil)
        }
    
    
}

