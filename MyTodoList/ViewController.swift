//
//  ViewController.swift
//  MyTodoList
//
//  Created by kai on 2020/02/27.
//  Copyright © 2020 kai. All rights reserved.
//

import UIKit

// UIYTableViewDataSource、UITableViewDelegateのプロトコルを実装する旨の宣言を行う

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //Todoを格納した配列
    
    var todoList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    // +ボタンをタップした時に呼ばれる処理
    @IBAction func tapAddButton(_ sender: Any) {
        // アラートダイアログを生成
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください",
                                                preferredStyle: UIAlertController.Style.alert)
        // テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default){(action: UIAlertAction) in
            // OKボタンがタップされた時の処理
            if let textField = alertController.textFields?.first{
                
                // ToDoの配列に入力値を先頭に挿入。
                self.todoList.insert(textField.text!, at: 0)
                
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        // OKボタンがタップされたときの処理
        let cancelButton = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        // CANCELボタンを追加
        alertController.addAction(cancelButton)
        
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
        
        
    }
    
}

