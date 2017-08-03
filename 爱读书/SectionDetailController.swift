//
//  SectionDetailController.swift
//  爱读书
//
//  Created by kangyonggan on 8/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionDetailController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var sectionDao = SectionDao();
    
    var currentSection: MySection?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(currentSection!.content, baseURL: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    var section: MySection? {
        didSet {
            loadSectionDetail()
        }
    }
    
    func loadSectionDetail() {
        currentSection = sectionDao.findSection(bookId: section!.bookId, sectionId: section!.id);
        if currentSection != nil {
            self.navigationItem.title = currentSection!.title;
            updateStatus();
        } else {
            let myAlert = UIAlertController(title: "提示", message: "发送未知异常，请联系康永敢！", preferredStyle: .alert);
            let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
            myAlert.addAction(myokAction);
            self.present(myAlert, animated: true, completion: nil);
            
            return;
        }
    }
    
    func updateStatus() {
        sectionDao.updateSectionToNoActive(bookId: currentSection!.bookId);
        sectionDao.updateSectionToActive(bookId: currentSection!.bookId, sectionId: currentSection!.id);
    }
    
    @IBAction func nextSection(_ sender: Any) {
        currentSection = sectionDao.findNextSection(bookId: currentSection!.bookId, sectionId: currentSection!.id);
        if currentSection != nil {
            self.navigationItem.title = currentSection!.title;
            webView.loadHTMLString(currentSection!.content, baseURL: nil);
            updateStatus();
        } else {
            let myAlert = UIAlertController(title: "提示", message: "发送未知异常，请联系康永敢！", preferredStyle: .alert);
            let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
            myAlert.addAction(myokAction);
            self.present(myAlert, animated: true, completion: nil);
            
            return;
        }
    }
}
