//
//  PopularBooksVC.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit
import Alamofire
import Fuzi


class PopularBooksVC: UITableViewController {

    var books = [Book]()
    var curPage = -1
    var idx = -1
    var loading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHTML()
    }
    
    // MARK: - parse web
    
    func loadHTML() ->Void {
        
        if loading {
            return
        }
        loading = true
        
        curPage += 1
        
        Alamofire.request(Router.popularBooks(curPage))
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
            loadHTML()
        }
        
        return cell
    }
    


    // MARK: - segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        performSegue(withIdentifier: "BookDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        let detailCtrl = segue.destination as! BookDetalVC
        
        detailCtrl.book = books[idx]
        
    }
    

}
