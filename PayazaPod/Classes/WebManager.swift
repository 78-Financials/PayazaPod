//
//  WebManager.swift
//  PayAzaSDK
//
//  Created by Xy-joe on 9/19/23.
//

import Foundation
import WebKit


public protocol WebviewCallbackMethods {
    func onPaymentComplete(response: Bool)
    
   func onPaymentFailed(errorMessage: String)

}



class WebManager: NSObject, WKNavigationDelegate {
    
    private var transactionResponse : TransactionResponse?
    private var hasFinishedCalling: Bool?
    private var paymentViewModel = ViewModelClass()
    private var myWebview: WKWebView?
    private var isLoading: Bool = false
    
    
    public override init () {
       
    }
    
    
    func configureWeb(htmlLink : String, baseUrl: String, mainView: UIView, delegateController: WebviewCallbackMethods) {
        if !isLoading {
            isLoading = true
            DispatchQueue.main.async {
                let configuration = WKWebViewConfiguration()
                self.myWebview = WKWebView(frame: mainView.bounds, configuration: configuration)
                mainView.addSubview(self.myWebview!)
                let urll:URL? = URL(string: "http://www.apple.com")
                self.myWebview!.navigationDelegate = self
                let url = NSURL(string: baseUrl)! as URL
              //  self.myWebview!.loadHTMLString(htmlLink, baseURL: url)
                let request:URLRequest = URLRequest(url: urll!)
                self.myWebview!.load(request)
                self.myWebview!.allowsBackForwardNavigationGestures = true
                self.paymentViewModel.hasServerError.observe{(data ) in
                    if data != nil {
                        delegateController.onPaymentFailed(errorMessage: data!)
                    }
                }
                
            }
        }
            
        
        
        
    }
    
    
    
    
    func webView(
       _ webView: WKWebView,
       decidePolicyFor navigationResponse: WKNavigationResponse,
       decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
   ){
    
       
      decisionHandler(.allow)
   }
    

 
    
   
   
    func webView( _ webView: WKWebView,didFail navigation: WKNavigation!,withError error:Error){
        self.paymentViewModel.hasServerError.value = Variables.status.connectionError
       print(error)
   }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString{
           if urlStr.contains("https://webhook.site/ed6dd427-dfcf-44a3-8fa7-4cc1ab55e029"){
               self.hasFinishedCalling = true
               self.myWebview?.isHidden = true
               isLoading = false
            }
                        
       }
        decisionHandler(.allow)
        
    }
}
