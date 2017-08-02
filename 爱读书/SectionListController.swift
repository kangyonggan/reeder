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
   
    var book: Any? {
        didSet {
            let book = self.book as? MyBook;
            self.navigationItem.title = book?.name;
            sectionList = sectionDao.findBookSections(bookName: (book?.name)!);
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
