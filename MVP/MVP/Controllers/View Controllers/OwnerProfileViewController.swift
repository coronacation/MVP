//
//  OwnerProfileViewController.swift
//  WeShareStoryboards
//
//  Created by Anthroman on 5/7/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit

class OwnerProfileViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundDesign: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func segmentedControlButtonTapped(_ sender: UISegmentedControl) {
        
        let getIndex = segmentedControl.selectedSegmentIndex
        
        if getIndex == 0 {
            containerView.isHidden = true
        } else {
            containerView.isHidden = false
        }
        
    }
    
    //MARK: - Helpers
    
    //MARK: - TODO
    //This is supposed to tell the tableview when to scroll and when not to. Currently, it doesn't seem to work.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.tableView {
            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
        }
    }

    func setupViews() {
        containerView.isHidden = true
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        if tableView.visibleCells.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "tableViewBackground"))
            tableView.separatorStyle = .none
        }
    }
}

extension OwnerProfileViewController: UITableViewDelegate {
    
}
