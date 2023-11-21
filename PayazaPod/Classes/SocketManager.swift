

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket:SocketIOClient!
    let manager = SocketManager(socketURL: URL(string: Variables.BaseURLs.socketLiveURL)!, config: [.log(true), .compress,])
    var hasCreated: Bool = false
    var viewModel: ViewModelClass?
    var hasGottenResponse: Bool = false

    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishNewConnection(transactionRef: String) {
        let socketPath = "/" + transactionRef
        socket = manager.socket(forNamespace: socketPath)
        socket.on("message") { response, ack in
            let responseContent = response[0] as! Dictionary<String, AnyObject>
            let transactinnRef = responseContent["reference"] as? String
            if transactinnRef != nil && !self.hasGottenResponse { // is the ersponse for final call
                   let socketResponse = TransactionResponse(responses: responseContent as NSDictionary)
                print(socketResponse)
                if self.viewModel != nil {
                    self.viewModel!.paymentVerifiedByPayAza.value = socketResponse
                    self.closeConnection()
                }
                else {
                    print("Viewmodel needs to be initialised")
                }
                
            }
         
        }
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }
    
    
    



}

