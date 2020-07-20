//
//  DoneViewController.swift
//  MyTodoList
//
//  Created by kai on 2020/02/29.
//  Copyright © 2020 kai. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //Todoを格納した配列
    
    var todoList = [MyTodo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //保存しているToDOの読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedToDoList = userDefaults.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedToDoList) as? [MyTodo] {
                todoList.append(contentsOf: unarchiveTodoList.filter({$0.todoDone}))
            }
        }
    }
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    // テーブルの行数を返却する
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell",for: indexPath)
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
