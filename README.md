# Ezybook 
# Description

The EzyBook system architecture is designed to provide a seamless and efficient platform for managing bookings between users and service providers. The architecture consists of two core components: the User App and the Admin App, which interact with a centralized Firebase Realtime Database and Firebase Storage to ensure real-time synchronization and smooth data management.

# Features

* User authentication (Firebase Authentication)

* Browse best shops or restaurant

* Search Shops by name, locations

* Send booking requests

* Receive push notifications for booking updates

* Prevents clashes between two seats or tables

* Firebase Realtime Database for real-time updates

* Modern UI

# Installation
## Steps
1. Clone the repository:
```
https://github.com/jugalmahida/ezybook.git
```

2. Navigate to the project directory:

```
cd ezybook
```

3. Install dependencies:

```
flutter pub get
```

4. Run the application:

```
flutter run
```

# Technologies Used

* Flutter

* Firebase Authentication

* Firebase Realtime Database

* Firebase Cloud Messaging (Push Notifications)

* Firebase Cloud Firestore (Images)

* Google Cloud API key (Maps)

# App Screenshots

<table>
  <tr>
    <td><img src="/assets/images/SS/Home.jpg" alt="Home Page" width="300"/></td>
    <td><img src="/assets/images/SS/ShopDetails.jpg" alt="Shop Details" width="300"/></td>
  </tr>
  <tr>
    <td align="center"><b>Home Page</b></td>
    <td align="center"><b>Shop Detail Page</b></td>
  </tr>
  <tr>
    <td><img src="/assets/images/SS/SelectRequestedServices.jpg" alt="Selecting Services" width="300"/></td>
    <td><img src="/assets/images/SS/RequestSend.jpg" alt="Booking Request" width="300"/></td>
  </tr>
  <tr>
    <td align="center"><b>Selecting Services</b></td>
    <td align="center"><b>Booking Request Sent</b></td>
  </tr>
  <tr>
    <td><img src="/assets/images/SS/RequestConfim.jpg" alt="Request Confirmed" width="300"/></td>
    <td><img src="/assets/images/SS/Maps.jpg" alt="Google Maps" width="300"/></td>
  </tr>
  <tr>
    <td align="center"><b>Request Accepted</b></td>
    <td align="center"><b>Google Maps</b></td>
  </tr>
  <tr>
    <td><img src="/assets/images/SS/Search.jpg" alt="Search Page" width="300"/></td>
    <td><img src="/assets/images/SS/TrackRequest.jpg" alt="Track Request" width="300"/></td>
  </tr>
  <tr>
    <td align="center"><b>Search Page</b></td>
    <td align="center"><b>Track Requests</b></td>
  </tr>
</table>

