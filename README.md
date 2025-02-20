# Registration Checker for IKSS IC 2025

This Flutter application, designed for the **IKSS IC 2025** conference, automates the registration checking, coupon distribution, and gift-providing process, significantly easing the management of the event. It also prevents attendees from having multiple entries, gifts, and food tokens.It was an exciting experience to solve a real-world problem with an almost 100% success rate. 

### Features:
- **Registration Verification:** Automatically checks the registration status of attendees by retrieving data from Google Sheets.
- **Gift Allocation:** Ensures that each registered attendee receives a designated gift based on their registration details.
- **Food Token Distribution:** Provides food tokens to verified attendees.
- **Prevents Duplicate Entries:** Ensures that attendees can’t register multiple times, preventing multiple entries, gifts, or food tokens.
- **Real-Time Updates:** Changes in the Google Sheet are reflected in the app, allowing for seamless event management.

### Tech Stack:
- **Frontend:** Flutter (Dart)
  - User-friendly interface for event staff to quickly access attendee data.
- **Backend:** Google Sheets (for data management)
  - Utilized to store and update registration, coupon, gift, and food token data.

### Installation:

1. Clone the repository:  
   `git clone https://github.com/your-repository/registration_checker_for_IKSS_IC_2025.git`
2. Change the google_sheets_api.dart with your Google Sheets API credentials.
3. Adjust the column numbers from where you want to retrieve data and make changes to them.  
4. Install dependencies:  
   `flutter pub get`
5. Run the app:  
   `flutter run`

### How It Works:
- The app pulls live data from Google Sheets, allowing event coordinators to instantly verify registration details and distribute coupons, gifts, and food tokens without manual effort. It ensures that each attendee can only receive one set of each, preventing fraud or multiple claims.

### Screenshots:
![App Screenshot](assets/app_screenshot.png)

### Contributing:
Feel free to fork, submit issues, and create pull requests to help improve the project!

### License:
MIT License. See the [LICENSE](LICENSE) file for more information.
