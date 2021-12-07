<!-- Original App Design Project - README Template
=== -->

# DigiNote

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The application enables users to digitalize hand written notes. Primarily it would only work with English text, but it could potentially be expanded to convert formulas (math, physics, etc), drawings and hand written notes in languages other than English. It can also  potentially be expanded as a database for receipts that users wants to store and work with the text that is inside those pictures.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Education, Productivity
- **Mobile:** The main focus of the application would be mobile, since it has camera and would allow users to take pictures. But it could be also used as a desktop application with the pictures as it's input.
- **Story:** Users would be able to take pictures of hand written notes and the application would digitalize it. The user can the work (i.e.: cut/copy/edit) with the content.
- **Market:** Students, General Users
- **Habit:** The app can be used as often as the users requires it.
- **Scope:** Initially we would allow users to take pictuers of notes that contains English text. Later on it can be expanded to recognize formulas, drawings and other languages.  

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can take picture of a note with the camera.
* User can work with locally stored photos.
* The app can digitalize hand written English from the pictures.
* User can delete existing pictures/documents.
* User can export document in a PDF format.
* User can search the document names.

**Optional Nice-to-have Stories**

* Backup to Cloud (e.g.: Dropbox, Google Drive)
* Allows to copy/paste parts of a document (not just handwritten notes e.g.: receipts)
* User can choose the theme of the App Dark/Ligh/Device
* Users can edit the converted documents
* Users can share the documents via social media apps.

### 2. Screen Archetypes
* Home Screen
   * Users can view existing documents (i.e.: converted documents)
   * User can save the document.
   * Users can delete document.
   * Users can search the documents database.
  
* Take a picture/Upload picture Screen
   * if the upload button is clicked we open the local file viewer
   * if the Take a Picture button is clicked we open the camera

* Settings Screen
    * App notification configuration
    * Backup to cloud


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Tab
* Upload Tab
* Settings Tab

**Flow Navigation** (Screen to Screen)

* Home Screen
   * A list of existing documents, if available. If no documents exist, then a button to navigate to Upload Screen.
* Take A Picture/Upload Screen
* Settings Tab
   

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/aFoLy4D.jpg" width=600>


### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/U0ZuOhz.png" width=600>
<img src="https://i.imgur.com/sk6G06p.png" width=600>
<img src="https://i.imgur.com/lYjhXFL.png" width=600>


### [BONUS] Interactive Prototype
<img src="https://i.imgur.com/D9Sx4g8.gif" width=600>


## Schema 

### Models

#### Document
Document is the only object we will be dealing during the main development phase of our project. The object's properties are as follows: 


|  Property |  Property | Description |
| -------- | -------- | -------- |
|id        |String|This is the identifier of the document|
|name      |String|Human readable name of the document|
|createdAt |Date  |The date this document was created|
|editedAt  |Date  |The date the document was edited |
|size      |Int   |A property to show the date the documents' size |


### Networking
- Our application will be working solely on local files and will not have any type of network interaction at this stage. 

### Sprint Plan
[x] GitHub Project created. \
[x] GitHub Milestones created. \
[x] GitHub Issues created from user stories. \
[x] Issues added to project and assigned to specific team members.  

#### Unit 10 Submission

#### Completed User Stories
[x] User can click on on Gallery button and choose photos. \
[x] User can work with locally stored photos. 

##### GIF
<img src="https://i.imgur.com/xJXK2IQ.gif" width=600>


#### Unit 11 Submission
This week had a setback and had to revise our app. The original intent was to use the Vision Framework to implement the app. But the text extraction on that framework only had an accuracy of about 75% for handwritten text. So we revised and decided to use Firebase's MLKit. Because of that we weren't able to achieve our previously set goals and had to focus on learning about Firebase. Hence, we revised our milestones and updated them. 

#### Completed User Stories
[x] The app is connected to Firebase. 
[x] Users can sign up/in with Firebase.
[x] Cloud Function for text extraction from image implemented

##### GIF
<img src="https://i.imgur.com/HuVB4bo.gif" width=600>

#### Unit 12 Submission
All major issues of the app has been solved. The app MVP is almost ready.

#### Completed User Stories
[x] The shows a list of currently saved PDFs.

[x] Users can search in the list of PDFs.

[x] User can enable/disable dark theme from settings menu.

[x] The app can send images and receive extracted text from Cloud Vision. It's currently printed on the console and will be integrated within the next week.

##### GIF!

<img src="https://i.imgur.com/lYNUBXz.gif" width=600>
