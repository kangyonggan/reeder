//
//  ViewController.swift
//  爱读书
//
//  Created by kangyonggan on 8/1/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookListController: UITableViewController {
    
    var sectionListController: SectionListController? = nil
    
    var allBooks = [MyBook]();
    
    let bookDao = BookDao();
    let sectionDao = SectionDao();
    let debugDao = DebugDao();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            sectionListController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SectionListController
        }
        
        reloadBookList();
        
        // 注册通知接收
        NotificationCenter.default.addObserver(self, selector: #selector(BookListController.receiveNotify), name: NSNotification.Name(rawValue: "BookListRefresh"), object: nil)
        
        // debug
//        debugDao.delete(entityName: "Book");
//        debugDao.delete(entityName: "Section");
//        debugDao.delete(entityName: "TableId");
    }
    
    func receiveNotify() {
        reloadBookList();
    }
    
    func reloadBookList() {
        allBooks = bookDao.findAllBooks();
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSectionList" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! SectionListController
                let book = allBooks[indexPath.row]
                controller.book = book
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "toAddBook" {
            let controller = AddBookController();
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        let book = allBooks[indexPath.row]
        bookCell.textLabel!.text = book.name
        return bookCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 删除书籍及对应的章节
            let bookId = allBooks[indexPath.row].id;
            bookDao.delete(bookId: bookId);
            sectionDao.deleteBookSections(bookId: bookId);
            
            // 删除内存中的书籍和界面上的书籍
            allBooks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

