//
//  TestPostCategoryViewController.swift
//  MVP
//
//  Created by Theo Vora on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class TestPostCategoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    var categories = Category.allValuesAsStrings
    var categoryPickerView = UIPickerView()
    
    
    // MARK: - Outlets
    
    // TODO: @IBOutlet goes here
    weak var categoryTextField: UITextField! // replace me with the IBOutlet
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryPicker()
    }
    
    
    // MARK: - UIPickerView
    
    func setupCategoryPicker() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.text = categories[0]
    }
    
    // components = columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
        self.view.endEditing(true)
    }
}
