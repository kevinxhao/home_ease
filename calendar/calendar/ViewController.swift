//
//  ViewController.swift
//  calendar
//
//  Created by Jack Cho on 11/16/20.
//  Copyright © 2020 Jack Cho. All rights reserved.
//

import UIKit

//using "FSCalendar" by WenchaoD via cocoapod
//https://github.com/WenchaoD/FSCalendar
import FSCalendar

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //edit change test
    
    
//    struct Event {
//        let date: String?
//        let eventText: String?
//    }
//
//    var event1 = Event(date: "2020-11-29", eventText: "yoyoyo")
//    var event2 = Event(date: "2020-11-29", eventText: "tototo")
//    var event3 = Event(date: "2020-11-29", eventText: "rororo")
//
//    var myArray = [event1, event2, event3]
    
    
    fileprivate weak var calendar: FSCalendar!
    
    var dateSelected : String?
    
    @IBOutlet weak var eventTableView: UITableView!
    
    
    //using alert and action to add cells to table view
    //reference: https://www.youtube.com/watch?v=Wu5l4e5uW4w&ab_channel=KiloLoco
    @IBAction func add(_ sender: Any) {
        if dateSelected == nil{
            return
        }
        var newEvent = ["",""]
        let alert = UIAlertController(title: "Add Event", message: nil, preferredStyle: .alert)
        alert.addTextField { (eventTF) in
            eventTF.placeholder = "Enter Event"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let event = alert.textFields?.first?.text
                else {
                    return
            }
            if event == ""{
                return
            }
            self.arrayForTableView.append(event)
            self.eventTableView.reloadData()
            newEvent[0] = self.dateSelected!
            newEvent[1] = event
            print(newEvent)
            self.arrayOfEvents.append(newEvent)
            self.calendar.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    var arrayForTableView: [String?] = []
    //this only contains the event description of an event. (for the selected date)
    //need to find out how to remove/add items in this array AND remove/add item in arrayOfEvents
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")! as UITableViewCell
        cell.textLabel!.text = arrayForTableView[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if editingStyle == .delete{
            
            for index in 0..<arrayOfEvents.count{
                if (arrayOfEvents[index][0] == dateSelected &&
                    arrayOfEvents[index][1] == cell?.textLabel?.text){
                    arrayOfEvents.remove(at: index)
                    break
                }
            }
            calendar.reloadData()
            
            arrayForTableView.remove(at: indexPath.row)
            eventTableView.deleteRows(at: [indexPath], with: .none)
            
            print("array of events is \(arrayOfEvents)")
            print("array for tableview is \(arrayForTableView)")
            
        }
    }
    
    
    
    
    var arrayOfEvents = [["2020-11-29", "CSE438 Project Update"], ["2020-11-28", "grocery day"], ["2020-11-30", "CSE438 Lecture"], ["2020-12-02", "CSE438 Lecture"], ["2020-11-30", "Zoom with advisor"], ["2020-11-20", "event0"], ["2020-11-20", "event1"], ["2020-11-20", "event2"], ["2020-11-20", "event3"], ["2020-11-21", "event5"]]
    
    
    //    let eventText = UITextView(frame: CGRect(x: 25, y: 400, width: 320, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = FSCalendar(frame: CGRect(x: 25, y: 70, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        //              eventText.text = "t"
        //        if (eventText.text != nil){
        //            eventText.font = eventText.font?.withSize(20)
        //        }
        //        eventText.backgroundColor = UIColor.systemGray6
        //        view.addSubview(eventText)
        
        
        
        eventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        eventTableView.dataSource = self
        
        print(  arrayOfEvents.count)
    }
    
    
}  //end of scope for class ViewController










//creating secondary dateFormatter with fixed date format
//reference: https://stackoverflow.com/questions/37874349/how-to-add-events-to-fscalendar-swift
fileprivate var dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

extension ViewController: FSCalendarDataSource, FSCalendarDelegate{
    //    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    //        return "asdf"
    //    }
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //        return "qwer"
    //    }
    //    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    //        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    //        return cell
    //    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = dateFormatter2.string(from: date)
        for index in 0..<arrayOfEvents.count{
            if arrayOfEvents[index].contains(dateString){
                return 1
            }
        }
        return 0
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter2.string(from: date)
        //        print("date selected == \(formatter.string(from: date))")
        print("date selected == \(dateString)")
        //        eventText.text = ""
        
        dateSelected = dateString
        
        
        self.arrayForTableView = []
        self.eventTableView.reloadData()
        for index in 0..<arrayOfEvents.count{
            if arrayOfEvents[index][0] == (dateString){
                //                eventText.text = "\(arrayOfEvents[index][1])"
                self.arrayForTableView.append(arrayOfEvents[index][1])
                self.eventTableView.reloadData()
            }
        }
    }
}
