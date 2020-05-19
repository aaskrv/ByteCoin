//
//  ViewController.swift
//  ByteCoin
//
//  Created by Adilet on 5/12/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    // MARK: - CoinManager Delegate
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didUpdateCurrency(_ coinManager: CoinManager, currency: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = currency.rateString
            self.currencyLabel.text = currency.currencyName
        }
    }

    // MARK: - PickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        print(selectedCurrency)
    }
    
    // MARK: - PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

}

