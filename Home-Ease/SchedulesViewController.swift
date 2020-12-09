//
//  SchedulesViewController.swift
//  Home-Ease
//
//  Created by Jack Cho on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

//using "FSCalendar" by WenchaoD via cocoapod
//https://github.com/WenchaoD/FSCalendar
import FSCalendar


class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//        struct EventData {
////            let date: String?
////            let eventText: String?
//            let event: [Event]
//        }
//    struct Event {
//        let eventDate: String
//        let eventText: String
//    }
//        var event1 = Event(date: "2020-11-29", eventText: "yoyoyo")
//        var event2 = Event(date: "2020-11-29", eventText: "tototo")
//        var event3 = Event(date: "2020-11-29", eventText: "rororo")
//
//        var myArray = [event1, event2, event3]
    
    
    //use struct to draw data from firebase
    //and then from that struct, put the data into the arrayOfEvents
    
    
    
    fileprivate weak var calendar: FSCalendar!
    
    //"yyyy-MM-dd" of the date tapped
    var dateSelected : String?
    
//    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    //using alert and action to add cells to table view
    //reference: https://www.youtube.com/watch?v=Wu5l4e5uW4w&ab_channel=KiloLoco
   
    
    
    @IBAction func add(_ sender: Any) {
               if dateSelected == nil{
                   //don't add anything when no date is selected
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
                       //if user doesnt enter any event in the text field
                       return
                   }
                   
                   self.arrayForTableView.append(event)
                   //append the event description in array for table view
                   
                   self.eventTableView.reloadData()
                   
                   
                   newEvent[0] = self.dateSelected ?? "2021-01-01"
                   //force upwrap or not?
                   
                   newEvent[1] = event
                   //event decription
                   
                   //            print(newEvent)
                   
                   self.arrayOfEvents.append(newEvent)
                   //append this new event data into data pool
                   
                   self.calendar.reloadData()
               }
               alert.addAction(action)
               present(alert, animated: true)
               
           
    }
    
//    @IBAction func add(_ sender: Any) {
//        if dateSelected == nil{
//            //don't add anything when no date is selected
//            return
//        }
//        var newEvent = ["",""]
//        let alert = UIAlertController(title: "Add Event", message: nil, preferredStyle: .alert)
//        alert.addTextField { (eventTF) in
//            eventTF.placeholder = "Enter Event"
//        }
//        let action = UIAlertAction(title: "Add", style: .default) { (_) in
//            guard let event = alert.textFields?.first?.text
//                else {
//                    return
//            }
//            if event == ""{
//                //if user doesnt enter any event in the text field
//                return
//            }
//
//            self.arrayForTableView.append(event)
//            //append the event description in array for table view
//
//            self.eventTableView.reloadData()
//
//
//            newEvent[0] = self.dateSelected ?? "2021-01-01"
//            //force upwrap or not?
//
//            newEvent[1] = event
//            //event decription
//
//            //            print(newEvent)
//
//            self.arrayOfEvents.append(newEvent)
//            //append this new event data into data pool
//
//            self.calendar.reloadData()
//        }
//        alert.addAction(action)
//        present(alert, animated: true)
//
//    }
    
    
    var arrayForTableView: [String?] = []
    //this only contains the event description of an event. (for the selected date)
    //need to find out how to remove/add items in this array AND remove/add item in arrayOfEvents->DONE!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")! as UITableViewCell
        cell.textLabel?.text = arrayForTableView[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if editingStyle == .delete{
            for index in 0..<arrayOfEvents.count{
                //iterate through all the events, and look for entry that matches the event description and the date of the event to be deleted
                //and remove that event from data pool
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
    
    
    
    //data pool
    var arrayOfEvents = [["2020-11-29", "CSE438 Project Update"], ["2020-11-28", "grocery day"], ["2020-11-30", "CSE438 Lecture"], ["2020-12-02", "CSE438 Lecture"], ["2020-11-30", "Zoom with advisor"], ["2020-11-20", "event0"], ["2020-11-20", "event1"], ["2020-11-20", "event2"], ["2020-11-20", "event3"], ["2020-11-21", "event5"]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = FSCalendar(frame: CGRect(x: 25, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        
        eventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        eventTableView.dataSource = self
        
        //        print(arrayOfEvents.count)
        eventTableView.reloadData()
        
        let today = dateFormatter2.string(from: calendar.today!)
        print(today)
        
        //display today's event as view loads
        for index in 0..<arrayOfEvents.count{
                  if arrayOfEvents[index][0] == (today){
                      self.arrayForTableView.append(arrayOfEvents[index][1])
                      self.eventTableView.reloadData()
                  }
              }
        
    }
}  //end of scope for class ViewController







//creating secondary dateFormatter with fixed date format
//reference: https://stackoverflow.com/questions/37874349/how-to-add-events-to-fscalendar-swift
fileprivate var dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

extension SchedulesViewController: FSCalendarDataSource, FSCalendarDelegate{
    
    //dots
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = dateFormatter2.string(from: date)
        for index in 0..<arrayOfEvents.count{
            if arrayOfEvents[index].contains(dateString){
                return 1
            }
        }
        return 0
    }
    
    
    
    //call this function when user taps on the date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateString = dateFormatter2.string(from: date)
        print("date selected == \(dateString)")
        
        dateSelected = dateString
        
        self.arrayForTableView = [] //empty this array for table view
        self.eventTableView.reloadData()
        //as the tableview reloads, array for tableview is refreshed
        for index in 0..<arrayOfEvents.count{
            if arrayOfEvents[index][0] == (dateString){
                self.arrayForTableView.append(arrayOfEvents[index][1])
                self.eventTableView.reloadData()
            }
        }
//        if (self.arrayForTableView.isEmpty){
//            self.arrayForTableView = ["No Event to Display"]
//            self.eventTableView.reloadData()
//        }
    }
}

