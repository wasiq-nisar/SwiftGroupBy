//
//  ViewController.swift
//  GroupBySwift
//
//  Created by Muhammad Wasiq  on 17/01/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fruits = [FruitModel]()
    var groupedFruits: [Date : [FruitModel]] = [:]
    var sectionHeaders: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
//        let fruit1 = FruitModel(name: "Apple", color: "Red", createdAtDate: dateFormatter.date(from: "17/01/2024") ?? Date())
//        let fruit2 = FruitModel(name: "Apple2", color: "Red", createdAtDate: dateFormatter.date(from: "01/01/2024") ?? Date())
//        let fruit4 = FruitModel(name: "Banana", color: "Yellow",createdAtDate: dateFormatter.date(from: "01/01/2024") ?? Date())
//        let fruit5 = FruitModel(name: "Banana2", color: "Yellow",createdAtDate: dateFormatter.date(from: "27/12/2023") ?? Date())
//        let fruit6 = FruitModel(name: "Grapes", color: "Green",createdAtDate: dateFormatter.date(from: "27/12/2023") ?? Date())
//
//        addFruit(fruit: fruit1)
//        addFruit(fruit: fruit2)
//        addFruit(fruit: fruit4)
//        addFruit(fruit: fruit5)
//        addFruit(fruit: fruit6)
        
        fetchFruits()
        fetchFruitsByColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
    }

    func addFruit(fruit: FruitModel) {
        let newFruit = Fruits(context: PersistanceStorage.shared.context)
        newFruit.fruitID = UUID()
        newFruit.fruitName = fruit.name
        newFruit.createdAtDate = fruit.createdAtDate
        newFruit.fruitColor = fruit.color
    
        PersistanceStorage.shared.saveContext()
    }
    
    func fetchFruits() {
        let context = PersistanceStorage.shared.context
        do {
            let request: NSFetchRequest<Fruits> = Fruits.fetchRequest()
            let entities = try context.fetch(request)
            
            fruits = entities.compactMap { entity in
                guard let name = entity.fruitName,
                   let color = entity.fruitColor,
                      let createdAtDate = entity.createdAtDate,
                   let id = entity.fruitID else { return nil }
                return FruitModel(name: name, color: color, createdAtDate: createdAtDate, uuid: id)
            }
        }
        catch {
            debugPrint(error)
        }
    }
    
    func fetchFruitsByColor() {
        groupedFruits = Dictionary(grouping: fruits, by: { $0.createdAtDate })
        sectionHeaders = Array(groupedFruits.keys)
        sectionHeaders = sectionHeaders.sorted(by: { (date1, date2) -> Bool in
            return date1 > date2
        })
        print(groupedFruits.keys)
        print("<------------------------------------>")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let color = sectionHeaders[indexPath.section]
        if let fruitsInSection = groupedFruits[color] {
            let fruit = fruitsInSection[indexPath.row]
            cell.title.text = fruit.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let color = sectionHeaders[section]
        return groupedFruits[color]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: sectionHeaders[section])
        let date = dateFormatter.date(from: dateString)
        
        if dateString == dateFormatter.string(from: Date()) {
            return "Today"
        }
//        if let date = date {
//            if let modifiedDate = Calendar.current.date(byAdding: .day, value: -30, to: date) {
//                print("Date: ", dateString)
//                print("Modified Date: ", modifiedDate)
//                let modifiedDateString = dateFormatter.string(from: modifiedDate)
//                print(Date())
//                if let currResDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
//                    dateFormatter.dateFormat = "dd/MM/yyyy"
//                    let currResDateString = dateFormatter.string(from: currResDate)
//                    if modifiedDateString == currResDateString {
//                        return "Previous 30 Days"
//                    }
//                }
//            }
//        }
        return dateString
    }
}
