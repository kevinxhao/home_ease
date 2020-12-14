#  Home Ease by Dhruv Patel, Jackson Tidland, Krishna Vaidyanathan, Jack Cho, and Kevin Hao

NOTE: This app requires cocoapods for use. Be sure to install the pods by navigating to the folder for the project in terminal and running "pod install". Then, be sure to open and run the project as a .xcworkspace file and NOT a .xcodeproj file. 

This app is a roommate app that users can use to manage tasks, finances, and scheduling of themselves and other members of their household. We will provide a demo example below that will help guide you through the sign in and group creation process.

Demo 1:
1. Sign in with email “demo1@gmail.com”  and the password “12345678”.
2. Join “demoGroup” group with the password “12345678” .

Demo 2:
1. Create new user with a password with 8 characters or more
2. Join group “demoGroup” with the password “12345678” OR create a new group with a password with 8 characters or more.

Home Page:
- Users have an overall summary/access to the tasks they have to do most recently, finances, and a list of their roommates.

Tasks Page:
- Users can add tasks (chores, cleaning, cooking, errands etc.) to specific users in the group
- When you add a task, you must add the email of the user (not just the name of the user)
- On the left side row of tasks, once completed you can slide task (like deleting it) and it will move to the right side of tasks where you can delete the task completely from the list by sliding it.
- Each task is color coded, assigning it to a specific user in the group

Finances Page:
- Each user can keep track of total finances and individual finances
- Add spending and costs of living here

Calendar:
- Serves to add and keep track of roommates’ important dates and activities.
- The red circle on the calendar indicates today’s date.
- When tapping on dates on the calendar, the table view below the calendar reloads and displays events, if they exist.
- Users can add events to a calendar by tapping on a date where an event should take place, and tap on the “Add Event” on the top right corner. Then an event is added and displayed on the table view.
-On the table view cell, it’s text values are formatted as:
userName: eventDescription
so that the user can recognize which event was added by which user.
- A small blue dot under the dates on the calendar indicates that an event exists on the selected date.
- Horizontally swiping on the table view cell and tapping on “Delete” will give the user an alert window to confirm that a user wishes to delete an event.
-All events are handled by Realtime Firebase, so every member in the same group shares the same calendar.
-Users can swipe left / right on the calendar to change the month of the calendar.

Settings:
- Access username and password in top tab. Here you can change your password and it will alert you that your password has been changed.
- In the next tab, you can sign out which will reroute you back to the welcome page where you can sign in as a new user or group.
- Help and support tab leads you to an email that you can contact for further information about the project and course.

Citations:
This video was our main tool for setting up the Firebase Authentication system (aside from the Cloud Firestore from lecture) https://www.youtube.com/watch?v=1HN7usMROt8

We got the hex for the green color from here: https://www.colorhexa.com/66ff00#:~:text=In%20a%20RGB%20color%20space,%25%20green%20and%200%25%20blue.

We got the hex for the rest of the colors from this template here: https://www.color-hex.com/color-palette/13000

We copied the extension for UIColor from here, for converting hexadecimal strings to UI Colors: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

We heavily consulted this documentation (namely, the "Get a document") to get information from certain fields of our Firebase collections: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1

We consulted this documentation when we were first trying to figure out how to query our firestore collections: https://firebase.google.com/docs/firestore/query-data/queries

We consulted this, and learned how to set the document id of a new Firestore collection document in the code: https://stackoverflow.com/questions/53583664/how-to-add-document-with-custom-id-to-firebase-firestore-on-swift/53583738

We consulted this, and learned about how to access the current user that is signed in: https://firebase.google.com/docs/auth/ios/manage-users

We consulted this when trying to figure out how to display the app to the user, after they have signed in, without giving them the option to sign in again without first signing out: https://www.xspdf.com/resolution/50309044.html

We consulted this when trying to figure out the difference between Cloud Firestore and Realtime Database: https://firebase.google.com/docs/database/rtdb-vs-firestore

We consulted this when trying to determine how to use background threads to not execute a function until another has finished executing: https://stackoverflow.com/questions/24056205/how-to-use-background-thread-in-swift

We consulted this to figure out how to change the text displayed when a user swipes left to delete a table view cell on tasks: https://stackoverflow.com/questions/7394988/how-to-change-uitableview-delete-button-text
