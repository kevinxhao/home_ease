//
//  SchedulesViewController.swift
//  Home-Ease
//
//  Created by Jack Cho on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

//using "FSCalendar" by WenchaoD via cocoapod
//https://github.com/WenchaoD/FSCalendar
import FSCalendar

class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ref : DatabaseReference? = nil
    
    var userFirstName: String = ""
    
    var userGroup: String = ""
    
    
    
    //data pool
    //     var arrayOfEvents = [["2020-11-29", "CSE438 Project Update Submission Due"], ["2020-11-28", "Grocery"], ["2020-11-30", "CSE438 Project Status Update"], ["2020-12-02", "CSE438 Lecture"], ["2020-11-20", "event0"], ["2020-11-20", "event1"], ["2020-11-20", "event2"], ["2020-11-20", "event3"], ["2020-11-21", "event5"], ["2020-11-29","zoom meeting"]]
    
    var arrayOfEvents : [[String]] = []
    
    //
    
    
    var fireArray = [[String]]()
    
    //    @IBAction func fetchFirebase(_ sender: Any) {
    //        let ref = Database.database().reference()
    //        fireArray = []
    //        ref.observe(.value, with: {
    //                 snapshot in
    //
    //                 //before waiting, grab current state
    //                 print("\(snapshot.key) -> \(String(describing: snapshot.value))")
    //                 let someData = snapshot.value! as! Dictionary<String, [String]>
    //                 //cast data as dictionary
    //
    //                 //iterate though key and value in the dictionary
    //                 for (_,value) in someData {
    //                     print("value is \(value)")
    //                    self.fireArray.append(value)
    ////                    print(self.fireArray)
    //                     //we need self here to reference myArray
    //                 }
    ////                 reload data for calendar
    //            print(self.fireArray)
    //            self.arrayOfEvents = self.fireArray
    //            self.calendar.reloadData()
    //
    //             })
    //    }
    
    
    //
    
    //
    
    
    @IBAction func write(_ sender: Any) {
        let object : [String: Any] = [
            "0": "2020-12-26" ,
            "1" :  "real day after christmas"
        ]
        //        ref.child("eventWrite").setValue(object)
        ref?.childByAutoId().setValue(object)
        calendar.reloadData()
    }
    
    @IBOutlet weak var write: UIButton!
    
    
    
    fileprivate weak var calendar: FSCalendar!
    
    //"yyyy-MM-dd" of the date tapped
    var dateSelected : String?
    
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
            
            //             let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            //                return
            //            }
            
            
//            self.arrayForTableView.append(event)
            //append the event description in array for table view
            
