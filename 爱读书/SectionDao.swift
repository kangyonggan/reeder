//
//  BookDao.swift
//  爱读书
//
//  Created by kangyonggan on 8/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class SectionDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "Section";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存章节
    func save(section: MySection) {
        let newSection = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newSection.setValue(section.title, forKey: "title");
        newSection.setValue(section.content, forKey: "content");
        newSection.setValue(section.bookName, forKey: "bookName");
        
        do {
            // 这个东西搞不好存在并发问题，不管了，玩不好这个语法
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除书籍的所有章节
    func deleteBookSections(bookName: String) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
//            let predicate = NSPredicate(format: "bookName=%@", bookName);
//            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 查找书籍的所有章节
    func findBookSections(bookName: String) -> [MySection] {
        var sectionList = [MySection]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookName=%@", bookName);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let section = MySection();
                section.title = (row.value(forKey: "title") as? String)!;
                section.content = (row.value(forKey: "content") as? String)!;
                section.bookName = (row.value(forKey: "bookName") as? String)!;
                sectionList.append(section);
            }
        }catch{
            fatalError();
        }
        
        return sectionList;
    }
    
}
