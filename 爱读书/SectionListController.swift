//
//  SectionListController.swift
//  爱读书
//
//  Created by kangyonggan on 8/1/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionListController: UITableViewController {
    
    var sectionDao = SectionDao();
    
    var sectionList = [MySection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    var book: MyBook? {
        didSet {
            self.navigationItem.title = book!.name;
            sectionList = sectionDao.findBookSections(bookId: (book!.id));
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSectionDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! SectionDetailController
                let section = sectionList[indexPath.row]
                controller.section = section
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "toActiveSection" {
            let section = sectionDao.findActiveSection(bookId: book!.id);
            if section == nil {
                let myAlert = UIAlertController(title: "提示", message: "您还没有阅读《\(book!.name)》", preferredStyle: .alert);
                let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myokAction);
                self.present(myAlert, animated: true, completion: nil);
            } else {
                let controller = (segue.destination as! UINavigationController).topViewController as! SectionDetailController
                controller.section = section
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
        
        let section = sectionList[indexPath.row]
        sectionCell.textLabel!.text = section.title
        return sectionCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
}
