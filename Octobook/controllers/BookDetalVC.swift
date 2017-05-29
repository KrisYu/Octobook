//
//  BookDetalVC.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner


class BookDetalVC: UITableViewController {
    
    var book: Book?
    var epubUrl: String?
    var progress: Double = 0.0

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var staticCell: UITableViewCell!
    
    var downloadBanner: Banner?
    var finishBanner: Banner?

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = book?.title
        self.epubUrl = URLs.downloadUrl + (book?.epubUrl)!
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateUI(){
        self.titleLabel.text = book?.title
        self.starCountLabel.text =  "★  \(book!.starCount)"
        self.summaryLabel.text = book?.summary
        self.authorLabel.text  = book?.author
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReadOnline" {
            let destCtrl = segue.destination as! WebVC
            destCtrl.urlString = book?.id
        }
        if segue.identifier == "ShowAuthorWeb" {
            let destCtrl = segue.destination as! WebVC
            
            let authorURL = (URLs.authorUrl + "\((book?.author)!)")
            destCtrl.urlString = authorURL
            
        }
    }
    
    // MARK : - find the download row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedCell = tableView.cellForRow(at: indexPath)
        
        if (clickedCell == staticCell) {
            if let epubDownUrl = epubUrl{
                showDownloadBanner()
                let destination = DownloadRequest.suggestedDownloadDestination()
                
                Alamofire.download(epubDownUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination)
                    .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("Progress: \(progress.fractionCompleted)")

                    }
                    .validate { request, response, temporaryURL, destinationURL in
                        // Custom evaluation closure now includes file URLs (allows you to parse out error messages if necessary)
                        return .success
                    }
                    .responseJSON { response in
                        debugPrint(response)
                        self.downloadBanner?.dismiss()
//                        print(response.temporaryURL)
//                        print(response.destinationURL)
                }
            }
        }
        
    }
    
    
    // MARK: - download banner
    
    func showDownloadBanner() {
        // show not connected error & tell em to try again when they do have a connection // check for existing banner
        
        if let existingBanner = self.downloadBanner{
            existingBanner.dismiss()
        }
        
        downloadBanner = Banner(title: "Downloading Book Now",
                                subtitle: "When finished, you can find in Downloaded Books",
                                image: nil,
                                backgroundColor: UIColor(red: 139/255, green: 207/255, blue: 184/255,alpha: 1.0))
        downloadBanner?.dismissesOnTap = true
        downloadBanner?.show()
        
    }

    
   

    
}
