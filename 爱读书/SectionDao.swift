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
    
    var tableIdDao = TableIdDao();
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存章节
    func save(section: MySection) {
        let newSection = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newSection.setValue(section.title, forKey: "title");
        newSection.setValue(section.content, forKey: "content");
        newSection.setValue(section.bookId, forKey: "bookId");
        newSection.setValue(tableIdDao.getNextTableId(tableName: entityName), forKey: "id");
        
        do {
            // 这个东西搞不好存在并发问题，不管了，玩不好这个语法
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除书籍的所有章节
    func deleteBookSections(bookId: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@", NSNumber(value: bookId));
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
    
    // 查找书籍的所有章节
    func findBookSections(bookId: Int) -> [MySection] {
        var sectionList = [MySection]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@", NSNumber(value: bookId));
            request.predicate = predicate;
            
            request.propertiesToFetch = ["title", "bookId", "id"];
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let section = MySection();
                section.title = (row.value(forKey: "title") as? String)!;
                section.bookId = (row.value(forKey: "bookId") as? Int)!;
                section.id = (row.value(forKey: "id") as? Int)!;
                sectionList.append(section);
            }
        }catch{
            fatalError();
        }
        
        return sectionList;
    }
    
    // 查找书籍的指定章节
    func findSection(bookId: Int, sectionId: Int) -> MySection? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@ AND id=%@", NSNumber(value: bookId), NSNumber(value: sectionId));
            request.predicate = predicate;
            
            request.propertiesToFetch = ["title", "bookId", "id", "content"];
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let section = MySection();
                section.title = (row.value(forKey: "title") as? String)!;
                section.content = (row.value(forKey: "content") as? String)!;
                section.bookId = (row.value(forKey: "bookId") as? Int)!;
                section.id = (row.value(forKey: "id") as? Int)!;
                return section;
            }
        }catch{
            fatalError();
        }
        return nil;
    }
    
    // 查找书籍的指定的下一章节
    func findNextSection(bookId: Int, sectionId: Int) -> MySection? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@ AND id>%@", NSNumber(value: bookId), NSNumber(value: sectionId));
            request.predicate = predicate;
            request.fetchOffset = 0;
            request.fetchLimit = 1;
            
            request.propertiesToFetch = ["title", "bookId", "id", "content"];
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let section = MySection();
                section.title = (row.value(forKey: "title") as? String)!;
                section.content = (row.value(forKey: "content") as? String)!;
                section.bookId = (row.value(forKey: "bookId") as? Int)!;
                section.id = (row.value(forKey: "id") as? Int)!;
                return section;
            }
        }catch{
            fatalError();
        }
        return nil;
    }
    
    // 把章节设置为正在阅读，以便下次续读
    func updateSectionToActive(bookId: Int, sectionId: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@ AND id=%@", NSNumber(value: bookId), NSNumber(value: sectionId));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                row.setValue(true, forKey: "isActive");
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 清空所有章节的正在阅读标识
    func updateSectionToNoActive(bookId: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@", NSNumber(value: bookId));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                row.setValue(false, forKey: "isActive");
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 查找续读章节
    func findActiveSection(bookId: Int) -> MySection? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "bookId=%@ AND isActive=%@", NSNumber(value: bookId), true as CVarArg);
            request.predicate = predicate;
            
            request.propertiesToFetch = ["title", "bookId", "id", "content"];
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let section = MySection();
                section.title = (row.value(forKey: "title") as? String)!;
                section.content = (row.value(forKey: "content") as? String)!;
                section.bookId = (row.value(forKey: "bookId") as? Int)!;
                section.id = (row.value(forKey: "id") as? Int)!;
                return section;
            }
        }catch{
            fatalError();
        }
        return nil;
    }
    
}
