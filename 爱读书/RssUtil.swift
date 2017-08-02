//
//  RssUtil.swift
//  爱读书
//
//  Created by kangyonggan on 8/1/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class RssUtil: NSObject, XMLParserDelegate {
    
    var bookDao = BookDao();
    var sectionDao = SectionDao();

    // 章节列表
    var sectionList:[MySection] = []
    
    // 书籍
    var book: MyBook = MyBook();
    
    var isEntry:Bool = false //判断是否解析到开始标签<entry>
    var isFeed:Bool = false //判断是否解析到开始标签<feed>
    var bookFinished = false;
    
    var currentElementValue:String! //当前解析的标签的值
    
    var currentTitle: String! // 当前章节的标题
    var currentContent: String! // 当前章节的内容
    
    var success = false;
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "entry" {
            isEntry = true;
        } else if elementName == "feed" {
            isFeed = true;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentElementValue = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if isFeed {
            if elementName == "title" && !bookFinished {
                book.name = self.currentElementValue;
            } else if elementName == "name" && !bookFinished {
                book.author = self.currentElementValue;
                bookFinished = true;
            } else if elementName == "feed" {
                // 读取完毕，落库
                success = true;
                saveBookAndSectionList();
            }
        }
        
        if isEntry {
            if elementName == "title" {
                self.currentTitle = self.currentElementValue;
            } else if elementName == "content" {
                self.currentContent = self.currentElementValue;
            }
        }
        
        if isEntry && elementName == "entry" {
            let section = MySection();
            section.title = self.currentTitle;
            section.content = self.currentContent;
            section.bookName = self.book.name;
            
            sectionList.append(section);
            isEntry = false;
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        NSLog("解析xml出错啦");
    }
    
    func saveBookAndSectionList() {
        bookDao.save(book: self.book);
        
        for section in sectionList {
            sectionDao.save(section: section);
        }
    }
}
