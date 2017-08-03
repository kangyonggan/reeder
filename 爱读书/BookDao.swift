//
//  BookDao.swift
//  爱读书
//
//  Created by kangyonggan on 8/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class BookDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "Book";
    
    var tableIdDao = TableIdDao();

    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存书籍
    func save(book: MyBook) -> Int {
        let newBook = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newBook.setValue(book.name, forKey: "name");
        newBook.setValue(book.author, forKey: "author");
        newBook.setValue(book.url, forKey: "url");
        let nextId = tableIdDao.getNextTableId(tableName: entityName);
        newBook.setValue(nextId, forKey: "id");
      
        do {
            try managedObjectContext.save()
            return nextId;
        } catch {
             fatalError();
        }
    }
    
    // 删除书籍
    func delete(bookId: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "id=%@", NSNumber(value: bookId));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
             fatalError();
        }
    }
    
    // 查找所有书籍
    func findAllBooks() -> [MyBook] {
        var bookList = [MyBook]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let book = MyBook();
                book.name = (row.value(forKey: "name") as? String)!;
                book.author = (row.value(forKey: "author") as? String)!;
                book.url = (row.value(forKey: "url") as? String)!;
                book.id = (row.value(forKey: "id") as? Int)!;
                
                bookList.append(book);
            }
        }catch{
             fatalError();
        }
        
        return bookList;
    }
    
    // 根据url查找书籍，注意用于订阅前的防重复判断
    func findBook(url: String) -> MyBook? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "url=%@", url);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let book = MyBook();
            for row in rows {
                book.name = (row.value(forKey: "name") as? String)!;
                book.author = (row.value(forKey: "author") as? String)!;
                book.url = (row.value(forKey: "url") as? String)!;
                book.id = (row.value(forKey: "id") as? Int)!;
                
                return book;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
}
