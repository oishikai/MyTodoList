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
    
    var todoList = [MyTodo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //保存しているToDOの読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedToDoList = userDefaults.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(
                with: storedToDoList) as? [MyTodo] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
    }
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
        let okAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            // OKボタンがタップされた時の処理
            if let textField = alertController.textFields?.first{
                
                // ToDoの配列に入力値を先頭に挿入
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                // ToDoの保存処理
                let userDefaults = UserDefaults.standard
                //Dara型にシリアライズする
                let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
                
            }
        }
        // OKボタンがタップされたときの処理
        
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        // CANCELボタンを追加
        alertController.addAction(cancelButton)
        
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
        
        
    }
    // テーブルの行数を返却する
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return todoList.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell",for: indexPath)
        //行番号にあったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        //セルのラベルにToDoのタイトルをセット
        cell.textLabel?.text = myTodo.todoTitle
        //セルのチェックマーク状態をセット
        if myTodo.todoDone{
            //チェックあり
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            //チェックなし
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone{
            //完了済みの場合は未完了に変更
            myTodo.todoDone = false
        }else{
            // 未完了の場合は完了済みに変更
            myTodo.todoDone = true
        }
        // セルの状態を変更
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        //データ保存。Data型にシリアライズする
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        // UserDefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
    }
     //セルを削除した時の処理
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //削除可能かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //ToDoリストから削除
            todoList.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //データを保存。Data型にシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            // UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
            
            
        }
    
}
}
// 独自クラスwシリアライズする際には、NSObjectを継承し、NSCodingプロトコルに準拠する必要がある
class MyTodo: NSObject,NSCoding {
    
    //ToDoのタイトル
    var todoTitle: String?
    //ToDoを完了したかどうかを表すフラグ
    var todoDone: Bool = false
    //コンストラクタ
    override init(){
    }
    //NSCordingプロトコルに宣言されているでシリアライズ処理。デコード処理とも呼ばれる
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    //NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理とも言われる
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}
