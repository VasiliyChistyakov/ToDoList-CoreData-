//
//  TableViewController.swift
//  To-Do List
//
//  Created by Чистяков Василий Александрович on 06.05.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Task] = [ ]
    
    @IBAction  func saveTask(_ sender: UIBarButtonItem) {
        
        let allertContraler = UIAlertController(title: "New Task ", message: "Pleace add a new task ", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let tf = allertContraler.textFields?.first
            if let newTask = tf?.text {
                self.saveTask(withTitle : newTask)
                self.tableView.reloadData()
            }
        }
        
        allertContraler.addTextField { _ in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        allertContraler.addAction(saveAction)
        allertContraler.addAction(cancelAction)
        
        present(allertContraler, animated: true, completion: nil)
    }
    
    private func saveTask(withTitle title: String) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)  else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do{
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    
    private func getContext() ->  NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        
        let fecthRequestr: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor =  NSSortDescriptor (key: "title", ascending: true)
        fecthRequestr.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try context.fetch(fecthRequestr )
        } catch let error as NSError {
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let context = getContext()
//        let fecthRequestr: NSFetchRequest<Task> = Task.fetchRequest()
//        if let reults = try? context.fetch(fecthRequestr){
//            for object in reults {
//                context.delete(object)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch let error as NSError{
//            print(error.localizedDescription)
//        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    
}
