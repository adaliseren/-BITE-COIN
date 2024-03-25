//
//  ViewController.swift
//  Bitcoin
//
//  Created by SEREN on 18.03.2024.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var biteCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    //MARK: -  UIPickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
    let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
    //MARK: -  CoinManagerDelegate
    
    func didUpdateCurrency (_ coinManager : CoinManager, currency : CurrencyData) {
        DispatchQueue.main.async {
            self.biteCoinLabel.text = currency.rateString
            self.currencyLabel.text = currency.asset_id_quote
        }
    }
    
    func didFailWithError(error: Error) {
        print (error)
    }
}

