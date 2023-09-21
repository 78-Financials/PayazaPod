

import UIKit




class ViewController: UIViewController {

    private let merchantKey = "PZ78-PKTEST-888C15B0-5015-4421-BB61-654B89902CAC"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func launchPayAza(_ sender: Any) {
        let bundle = Bundle(for: TestViewController.self)
        let testVC = TestViewController(nibName: "TestViewController", bundle: bundle)
        self.navigationController?.pushViewController(testVC, animated: true)
        
    }
    
}
