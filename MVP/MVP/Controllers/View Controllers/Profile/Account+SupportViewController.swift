//
//  Account+SupportViewController.swift
//  WeShareStoryboards
//
//  Created by Anthroman on 5/11/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit

class Account_SupportViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var accountSupportStackView: UIStackView!
    @IBOutlet weak var editAccountView: UIView!
    @IBOutlet weak var supportView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editAccountView.isHidden = true
        supportView.isHidden = true
    }
    
    //MARK: - Actions
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editAccountView.isHidden = false
        supportView.isHidden = true
        accountSupportStackView.isHidden = true
    }
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        supportView.isHidden = false
        editAccountView.isHidden = true
        accountSupportStackView.isHidden = true
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //MARK: - TODO: Save New Info
        editAccountView.isHidden = true
        supportView.isHidden = true
        accountSupportStackView.isHidden = false
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
