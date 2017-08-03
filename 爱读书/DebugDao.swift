//
//  BookDao.swift
//  爱读书
//
//  Created by kangyonggan on 8/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class DebugDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 清空表记录
    func delete(entityName: String) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
}
