//
//  TaskListViewController.swift
//  Todobox
//
//  Created by 전수열 on 12/26/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

let TodoboxTasksUserDefaultsKey = "TodoboxTasksUserDefaultsKey"

class TaskListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    /// 할 일 목록
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasks.append(Task(title: "메일 보내기", done: true))
        self.tasks.append(Task(title: "점심 뭐먹을지 생각하기", done: true))
        self.tasks.append(Task(title: "저녁 뭐먹을지 생각하기"))
        self.tasks.append(Task(title: "방 정리"))
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? UINavigationController,
           let taskEditorViewController = navigationController.viewControllers.first as? TaskEditorViewController {
            taskEditorViewController.didAddHandler = { task in
                self.tasks.append(task)
                self.tableView.reloadData()
            }
        }
    }

    /// `tasks`를 로컬에 저장합니다.
    func saveAll() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done,
            ]
        }

        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(data, forKey: TodoboxTasksUserDefaultsKey)
        userDefaults.synchronize()
    }

    }

}


// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }

}


// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}