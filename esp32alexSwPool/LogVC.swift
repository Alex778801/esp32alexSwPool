//
//  LogVC.swift
//  esp32alexSwPool
//
//  Created by Alexey Sorokin on 25.10.2024.
//

import UIKit

var log = ""

func logger(_ type: String!, _ msg: String!) {
    let dt = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
    let dtf = formatter.string(from: dt)
    log = log + "⚡ --- \(dtf) ---\n! \(type!)\n\(msg!)\n\n"
}

class LogVC: UIViewController {
    
    @IBAction func copyBtn(_ sender: Any) {
        UIPasteboard.general.string = log
    }
    
    @IBOutlet var logTV: UITextView!
    
    @IBAction func refreshBtn(_ sender: Any) {
        logTV.text = log
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logTV.text = log
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
