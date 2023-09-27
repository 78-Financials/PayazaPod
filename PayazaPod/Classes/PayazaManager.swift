

import UIKit


public protocol PayazaCallbackMethods {
    func onPaymentComplete(response: TransactionResponse)
    
   func onPaymentCancelled(errorMessage: String)

}


public class PayazaManager  {
    
    private var userMerchantKey: String?
    private var merchantInfo: UserInfo?
    private var transactionAmount: Double?
    private var viewModelCalss = ViewModelClass()
    private var transactionResponse : TransactionResponse?
    private var errorMessage: String?
    private var externalListener = ViewModelClass()
    private var vc: UIViewController?
    private var connectionMode : String?
    private var baseUrl : String?
    private var merchantName: String? = "Test Merchant"
    private var currency: String?

    
    public init () {
       
    }
    
    public func PayAzaConfig(merchantKey : String, merchantName: String, currency: String ,firstname: String, lastname: String, email: String, phone: String, transactionRef: String, amount: Double, isLive: Bool, baseUrl: String){
        let userInfo = UserInfo(first_name: firstname, last_name: lastname, email_address: email, phone_number: phone, transactionRef: transactionRef)
          userMerchantKey = merchantKey
          merchantInfo = userInfo
        transactionAmount =  amount
        self.merchantName = merchantName
        self.currency = currency.uppercased()
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
            mainVC.merchantNameString = self.merchantName
            mainVC.currency = currency
            self.vc?.overrideUserInterfaceStyle = .light
            self.vc?.present(mainVC, animated: true, completion: nil)
        }
    
    
}

