//
//  DownloadedBooksVC.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit
import FolioReaderKit

class DownloadedBooksVC: UITableViewController {

    var epubLists = [String]()
    var epubFiles = [URL]()
    
    // select row
    var idx = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookNames()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func loadBookNames(){
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:
            epubFiles = directoryContents.filter{ $0.pathExtension == "epub" }
            epubLists = epubFiles.flatMap({$0.deletingPathExtension().lastPathComponent})
            tableView.reloadData()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    


    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return epubLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        cell.textLabel?.text = epubLists[indexPath.row]
        cell.imageView?.image = UIImage(named: "gitbook")
        return cell
        
    }

    // MARK: delete

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            epubLists.remove(at: indexPath.row)
            do {
                try FileManager.default.removeItem(atPath: epubFiles[indexPath.row].path)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    
    // MARK : segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        
        let config = FolioReaderConfig()
        let path = epubFiles[idx].path
        FolioReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: config)
        
    }
}
