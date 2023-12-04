# PayazaPod

PayAza ios Sdk aids in processing payment through the following channels: Cards,  Virtual Transfer

[![CI Status](https://img.shields.io/travis/Xy-joe/PayazaPod.svg?style=flat)](https://travis-ci.org/Xy-joe/PayazaPod)
[![Version](https://img.shields.io/cocoapods/v/PayazaPod.svg?style=flat)](https://cocoapods.org/pods/PayazaPod)
[![License](https://img.shields.io/cocoapods/l/PayazaPod.svg?style=flat)](https://cocoapods.org/pods/PayazaPod)
[![Platform](https://img.shields.io/cocoapods/p/PayazaPod.svg?style=flat)](https://cocoapods.org/pods/PayazaPod)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PayazaPod is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/78-Financials/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'PayazaPod'
```

In your terminal, run 

```ruby
pod update && pod install
```

## Usage 
There are three steps you would have to complete to set up the SDK and perform transaction

- Install the SDK as a dependency
- Configure the SDK with Merchant Information
- Initiate payment with customer details

```ruby
import PayazaPod
 
class ViewController: UIViewController, PayazaCallbackMethods {
 
private var transactionAmount: Int64?
 
 
 
@objc func showExample(){
   let baseUrl = "https://your-base-url"
   let manager = PayazaManager()
   transactionAmount = 100
   manager.initialize(delegateController: self, viewControler: self)
   manager.PayAzaConfig(merchantKey: "Your Merchant Key Here", firstname: "Firstname", lastname: "Lastname", email: "emailAdreess", phone: "Phone",        transactionRef: "transactionReference", amount: transactionAmount!, isLive: true, baseUrl: baseUrl) // Set isLive to false during testing and set to true during production
   manager.payNow()
}

  func onPaymentComplete(response: TransactionResponse) {
        print("Successful with \(response.reference ?? "Failed to return data")")
  }
 
 func onPaymentCancelled(errorMessage: String) {
    print( errorMessage)
 }

}
```
## Author

Xy-joe, josephookoedo@gmail.com

## License

PayazaPod is available under the MIT license. See the LICENSE file for more info.
