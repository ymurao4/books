//
//  ContainerViewController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/16.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import RealmSwift

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var sortDate: UITabBarItem!
    @IBOutlet weak var sortTitle: UITabBarItem!
    @IBOutlet weak var sortAuthor: UITabBarItem!
    
    @IBOutlet weak var addButton: UIButton!
    
    private var tableViewController: ViewController!
    
    private var searchBar: UISearchBar!
    
    private var timer: Timer?
    
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        customizeButton()
        
        // delete a border under navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    
    
    func customizeButton() {
        addButton.layer.cornerRadius = (addButton.frame.size.width) / 2
        // +の位置を調整
        addButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowRadius = 1
        addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addButton.layer.shadowOpacity = 0.5
        addButton.backgroundColor = tableViewController.dynamicColor
    }
    
    
    @IBAction func pressAddButton(_ sender: UIButton) {
        tableViewController.displayAddField(message: "本を登録")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tableVC = segue.destination as? ViewController {
            self.tableViewController = tableVC
        }
        
    }
    
    

    
    
}


//MARK: - UISearchBar delegate

extension ContainerViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "タイトル、作家で探す"
            searchBar.tintColor = UIColor.gray
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar

        }
        
    }
        
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableViewController.cancelSearchBar(searchBar)
        
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableViewController.filterKeyword(searchBar)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            tableViewController.cancelSearchBar(searchBar)
        } else {
            tableViewController.filterKeyword(searchBar)
        }

    }
    

}

