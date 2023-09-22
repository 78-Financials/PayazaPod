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
                self.paymentViewModel.hasServerErrror.observe{(data ) in
                    if data != nil {
                        delegateController.onPaymentFailed(errorMessage: data!)
                    }
                }
                
                self.paymentViewModel.threeDSResponse.observe{(data) in
                    if data != nil {
                        if data! {
                            delegateController.onPaymentComplete(response: true)
                        }
                        
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
       
       if let httpResponse = navigationResponse.response as? HTTPURLResponse {
           
           let statusCode = httpResponse.statusCode
           
           if let urlResponse = navigationResponse.response as? URLResponse {
               URLSession.shared.dataTask(with: urlResponse.url!) { (data, response, error) in
                   if let data = data {
                       // You can convert the data to a string, assuming it's in text format (e.g., JSON)
                       if self.hasFinishedCalling != nil {
                           if let responseBody = String(data: data, encoding: .utf8) {
                               if  responseBody != "" {
                                
                                   if let jsonData = responseBody.data(using: .utf8) {
                                       do {
                                           if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                               if let status = jsonArray["status"] as? Int {
                                                   if status != 200 {
                                                       self.paymentViewModel.threeDSResponse.value = false
                                                       if let error = jsonArray["error"] as? String {
                                                           self.paymentViewModel.hasServerErrror.value = error
                                                          
                                                       }
                                                       
                                                   }else{
                                                       self.paymentViewModel.threeDSResponse.value = true
                                                       
                                                   }
                                                 
                                                   
                                               }
                                               
                                           } } catch {
                                                       print("Error parsing JSON: \(error.localizedDescription)") } } }
                                               
                                        
                               
                           }
                       }
                      
                   }
               }.resume()
           }
       }
           
       
       
      decisionHandler(.allow)
   }
    

 
    
   
   
    func webView( _ webView: WKWebView,didFail navigation: WKNavigation!,withError error:Error){
        self.paymentViewModel.hasServerErrror.value = Variables.status.connectionError
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
