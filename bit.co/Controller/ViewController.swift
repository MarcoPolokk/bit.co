//
//  ViewController.swift
//  bit.co
//
//  Created by Paweł Kozioł on 21/01/2020.
//  Copyright © 2020 Paweł Kozioł. All rights reserved.
//

import UIKit

//MARK: - UIViewController
class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Must set the coinManager's delegate to recieve the notifications when the delegate methods are called.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }
}

//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        return
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = coinManager.currencyArray[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 27.0/255.0, green: 67.0/255.0, blue: 72.0/255.0, alpha: 1.0)])
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePrice(price: String, currency: String) {
        
        //Get hold of the main thread to update the UI, otherwise app will crash (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
}
