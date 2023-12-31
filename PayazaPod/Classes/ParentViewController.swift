//
//  ParentViewController.swift
//  PayazaPod
//
//  Created by Xy-joe on 9/21/23.
//

import UIKit
import DropDown
import SocketIO
import WebKit

class ParentViewController: UIViewController, WKNavigationDelegate{
    
    
    @IBOutlet weak var securedText: UILabel!
    
    @IBOutlet weak var merchantName: UILabel!
    
    @IBOutlet weak var closeView: UIView!
    
    
    @IBOutlet weak var transferBtn: UIButton!
    
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var closePopUp: UIImageView!
    
    @IBOutlet weak var greyView: UIView!
    
    @IBOutlet weak var cardBtn: UIButton!
    
    
    @IBOutlet weak var transferView: UIView!
    
    @IBOutlet weak var colouredTransfetView: UIView!
    
    @IBOutlet weak var awaitingview: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tansferFee: UILabel!
    
    @IBOutlet weak var trasferAmount: UILabel!
    
    @IBOutlet weak var transferAccount: UILabel!
    @IBOutlet weak var transferbank: UILabel!
    
    @IBOutlet weak var transferCountDown: UILabel!
    
    @IBOutlet weak var copyIcon: UIImageView!
    
    // Awaiting View Components
    
    @IBOutlet weak var awaitInner: UIView!
    @IBOutlet weak var awaitTimer: UILabel!
    
    @IBOutlet weak var awaitIcon: UIImageView!
    
    @IBOutlet weak var awaitViewDescrib: UILabel!
    
    @IBOutlet weak var awaitTitle: UILabel!
    @IBOutlet weak var confirmationButton: UIButton!
    
    @IBOutlet weak var awaitButton: UIButton!
    
    // Babk View Components
    
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var bankView: UIView!
    
    @IBOutlet weak var bankCost: UILabel!
    
    @IBOutlet weak var accountNumberView: UIView!
    @IBOutlet weak var bankSelectView: UIView!
    
    //  @IBOutlet weak var cardInfoView: UIView!
    
    @IBOutlet weak var verifyButon: UIButton!
    
    @IBOutlet weak var cancelPayment: UILabel!
    
    @IBOutlet weak var accountNumberField: UITextField!
    
    // Card View Components
    @IBOutlet weak var mainCardView: UIView!
    
    @IBOutlet weak var cardAmount: UILabel!
    
    @IBOutlet weak var cardNumBg: UIView!
    
    
    @IBOutlet weak var dateBg: UIView!
    @IBOutlet weak var cardNum: UITextField!
    
    @IBOutlet weak var cardDate: UITextField!
    
    @IBOutlet weak var cvvView: UIView!
    
    @IBOutlet weak var cvvText: UITextField!
    
    
    @IBOutlet weak var cardProceedBtn: UIButton!
    
    
    @IBOutlet weak var cardTypeIcon: UIImageView!
    
    
    // Developer section
    
    @IBOutlet weak var developerView: UIView!
    
    
    @IBOutlet weak var successOption: UIView!
    
    @IBOutlet weak var successRing: UIImageView!
    
    @IBOutlet weak var failedOption: UIView!
    
    @IBOutlet weak var failedRing: UIImageView!
    
    //   Test mode components
    
    @IBOutlet weak var testModeLine: UIView!
    
    @IBOutlet weak var lblView: UIView!
    @IBOutlet weak var testModeLbl: UILabel!
    //    @IBOutlet weak var cardCvv: UITextField!
    
    
    @IBOutlet weak var loader: UIView!
    
    private var count : Int = 1800
    
    let controllers = Controllers()
    let bankDropdown = DropDown()
    var bankPosition: Int = 0
    var socket:SocketIOClient!
    let bankList = ["Select Bank", "Access Bank", "Fidelity Bank", "FCMB Bank", "Keystone Bank", "Zenith Bank"]
    var forConfirmation : Bool? = false
    var forBankPayment : Bool = false
    
