//
//  BookDao.swift
//  爱读书
//
//  Created by kangyonggan on 8/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class TableIdDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "TableId";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 获取某个表的下一个id
    func getNextTableId(tableName: String) -> Int {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "tableName=%@", tableName);
            request.predicate = predicate;
            
            request.propertiesToFetch = ["nextId"];
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            var nextId = 1;
            if rows.count > 0 {
                nextId = rows[0].value(forKey: "nextId") as! Int;
            } else {
                // 没有的就新增
                insert(tableName: tableName);
            }
            
            // 取出下一个id之后，要把id加1
            increaseNextId(tableName: tableName, nextId: nextId + 1);
            return nextId;
        }catch{
            fatalError();
        }
    }
    
    // 获取一个记录
    func findtableId(tableName: String) -> MyTableId? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "tableName=%@", tableName);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let tableId = MyTableId();
            for row in rows {
                tableId.tableName = (row.value(forKey: "tableName") as? String)!;
                tableId.nextId = (row.value(forKey: "nextId") as? Int)!;
                
                return tableId;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
    
    // 新增表id
    func insert(tableName: String) {
        let newTableId = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newTableId.setValue(tableName, forKey: "tableName");
        newTableId.setValue(1, forKey: "nextId");
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 把nextId加1
    func increaseNextId(tableName: String, nextId: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "tableName=%@", tableName);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                row.setValue(nextId, forKey: "nextId");
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
}
