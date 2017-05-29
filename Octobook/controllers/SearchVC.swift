//
//  SearchVC.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit
import Alamofire
import Fuzi

class SearchVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var books = [Book]()
    var curPage = -1
    var idx = -1
    var loading = false
    
    var searchText: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchText = ""
    }
    
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text {
            if searchText != ""{
                self.searchText = searchText
                searchBooks(searchText)
            }
            
            if searchText == ""{
                books = []
                tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        books = []
        tableView.reloadData()
    }
    
    
    // MARK: - parse web
    
    func searchBooks(_ searchText: String) ->Void {
        if loading {
            return
        }
        loading = true
        curPage += 1
        
        
        Alamofire.request(Router.searchBooks(curPage, searchText))
            .responseString { response in
                guard response.result.error == nil else {
                    print(response.result.error?.localizedDescription ?? "error happens")
                    return
                }
                self.parseHTML(response.result.value!)
                
                self.loading = false
                self.tableView.reloadData()
        }
        
    }
    
    
    
    
    func parseHTML(_ html: String) -> Void {
        
        do {
            let doc = try HTMLDocument(string: html)
            
            // find book
            let elements = doc.css(".Book")
            
            for element in elements{
                let book = ParseUtil.parse(book: element)
                books.append(book)
                print(book.title)
            }
        } catch let error {
            print(error)
        }
    }
    
    

    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        cell.book = books[indexPath.row]
        
        if (!loading && indexPath.row == books.count - 1){
            searchBooks(self.searchText)
        }
        
        
        return cell
    }
    
    
    // MARK: - segue
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        
//        print(idx)
        performSegue(withIdentifier: "ShowSearchBookDetail", sender: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailCtrl = segue.destination as! BookDetalVC
        
        detailCtrl.book = books[idx]
        
    }
    
    
    



}
