//
//  AddBookController.swift
//  爱读书
//
//  Created by kangyonggan on 8/1/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class AddBookController: UIViewController {
    
    var currentNodeName: String!
    
    @IBOutlet weak var rssAdress: UITextField!
    
    @IBOutlet weak var addRss: UIButton!
    
    let bookDao = BookDao();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        addRss.layer.cornerRadius = 2;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addBook(_ sender: Any) {
        let address = rssAdress.text;
        if address == nil || address!.isEmpty {
            let myAlert = UIAlertController(title: "提示", message: "请输入RSS资源地址", preferredStyle: .alert);
            let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
            myAlert.addAction(myOkAction);
            self.present(myAlert, animated: true, completion: nil);
        } else {
            // 下载之前防重复判断
            let book = bookDao.findBook(url: address!);
            if book != nil {
                
                let myAlert = UIAlertController(title: "提示", message: "不可以重复订阅RSS资源", preferredStyle: .alert);
                let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myOkAction);
                self.present(myAlert, animated: true, completion: nil);
                
                return;
                
            }
            
            // 下载、解析、入库
            let parser = XMLParser(contentsOf: URL(string: address!)!)!
            
            let delegate = RssUtil();
            delegate.book.url = address!;
            parser.delegate = delegate
            parser.parse()
            
            if delegate.success {
                let myAlert = UIAlertController(title: "提示", message: "订阅成功", preferredStyle: .alert);
                let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myokAction);
                self.present(myAlert, animated: true, completion: nil);
                
                rssAdress.text = "";
            } else {
                let myAlert = UIAlertController(title: "提示", message: "资源不存在", preferredStyle: .alert);
                let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myokAction);
                self.present(myAlert, animated: true, completion: nil);
            }
        }
    }
    
}