    private var myTimer : Timer?
    var userinfo: UserInfo?
    var accountResponse: AccountResponse?
    private var  payAzaService = PayAzaService()
    private let socketIoManager = SocketIOManager()
    private var finalResponse : TransactionResponse?
    var serverError : String?
    var userMerchantKey: String?
    var viewModel : ViewModelClass?
    var payAzaManager: PayazaManager?
    var connectionMode : String?
    private var currencySymbol : String?
    var amount: Double?
    var baseUrl : String?
    var currency : String?
    var merchantNameString: String?
    private var deviceInfo : DeviceInfo?
    private var currentBackgroundDate : TimeInterval?
    private var isSuccss : Bool = true
    private var isCounting : Bool = false
    private var cardBody : CardBody?
    private var chargeCardResponse : ChargeCardResponse?
    private var paymentInProgress: Bool = false
    private var callbackUrl: String? = "https://payaza.africa/"
    var transactionDescription: String? = "Test transaction"
    private var backUpUserdetails : UserInfo?
    private var transactionReference: String?
    private var hasFinishedCalling : Bool?
    private var errorResponse: String?
    private var forCard: Bool = true
    let configuration = WKWebViewConfiguration()
    private var isAppActive : Bool? = false
    private var isFirstTime : Bool = true
    private var isCheckingForRespone : Bool = false
    private var myWebview: WKWebView?
    private var isLoading: Bool = false
    private var card: CardBody?
    private var checkTransactionResponse: CheckTransactionResponse?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        loader.isHidden = false
        copyIcon.isUserInteractionEnabled = true
        let copyTap = UITapGestureRecognizer(target: self, action: #selector(copyAction))
        copyIcon.addGestureRecognizer(copyTap)
        
        successOption.isUserInteractionEnabled = true
        let successClick = UITapGestureRecognizer(target: self, action: #selector(successCard))
        successOption.addGestureRecognizer(successClick)
        
        failedOption.isUserInteractionEnabled = true
        let failedClick = UITapGestureRecognizer(target: self, action: #selector(failCard))
        failedOption.addGestureRecognizer(failedClick)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseApp), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startApp), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        mainCardView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mainCardView.addGestureRecognizer(tap)
        
        securedText.textColor = controllers.hexStringToUIColor(hex: "#9AA1B1")
        transferBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.grey)
        cardBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.blueColor)
        cardBtn.setTitleColor(controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
        cardBtn.setTitleColor(controllers.hexStringToUIColor(hex: Variables.Colors.fontBlue), for: .selected)
        transferBtn.setTitleColor(controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
        
        
        cardNum.delegate = self
        cardDate.delegate = self
        self.cardProceedBtn.alpha = 0.5
        cardProceedBtn.isUserInteractionEnabled = false
        cvvText.delegate = self
        
        
        let str = "Payaza"
        let labelFont = UIFont(name: "HelveticaNeue-Medium", size: 12)
        let attrs : Dictionary = [NSAttributedString.Key.foregroundColor : controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), NSAttributedString.Key.font : labelFont]
        let attributedStr = NSMutableAttributedString(string:str, attributes:attrs as [NSAttributedString.Key : Any])
        let firs = "Secured by "
        let firNormalString = NSMutableAttributedString(string:firs)
        firNormalString.append(attributedStr)
        securedText.attributedText =  firNormalString
        
        
        let billedTo = "Billed to: "
        let billedToString = NSMutableAttributedString(string:billedTo)
        let userNameText = userinfo!.first_name! + " " + userinfo!.last_name!
        let userNameFont = UIFont(name: "HelveticaNeue-Bold", size: 12)
        let userNameattrs : Dictionary = [NSAttributedString.Key.foregroundColor : controllers.hexStringToUIColor(hex: "#000000"), NSAttributedString.Key.font : userNameFont]
        let userNameattributedStr = NSMutableAttributedString(string:userNameText, attributes:userNameattrs as [NSAttributedString.Key : Any])
        billedToString.append(userNameattributedStr)
        userName.attributedText = billedToString
        userEmail.text = userinfo?.email_address
        backUpUserdetails = userinfo
        merchantName.text = merchantNameString
        
        
        controllers.setUpViewBorderAndColor(theView: cardNumBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
        controllers.setUpViewBorderAndColor(theView: dateBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
        controllers.setUpViewBorderAndColor(theView: cvvView, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
        
        
        self.initialiseAllViewModels()
        
        if connectionMode == Variables.status.test {
            nameStack.isHidden = false
            //closeView.isHidden = true
        }else{
            //  nameStack.isHidden = true
            
        }
        
        // Fetch device Info
        deviceInfo = controllers.getDeviceInfo(viewController: self)
        launchPayAza()
        
    }
    
    
    
    @objc func handleTap(){
        if  cardNum.isFirstResponder {
            self.cardNum?.resignFirstResponder()
        }
        
        if  cardDate.isFirstResponder {
            self.cardDate?.resignFirstResponder()
        }
        
        if  cvvText.isFirstResponder {
            self.cvvText?.resignFirstResponder()
        }
    }
    
    
    private func initialiseAllViewModels(){
        viewModel!.hasServerError.observe{(value) in
            if value != nil {
                self.openPayment(errorString: value)
                self.isCheckingForRespone = false
            }
        }
        
        viewModel?.fetchAccountResponse.observe{(value) in
            if value != nil {
                self.accountResponse = value
                self.openPayment(errorString:  nil)
            }
        }
        
        viewModel?.fetchCustomerInfo.observe{(value) in
            if value != nil {
                self.userinfo = value
            }
        }
        
        viewModel?.paymentVerifiedByPayAza.observe{(response) in
            if response != nil {
                self.socketIoManager.hasGottenResponse = true
                self.isCheckingForRespone = false
                self.finalResponse = response
                self.showSucess()
            }
        }
        
        viewModel?.getChargeResponse.observe{(response) in
            if response != nil {
                self.chargeCardResponse = response
                if self.chargeCardResponse!.do3dsAuth! {
                    self.paymentInProgress = true
                    self.configureWeb(htmlLink: self.chargeCardResponse!.threeDsHtml!, baseUrl: response!.threeDsUrl!)
                }else{
                    self.hasFinishedCalling = true
                    self.showSucess()
                }
            }
        }
        
        
        viewModel?.checkTransactionResponse.observe{(data) in
            if data != nil {
                self.checkTransactionResponse = data!
                self.showSucess()
            }
        }
        
        
    }
    
    func configureWeb(htmlLink : String, baseUrl: String) {
        DispatchQueue.main.async {
            
            let config = WKWebViewConfiguration()
            let userContentController = WKUserContentController()
            
            
            let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(script)
            
            
            config.userContentController = userContentController
            self.myWebview = WKWebView(frame: self.mainView.bounds, configuration: config)
            self.myWebview!.navigationDelegate = self
            self.myWebview!.scrollView.isMultipleTouchEnabled = false
            self.mainView.addSubview(self.myWebview!)
            self.myWebview!.loadHTMLString(htmlLink, baseURL: nil)
            self.myWebview!.allowsBackForwardNavigationGestures = true
            
            
        }
    }
    
    
    func webView( _ webView: WKWebView,didFail navigation: WKNavigation!,withError error:Error){
        self.viewModel?.hasServerError.value = Variables.status.connectionError
        print(error)
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString{
            if urlStr.contains("https://payaza.africa/"){
                self.hasFinishedCalling = true
                self.myWebview?.isHidden = true
                isLoading = false
                self.payAzaService.verifyTransaction(transactonRef: self.transactionReference!)
                
                
            }
            
        }
        decisionHandler(.allow)
        
    }
    
    
    private func launchPayAza() {
        payAzaService.baseUrl = self.baseUrl
        payAzaService.viewModel = self.viewModel
        payAzaService.userInfo = userinfo
        payAzaService.transactionAmount = amount
        payAzaService.merchantKey = userMerchantKey
        payAzaService.connectionMode = connectionMode
        payAzaService.socketIoManager = socketIoManager
        cardOption()
        self.loader.isHidden = true
    }
    
    
    func openPayment(errorString: String?) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            if errorString != nil {
                self.serverError = errorString
                self.transferView.isHidden = true
                self.awaitingview.isHidden = false
                self.mainCardView.isHidden = true
                self.showFaiilure()
            }else {
                self.configureViews()
            }
            
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if animated {
            isAppActive = false
        }
        if serverError != nil {
            viewModel?.serverError.value = serverError
        }else{
            if checkTransactionResponse != nil {
                let tResponse = TransactionResponse(message: checkTransactionResponse?.debug_message, status: checkTransactionResponse?.transaction_status, reference: checkTransactionResponse?.transaction_reference, time: checkTransactionResponse?.created_at)
                viewModel?.paymentComplete.value = tResponse
            }else{
                if finalResponse != nil {
                    viewModel?.paymentComplete.value = finalResponse
                }
            }
            
        }
        
    }
    
    private func configureViews(){
        transferbank.text = accountResponse!.bank_name!
        transferAccount.text = accountResponse!.account_number!
        let feeText = "(FEES : ₦" + accountResponse!.transaction_fee_amount! + ")"
        developerView.layer.borderWidth = 1
        developerView.layer.borderColor = controllers.hexStringToUIColor(hex: "#F5F5F5").cgColor
        tansferFee.text = feeText
        let amountText = "Transfer ₦" + accountResponse!.transaction_payable_amount!
        trasferAmount.text = amountText
        transferCountDown.text = controllers.timeString(time:  TimeInterval(4200))
        transferView.isUserInteractionEnabled = true
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        transferView.addGestureRecognizer(tap0)
        
        view.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        lblView.backgroundColor = controllers.hexStringToUIColor(hex: Variables.Colors.orangeColor)
        testModeLine.backgroundColor = controllers.hexStringToUIColor(hex: Variables.Colors.orangeColor)
        //            testModeLbl.center = CGPoint(x: self.testModeLbl.frame.size.width / 2.0, y:self.testModeLbl.frame.size.height / 2.0)
        if connectionMode == Variables.status.test {
            testModeLine.isHidden = false
            lblView.isHidden = false
            colouredTransfetView.backgroundColor = controllers.hexStringToUIColor(hex: "#FFFFFF")
            confirmationButton.layer.borderWidth = 0.5
            confirmationButton.layer.borderColor = UIColor.lightGray.cgColor
            confirmationButton.backgroundColor = controllers.hexStringToUIColor(hex: "#FFFFFF")
            confirmationButton.setTitleColor(controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
            
        }else{
            testModeLine.isHidden = true
            lblView.isHidden = true
            colouredTransfetView.backgroundColor = controllers.hexStringToUIColor(hex: "#DDF9FF")
            confirmationButton.layer.borderWidth = 0
            confirmationButton.layer.borderColor = controllers.hexStringToUIColor(hex: "#2357D1").cgColor
            confirmationButton.backgroundColor = controllers.hexStringToUIColor(hex: "#2357D1")
            confirmationButton.setTitleColor(controllers.hexStringToUIColor(hex: Variables.Colors.white), for: .normal)
        }
        
        
        awaitButton.layer.borderWidth = 0.5
        awaitButton.layer.borderColor = UIColor.lightGray.cgColor
        awaitButton.layer.cornerRadius = 4
        confirmationButton.layer.cornerRadius = 4
        greyView.backgroundColor = controllers.hexStringToUIColor(hex: "#F5F5F5")
        view.addGestureRecognizer(tap2)
        socketIoManager.viewModel = viewModel
        startCountdown()
        showtransferView()
        handleTap()
        
        
        
        
    }
    
    
    @objc func successCard(){
        successRing.image = UIImage(systemName: "circle.inset.filled")
        failedRing.image = UIImage(systemName: "circle.circle")
        failedRing.tintColor = controllers.hexStringToUIColor(hex: "#676E7E")
        successRing.tintColor = controllers.hexStringToUIColor(hex: "#2357D1")
        isSuccss = true
    }
    
    
    @objc func failCard(){
        failedRing.image = UIImage(systemName: "circle.inset.filled")
        successRing.image = UIImage(systemName: "circle.circle")
        failedRing.tintColor = controllers.hexStringToUIColor(hex: "#2357D1")
        successRing.tintColor = controllers.hexStringToUIColor(hex: "#676E7E")
        isSuccss = false
    }
    
    
    @objc func quitPayAza() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func copyAction() {
        controllers.copyAction(viewContoller: self, stringToCopy: accountResponse!.account_number!)
    }
    
    
    func showtransferView() {
        if developerView.isHidden {
            if serverError == nil {
                if isCheckingForRespone { // An existing check exists for a transfer
                    showLoader(false)
                }else{ // No existing check exists for a transfer
                    bankView.isHidden = true
                    mainCardView.isHidden = true
                    transferView.isHidden = false
                    awaitingview.isHidden = true
                    mainView.isHidden = false
                    confirmationButton.isHidden = false
                    forBankPayment = false
                    
                    confirmationButton.setTitle("I've sent the money", for: .normal)
                }
                
            }else {
                awaitingview.isHidden = false
                mainCardView.isHidden = true
                bankView.isHidden = true
                transferView.isHidden = true
            }
        }
    }
    
    func transferOption(){
        forCard = false
        transferBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.blueColor)
        cardBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.grey)
        if !isCounting{ // No existing account number exists
            self.payAzaService.initialiseService(deviceInfo: deviceInfo!, isFirstime: isFirstTime)
            isFirstTime = false
            showLoader(true)
        }else{ // An existing account number is still visible
            showtransferView()
        }
        handleTap()
        
    }
    
    
    @IBAction func resultAction(_ sender: Any) {
        awaitingview.isHidden = true
        
        if !forCard{
            quitPayAza()
        } else {
            quitPayAza()
        }
        
    }
    
    @IBAction func transferSelected(_ sender: Any) {
        if currency! == "NGN"{
            transferOption()
        }else {
            self.showToast(message: "Not available for the currency used", font: .systemFont(ofSize: 13))
        }
        
        currencySymbol = viewModel?.getCurrencyIcon(currency: currency!)
        
    }
    
    
    
    func cardOption() {
        currencySymbol = viewModel?.getCurrencyIcon(currency: currency!)
        forCard = true
        transferBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.grey)
        cardBtn.tintColor = controllers.hexStringToUIColor(hex: Variables.Colors.blueColor)
        if developerView.isHidden {
            bankView.isHidden = true
            transferView.isHidden = true
            awaitingview.isHidden = true
            mainCardView.isHidden = false
            mainView.isHidden = false
            
            
            let str = currencySymbol! + String(format:"%.2f", amount!)
            let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 14)
            let attrs : Dictionary = [NSAttributedString.Key.foregroundColor : controllers.hexStringToUIColor(hex: Variables.Colors.fontBlue), NSAttributedString.Key.font : labelFont]
            let attributedStr = NSMutableAttributedString(string:str, attributes:attrs as [NSAttributedString.Key : Any])
            let firNormalString = NSMutableAttributedString(string:Variables.Constants.cardHintFirstPart)
            let namePart = NSMutableAttributedString(string:" to \(merchantNameString!),")
            let secNormalString = NSMutableAttributedString(string:Variables.Constants.cardHintSecondPart)
            firNormalString.append(attributedStr)
            firNormalString.append(namePart)
            firNormalString.append(secNormalString)
            cardAmount.attributedText =  firNormalString
            
            accountNumberView.layer.borderWidth = 1
            accountNumberView.layer.borderColor = controllers.hexStringToUIColor(hex: "#676E7E").cgColor
            
            confirmationButton.isHidden = true
            forBankPayment = true
            createDropDowns()
        }
        
    }
    
    
    
    func showSucess(){
        let mainBundle = Bundle(for: ParentViewController.self)
        let origImage = UIImage(named: "checked", in: mainBundle, compatibleWith: nil)
        DispatchQueue.main.async {
            self.awaitIcon.image = origImage
            self.awaitTimer.isHidden = true
            let emptyImage = UIImage(named: "")
            self.awaitTitle.text = Variables.status.successfulTransaction
            self.awaitViewDescrib.text = Variables.status.successfulTransactionDescription
            self.awaitButton.setImage(emptyImage, for: .normal)
            self.forConfirmation = false
            self.awaitButton.isHidden = false
            self.awaitButton.layer.borderWidth = 0.5
            self.awaitButton.layer.borderColor = UIColor.lightGray.cgColor
            self.awaitButton.layer.cornerRadius = 4
            self.awaitButton.setTitle("Go back to " + self.merchantNameString! , for: .normal)
            self.awaitButton.setTitleColor(self.controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
            self.awaitTitle.textColor = self.controllers.hexStringToUIColor(hex: Variables.Colors.greenColor)
            self.awaitingview.isHidden = false
            self.transferView.isHidden = true
            self.myTimer?.invalidate()
        }
        
        
    }
    
    func showFaiilure(){
        let mainBundle = Bundle(for: ParentViewController.self)
        let origImage = UIImage(named: "cancel", in: mainBundle, compatibleWith: nil)
        DispatchQueue.main.async {
            if self.hasFinishedCalling != nil {
                if self.hasFinishedCalling! {
                    
                    self.awaitIcon.image = origImage
                    self.awaitTimer.isHidden = true
                    self.awaitTitle.text = Variables.status.failedTransaction
                    self.awaitingview.isHidden = false
                    self.transferView.isHidden = true
                    self.bankView.isHidden = true
                    self.mainCardView.isHidden = false
                    self.awaitButton.layer.borderWidth = 0.5
                    self.awaitButton.layer.borderColor = UIColor.lightGray.cgColor
                    self.awaitButton.layer.cornerRadius = 4
                    self.awaitButton.setTitle("Try again", for: .normal)
                    self.awaitButton.setTitleColor(self.controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
                    self.awaitTitle.textColor = self.controllers.hexStringToUIColor(hex: Variables.Colors.redColor)
                    self.awaitButton.isHidden = false
                    if self.chargeCardResponse != nil {
                        if self.serverError != nil {
                            self.awaitViewDescrib.text = self.serverError
                        }else {
                            self.awaitViewDescrib.text = self.chargeCardResponse?.debugMessage
                        }
                    }
                    
                }
            }else{
                self.awaitIcon.image = origImage
                self.awaitTimer.isHidden = true
                self.awaitingview.isHidden = false
                self.transferView.isHidden = true
                self.bankView.isHidden = true
                self.mainCardView.isHidden = false
                self.awaitButton.layer.borderWidth = 0.5
                self.awaitButton.layer.borderColor = UIColor.lightGray.cgColor
                self.awaitButton.layer.cornerRadius = 4
                self.awaitButton.setTitle("Try again", for: .normal)
                self.awaitButton.setTitleColor(self.controllers.hexStringToUIColor(hex: Variables.Colors.blueColor), for: .normal)
                self.awaitTitle.textColor = self.controllers.hexStringToUIColor(hex: Variables.Colors.redColor)
                self.awaitButton.isHidden = false
            }
            
            if self.chargeCardResponse == nil {
                if self.serverError != nil {
                    self.awaitViewDescrib.text = self.serverError
                }else {
                    self.awaitViewDescrib.text = Variables.status.failedMessage
                }
            }
            
        }
        self.forConfirmation = false
        self.myTimer?.invalidate()
    }
    
    
    // Await view, A this time, there is a network request
    func showLoader(_ isGeneratingAccount: Bool){
        let imageData = UIImage.gifImageWithName("card_loader")
        awaitIcon.image = imageData
        awaitIcon.isHidden = false
        awaitingview.isHidden = false
        transferView.isHidden = true
        bankView.isHidden = true
        awaitTimer.isHidden = true
        self.mainCardView.isHidden = true
        awaitTitle.textColor = controllers.hexStringToUIColor(hex: Variables.Colors.orangeColor)
        if isGeneratingAccount {
            awaitTitle.text = Variables.status.generatingAccount
            awaitViewDescrib.text = Variables.status.awaitingMessageforAccount
        }else {
            awaitTitle.text = Variables.status.awaitingConfirm
            if forCard {
                awaitViewDescrib.text = Variables.status.awaitCard
            }else{
                awaitViewDescrib.text = Variables.status.awaitingMessage
            }
            self.forConfirmation = true
        }
        
        // self.startCountdown()
    }
    
    // Await view, A this time, there is a network request
    
    
    
    @IBAction func cardSelected(_ sender: Any) {
        cardOption()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if awaitingview.isHidden {
            if connectionMode == Variables.status.test {
                developerView.isHidden = false
            }else{
                developerView.isHidden = true
                self.isCheckingForRespone  = true
                showLoader(false)
            }
            
            
        }
    }
    
    @IBAction func developerContinueAction(_ sender: Any) {
        developerView.isHidden = true
        if isSuccss == true {
            showSucess()
        }else{
            showFaiilure()
        }
    }
    
    
    func secondinitiaLizatio() {
        
    }
    
    func validAccountNumber(validNumber : String) -> Bool {
        return validNumber == "1234567890"
    }
    
    
    func startCountdown(){
        if forConfirmation == true {
            // count = 120
        }else{
            count = 1800
        }
        isCounting = true
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(myUpdate), userInfo: nil, repeats: true)
        
    }
    
    @objc func myUpdate() {
        if(count > 0) {
            count -= 1
            let hours = Int(count) / 3600
            let minutes = Int(count) / 60 % 60
            let seconds = Int(count) % 60
            let coloredText = String(format:"%02i:%02i:%02is,", hours, minutes, seconds)
            let attrs = [NSAttributedString.Key.foregroundColor : controllers.hexStringToUIColor(hex: Variables.Colors.blueColor)]
            let attributedString = NSMutableAttributedString(string:coloredText, attributes:attrs)
            if forConfirmation == true {
                awaitTimer.attributedText = attributedString
            }else{
                let firstHalf = "This account is going to expire in "
                let secondHalf = " make your payment before it expires"
                let firstNormalString = NSMutableAttributedString(string:firstHalf)
                let secondNormalString = NSMutableAttributedString(string:secondHalf)
                firstNormalString.append(attributedString)
                firstNormalString.append(secondNormalString)
                transferCountDown.attributedText =  firstNormalString
            }
            
            countdownReachedZero()
        }
    }
    
    @objc func pauseApp(){
        if isCounting == true {
            self.stop() //invalidate timer
            self.currentBackgroundDate = Date().timeIntervalSinceReferenceDate
        }
    }
    
    @objc func startApp(){
        if isCounting == true {
            handleDiff()
            self.start()
        }
        //start timer
    }
    
    func start(){
        if isCounting {
            if count > 0 {
                self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(myUpdate), userInfo: nil, repeats: true);
            }else {
                //  Time has elapsed
                isCounting = false
                if finalResponse == nil {
                    showFaiilure()
                }
            }
        }
        
        
    }
    
    
    func stop(){
        if (myTimer != nil){
            self.myTimer!.invalidate();
        }
        
    }
    
    func handleDiff () {
        if currentBackgroundDate != nil {
            let currDate = Date().timeIntervalSinceReferenceDate
            let diff = currDate - self.currentBackgroundDate!
            let second = diff as Double
            let seconds = Int(second)
            //             // Check against the normal countdown
            if seconds > 0 {
                count = count - seconds
            }
            //
        }
        
        
        
        
    }
    
    func countdownReachedZero(){
        if count == 1{
            myTimer!.invalidate()
            if forConfirmation == true {
                if self.forBankPayment == false {
                    if self.finalResponse != nil {
                        self.showSucess()
                    }else {
                        self.showFaiilure()
                    }
                }
            } else {
                if self.finalResponse != nil {
                    self.showSucess()
                }else {
                    self.showFaiilure()
                }
            }
        }
    }
    
    
    
    private func recreateNewAccount( ){
        showLoader(false)
    }
    
    
    
    @IBAction func verifybankAccount(_ sender: Any) {
        if accountNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            showToast(message: "Invalid Field", font: .systemFont(ofSize: 14))
            return
        }
        
        accountNumberField.resignFirstResponder()
        
        
    }
    
    
    func onDismiss() {
        isAppActive = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedWithCardPaymentOption(_ sender: Any) {
        if self.viewModel!.cardFormValidation(cardNum: cardNum, cardDate: cardDate, cardCVV: cvvText, controllers: controllers, vc: self) {
            let month = String(cardDate.text!.prefix(2))
            let year = String(cardDate.text!.suffix(2))
            
            showLoader(false)
            card = CardBody(expiryMonth: month, expiryYear: year, securityCode:  cvvText.text!, cardNumber: cardNum.text!)
            let transacRef =  String(deviceInfo!.deviceId!.prefix(5))+controllers.getCcurrentDate()
            self.transactionReference = transacRef
            let cardValues  = CardDynamicDataValues(currency: self.currency, callback_url: self.callbackUrl, transaction_reference: transacRef, transactionDescription: self.transactionDescription)
            
            payAzaService.chargeCard(card: card, cardValues: cardValues, user: backUpUserdetails!)
        }
        else{
            return
            
        }
        
    }
    
}



