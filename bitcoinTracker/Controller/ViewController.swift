//
//  ViewController.swift
//  bitcoinTracker
//
//  Created by Iva Cicarevic on 4/4/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                        let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.priceLabel.text = "Connection Issues"
                    }
                }
            }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
    
        if let bitcoinResult = json["ask"].double {
            priceLabel.text = currencySelected + String(bitcoinResult)
            }
            else {
                priceLabel.text = "Price unavailable"
            }
        }
}




//pickerView
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
        currencySelected = symbolArray[row]
        getBitcoinData(url: finalURL)
    }
}