//            self.eventTableView.reloadData()
            
            
            newEvent[0] = self.dateSelected ?? "2021-01-01"
            //force upwrap or not?
            
            newEvent[1] = self.userFirstName + ": " + event
            //event decription
            let object : [String: Any] = [
                "0": newEvent[0] ,
                "1" :  newEvent[1]
            ]
            //        ref.child("eventWrite").setValue(object)
            self.ref?.childByAutoId().setValue(object)
           
            
            //            print(newEvent)
            
            self.arrayOfEvents.append(newEvent)
            //append this new event data into data pool
            
            print("newEvent is \(newEvent)")
            
            self.calendar.reloadData()
            
            self.arrayForTableView.append(newEvent[1])
            self.eventTableView.reloadData()

           

        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            return
        }
        ))
        present(alert, animated: true)

    }
    
    
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
            
            //            print("array of events is \(arrayOfEvents)")
            //            print("array for tableview is \(arrayForTableView)")
            
            
            
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionaryForDelete = snapshot.value! as! Dictionary<String, [String]>
                
                if snapshot.childrenCount > 0 {
                    
                    for (key,value) in dictionaryForDelete {
                        if (value[0] == self.dateSelected  && value[1] == cell?.textLabel?.text){
                            //                        print("key is: \(key)")
                            self.ref?.child(key).removeValue()
                            
                            //                        print("removed")
                        }
                    }
                    
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    
    //pull data as dictionary
    
    //    event1:
    //name:
    //date:
    
    
    //.child("calendar")
    
    var tempArray: [String] = []
    
//    let groupName = "jackGroup"
//
//    var ref = Database.database().reference().child(groupName)
    
    //.child might be an initializer
    //
    //1. take the isntance variables
    //2.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let calendar = FSCalendar(frame: CGRect(x: 25, y: 80, width: 320, height: 300))
         calendar.dataSource = self
         calendar.delegate = self
         view.addSubview(calendar)
         self.calendar = calendar
         
         eventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
         eventTableView.dataSource = self
         
         //        print(arrayOfEvents.count)
         eventTableView.reloadData()
         
         let today = dateFormatter2.string(from: calendar.today!)
         //        print(today)
         
         //display today's event as view loads
         for index in 0..<arrayOfEvents.count{
             if arrayOfEvents[index][0] == (today){
                 self.arrayForTableView.append(arrayOfEvents[index][1])
                 self.eventTableView.reloadData()
             }
         }
        //##########################################
        
//        let groupName = "group8"
//        ref = Database.database().reference().child(groupName)
        
        let email = Auth.auth().currentUser?.email
        let docRef = Firestore.firestore().collection("users").document(email ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                /*for i in 0..<dataDescription.count{
                    print("index: \(i)")
                    print("value: \(dataDescription[i])")
                }*/
//                document.data()["group"]  //later
//                document.data()["group"]

//##############
 
                print("Document uid: \(document.data()!["firstName"] ?? "")")
            } else {
                print("Document does not exist")
            }
            
            
            self.userFirstName = document?.data()!["firstName"] as! String
            self.userGroup = document?.data()!["group"] as! String
            print("my name is \(self.userFirstName)")
            print("my group is \(self.userGroup)")
            
            self.ref = Database.database().reference().child(self.userGroup)
            
            
            
            self.ref?.observe(.value, with: {
                snapshot in
                
                //before waiting, grab current state
                //                                print("\(snapshot.key) -> \(String(describing: snapshot.value))")
                
                if snapshot.childrenCount > 0 {
                    
                    let someData = snapshot.value! as! Dictionary<String, [String]>
                    //cast data as dictionary
                    //                            print("someData is\(someData)")
                    //                            for (key, value) in someData{
                    //                               print("\(key) : \(value)")
                    //                             }
                    
                    //iterate though key and value in the dictionary
                    for (_,value) in someData {
                        //                                    print("value is \(value)")
                        self.fireArray.append(value)
                        //                    print(self.fireArray)
                        //we need self here to reference myArray
                    }
                    //                 reload data for calendar
                    //                           print("fireArray is \(self.fireArray)")
                    self.arrayOfEvents = self.fireArray
                    self.calendar.reloadData()
                    self.fireArray = []
                }
            })
            
            
        }
//#############
        
        
 
        
        //
        
        
        //
        
        

        /*
         
         //mkae dictionary variable
         
         //firebase
         //         let ref = Database.database().reference()
         //
         ref.observe(.value, with: {
         snapshot in
         
         //before waiting, grab current state
         print("\(snapshot.key) -> \(String(describing: snapshot.value))")
         
         if snapshot.childrenCount > 0 {
         
         let someData = snapshot.value! as! Dictionary<String, Dictionary<String, String>>
         //cast data as dictionary
         
         //iterate though key and value in the dictionary
         for (_,value) in someData {
         print("value is \(value)")
         for (_,valuePrime) in value{
         print("valuePrime is \(valuePrime)")
         //                               self.tempArray.append(keyPrime)
         self.tempArray.append(valuePrime)
         //                                self.fireArray.append(self.tempArray)
         }
         print("tempArray is \(self.tempArray)")
         self.fireArray.append(self.tempArray)
         print("fireArray is \(self.fireArray)")
         //we need self here to reference myArray
         }
         //                 reload data for calendar
         //                    print("fireArray is: \(self.fireArray)")
         self.arrayOfEvents = self.fireArray
         self.calendar.reloadData()
         self.fireArray = []
         self.tempArray = []
         }
         })
         
         
         */
        
        
        
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
        //        print("date selected == \(dateString)")
        
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
