

import Foundation

struct Variables {
    
    struct status {
        static let failedMessage: String = "We’re sorry but we could not process this transaction at the moment"
        static let failedTransaction: String = "Failed Transaction"
        static let id: String = "id"
        static let insufficientFunds: String =  "Insufficient Funds"
        static let insufficientmessage: String = "Boss, he be like say money no too dey your account. You no go like top up?"
        static let invalidAccunt: String = "Invalid Account Number"
        static let invalidAccuntMessage: String = "The account number for this transaction is not valid, kindly try again"
        static let successfulTransaction = "Payment Successful "
        static let successfulTransactionDescription = "This transaction has been processed. Your reference number is "
        static let awaitingConfirm: String = "Awaiting Confirmation"
        static let awaitingMessage = "We’re waiting for confirmation from your bank. Kindly bear with us."
        static let test = "Test"
        static let live = "Live"
        static let connectionError = "Check your Internet connections and try again"
        
    }
    
    struct Colors {
        static let greenColor : String = "#398352"
        static let redColor : String = "#AF202D"
        static let orangeColor : String = "#FFA500"
        static let blueColor: String = "#2357D1"
        static let white: String = "#FFFFFF"
        static let fontBlue: String = "#0E2354"
    }
    
    struct Constants {
        static let naira: String = "₦"
        static let cardHintFirstPart: String = "To continue with your payment of "
        static let cardHintSecondPart = " kindly enter your card details below"
    }
    
    struct ConnectionMethod {
        static let get: String = "GET"
        static let post: String = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
    }
    
    struct BaseURLs {
        static let socketURL : String = "https://socket-dev.payaza.africa/"
        static let socketLiveURL : String = "https://socket.payaza.africa/"
        static let cardURl : String =  "https://cards-live.78financials.com/card_charge/"
        static let chargeCardUrl: String = "https://cards-live.78financials.com/card_charge/"
    }
    
    struct ActionKeys {
        static let testFundKey : String = "UFo3OC1QS0xJVkUtRjMwODcwNUMtRkY2NC00MEJCLTg1OUUtM0ZCQUI4MTJBNzdC"
        static let testCardKey : String = "PZ78-PKLIVE-BCCEB00C-87A4-4F2A-A25B-439315F2EF91"
        static let encodedTestKey: String = "UFo3OC1QS0xJVkUtQkNDRUIwMEMtODdBNC00RjJBLUEyNUItNDM5MzE1RjJFRjkx"
        
    }
    
    struct ErrorMessage {
        static let invalidCardNum : String = "Enter a valid card number"
        static let invalidCardDate : String = "Enter a valid card date"
        static let invalidCardCvv: String = "Enter a valid card cvv"
    }
}