extension ParentViewController: UITextFieldDelegate {
    
    private func createDropDowns() {
        bankDropdown.anchorView = bankSelectView
        bankDropdown.dataSource = bankList
        
        bankDropdown.bottomOffset = CGPoint(x: 0, y:(bankDropdown.anchorView?.plainView.bounds.height)!)
        bankDropdown.topOffset = CGPoint(x: 0, y:-(bankDropdown.anchorView?.plainView.bounds.height)!)
        bankDropdown.direction = .bottom
        
        bankSelectView.isUserInteractionEnabled = true
        
        let bankTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBankDropdown))
        bankSelectView.addGestureRecognizer(bankTapGesture)
        
        // Action triggered on selection
        bankDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.bankPosition = index
            self.bankNameLabel.text = item
            self.bankNameLabel.textColor = .darkGray
            if item == self.bankList[0] {
                
                self.accountNumberView.isHidden = true
                self.accountNumberField.resignFirstResponder()
            } else {
                self.accountNumberView.isHidden = false
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountNumberField {
            self.accountNumberField?.resignFirstResponder()
        }
        if textField == cardNum {
            controllers.setUpViewBorderAndColor(theView: cardNumBg, theColor: .lightGray, borderWidth: 0.5)
            if cardNum.text != ""{
                self.controllers.getCardType(cardNumber: cardNum.text!, cardImageView: self.cardTypeIcon, vc: self)
            }else{
                self.controllers.setImage(imageName: "others", imaveView: self.cardTypeIcon)
            }
            
            
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cardNum {
            controllers.setUpViewBorderAndColor(theView: cardNumBg, theColor: controllers.hexStringToUIColor(hex: "#2357D1"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: dateBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: cvvView, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
        }
        if textField == cardDate{
            controllers.setUpViewBorderAndColor(theView: cardNumBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: dateBg, theColor: controllers.hexStringToUIColor(hex: "#2357D1"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: cvvView, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
            
        }
        if textField == cvvText {
            controllers.setUpViewBorderAndColor(theView: cardNumBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: dateBg, theColor: controllers.hexStringToUIColor(hex: "#E6E7EC"), borderWidth: 0.5)
            controllers.setUpViewBorderAndColor(theView: cvvView, theColor: controllers.hexStringToUIColor(hex: "#2357D1"), borderWidth: 0.5)
            
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == accountNumberField {
            self.controllers.getCardType(cardNumber: accountNumberField.text!, cardImageView: self.cardTypeIcon, vc: self)
            accountNumberField.resignFirstResponder()
            
        }
        if textField == cardNum {
            if cardNum.text?.count == 16 && cvvText.text?.count == 3 && cardDate.text?.count == 5 {
                cardProceedBtn.isUserInteractionEnabled = true
                cardProceedBtn.alpha = 1
            }else{
                cardProceedBtn.isUserInteractionEnabled = false
                cardProceedBtn.alpha = 0.4
            }
        }
        
        if textField == cardDate {
            if cardNum.text?.count == 16 && cvvText.text?.count == 3 && cardDate.text?.count == 5 {
                cardProceedBtn.isUserInteractionEnabled = true
                cardProceedBtn.alpha = 1
            }else{
                cardProceedBtn.isUserInteractionEnabled = false
                cardProceedBtn.alpha = 0.4
            }
        }
        if textField == cvvText {
            if cardNum.text?.count == 16 && cvvText.text?.count == 3 && cardDate.text?.count == 5 {
                cardProceedBtn.isUserInteractionEnabled = true
                cardProceedBtn.alpha = 1
            }else{
                cardProceedBtn.isUserInteractionEnabled = false
                cardProceedBtn.alpha = 0.4
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNum {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            //            if updatedText == ""{
            //                controllers.setImage(imageName: "", imaveView: self.cardTypeIcon)
            //            }
            if updatedText.count == 16 {
                self.controllers.getCardType(cardNumber: updatedText, cardImageView: self.cardTypeIcon, vc: self)
                if  cvvText.text?.count == 3 && cardDate.text?.count == 5 {
                    cardProceedBtn.isUserInteractionEnabled = true
                    cardProceedBtn.alpha = 1
                }else{
                    cardProceedBtn.isUserInteractionEnabled = false
                    cardProceedBtn.alpha = 0.4
                }
            }else{
                controllers.setImage(imageName: "", imaveView: self.cardTypeIcon)
            }
            // make sure the result is under 16 characters
            return updatedText.count <= 16
        }
        
        if textField == cardDate {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            
            
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count == 3 {
                if !cardDate.text!.contains("/"){
                    cardDate.text = cardDate.text?.appending("/")
                }
            }
            
            if updatedText.count == 5 {
                if cardNum.text?.count == 16 && cvvText.text?.count == 3 {
                    cardProceedBtn.isUserInteractionEnabled = true
                    cardProceedBtn.alpha = 1
                }else{
                    cardProceedBtn.isUserInteractionEnabled = false
                    cardProceedBtn.alpha = 0.4
                }
            }
            
            
            // make sure the result is under 16 characters
            return updatedText.count <= 5
        }
        
        if textField == cvvText {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count == 3 {
                if cardNum.text?.count == 16 && cardDate.text?.count == 5 {
                    cardProceedBtn.isUserInteractionEnabled = true
                    cardProceedBtn.alpha = 1
                }else{
                    cardProceedBtn.isUserInteractionEnabled = false
                    cardProceedBtn.alpha = 0.4
                }
            }
            // make sure the result is under 16 characters
            return updatedText.count <= 3
        }
        
        return false
    }
    
    
    @objc private func didTapBankDropdown() {
        self.bankDropdown.show()
    }
    
}
