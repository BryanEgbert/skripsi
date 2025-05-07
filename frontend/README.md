# frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TODO List

- pages
- [x] Login page
- [x] Create account page
  - [x] Select role page
  - [x] Create user details page
  - [x] Create pet page
  - [x] Choose vet specialty page
  - **Create pet daycare pages**
    - [x] Create pet daycare details page
    - [x] Add pet daycare pictures page
    - [x] Edit pet daycare slot
    - [x] Edit pet daycare provided services page
  - **View pages for pet owners**
    - [ ] View pet daycares page
    - [x] View pets page
      - add pagination
    - [ ] View pet details page
      - [x] view vaccination records
      - [x] view pet information
      - [x] delete pet
      - [x] update pet info
      - [x] add vaccine record
      - [x] delete vaccine record
      - [ ] edit vaccine record
    - [x] View vets page
    - [ ] View booking history page
    - [ ] View booking detail
    - [ ] edit profile
    - [x] logout
  - **View pages for pet daycares**
    - [x] View booked pets
    - [x] Get own pet daycare details
    - [x] Edit pet daycare
    - [ ] Chat features
    - [-] Booking requests page
    - [ ] Edit slot for the day

# 8 Golden Rules
## Strive for Consistency
  - Consistent color
  - Consistent input design
  - Consistent button design
  - consistent usage of font family
## Cater to universal usability
  - User-friendly error message
  - Use of popular icons, custom or less-used icons have labels.
## Offer informative feedback
  - Add success and error message on create, edit, and delete operation
  - Change buttons content from text to loading progress on press during operation
## Design Dialog to yield closure
  - Pop-up confirmation dialog when user do a CRUD operation that cannot be undone and during booking confirmation
## Prevent errors
  - Add minimum and maximum number constraints to number inputs
  - Add helper text on email and password on register
  - Add required & optional text on input
## Permit easy reversal of actions
  - Delete button on view pages
## Keep users in control
  - User can choose preferred language
## Reduce short-term memory loss
  - Default values on edit forms
  - Saved address information during booking