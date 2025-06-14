import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// Initial message in the welcome text widget
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// The punch line of the app
  ///
  /// In en, this message translates to:
  /// **'The smarter way to find pet daycares & connect with vets!'**
  String get punchLine;

  /// password input
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordInputLabel;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginBtn;

  /// Create an account button
  ///
  /// In en, this message translates to:
  /// **'Create An Account'**
  String get createAnAccountBtn;

  /// or separator
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Pets title
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get petsTitle;

  /// Pet category
  ///
  /// In en, this message translates to:
  /// **'Pet category: {category}'**
  String petCategory(String category);

  /// Edit pet tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit pet'**
  String get editPetTooltip;

  /// Delete pet tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete pet'**
  String get deletePetTooltip;

  /// Title shown on the app bar of the edit pet details page
  ///
  /// In en, this message translates to:
  /// **'Edit Pet Info'**
  String get editPetInfoTitle;

  /// Label for the pet's name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Label for the pet category input field
  ///
  /// In en, this message translates to:
  /// **'Pet category'**
  String get petCategoryLabel;

  /// Label for the checkbox indicating whether the pet is spayed or neutered
  ///
  /// In en, this message translates to:
  /// **'Spayed/Neutered'**
  String get spayedNeuteredLabel;

  /// Text on the button to save the pet details
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddressButton;

  /// Validation error message shown when the name field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the Name'**
  String get nameEmptyError;

  /// Validation error message shown when the pet category is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select the Pet category'**
  String get petCategoryEmptyError;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveBtn;

  /// Pets nav bar
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get petsNav;

  /// Explore nav bar
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreNav;

  /// Vets nav bar
  ///
  /// In en, this message translates to:
  /// **'Vets'**
  String get vetsNav;

  /// Bookings nav bar
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsNav;

  /// Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Pet Vaccination
  ///
  /// In en, this message translates to:
  /// **'Pet Vaccination'**
  String get petVaccination;

  /// requiresVaccination
  ///
  /// In en, this message translates to:
  /// **'Requires Vaccination'**
  String get requiresVaccination;

  /// noRequiresVaccination
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t Require Vaccination'**
  String get noRequiresVaccination;

  /// distanceFilter
  ///
  /// In en, this message translates to:
  /// **'Distance in kilometer (GPS and location permission must be enabled)'**
  String get distanceFilter;

  /// distanceInfo
  ///
  /// In en, this message translates to:
  /// **'To disable filter by distance, set slider to 0'**
  String get distanceInfo;

  /// max distance input
  ///
  /// In en, this message translates to:
  /// **'Max Distance'**
  String get maxDistanceInput;

  /// Min distance input
  ///
  /// In en, this message translates to:
  /// **'Min Distance'**
  String get minDistanceInput;

  /// priceRange
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// Price range desc
  ///
  /// In en, this message translates to:
  /// **'To disable price range filter, set slider to 0'**
  String get priceRangeInfo;

  /// min price input
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get minPriceInput;

  /// max price input
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPriceInput;

  /// facilities
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Label for the pickup service filter chip
  ///
  /// In en, this message translates to:
  /// **'Pick-Up Service Provided'**
  String get pickupServiceProvided;

  /// Label for the food service filter chip
  ///
  /// In en, this message translates to:
  /// **'In-House Food Provided'**
  String get inHouseFoodProvided;

  /// Label for the grooming service filter chip
  ///
  /// In en, this message translates to:
  /// **'Grooming Service Provided'**
  String get groomingServiceProvided;

  /// Title for the daily walks section
  ///
  /// In en, this message translates to:
  /// **'Daily Walks'**
  String get dailyWalks;

  /// Filter option for no daily walks
  ///
  /// In en, this message translates to:
  /// **'No Walks Provided'**
  String get noWalksProvided;

  /// Filter option for one walk per day
  ///
  /// In en, this message translates to:
  /// **'One Walk a Day'**
  String get oneWalkADay;

  /// Filter option for two walks per day
  ///
  /// In en, this message translates to:
  /// **'Two Walks a Day'**
  String get twoWalksADay;

  /// Filter option for more than two walks per day
  ///
  /// In en, this message translates to:
  /// **'More Than Two Walks a Day'**
  String get moreThanTwoWalksADay;

  /// Title for the daily playtime section
  ///
  /// In en, this message translates to:
  /// **'Daily Playtime'**
  String get dailyPlaytime;

  /// Filter option for no playtime
  ///
  /// In en, this message translates to:
  /// **'No Playtime Provided'**
  String get noPlaytimeProvided;

  /// Filter option for one play session per day
  ///
  /// In en, this message translates to:
  /// **'One Play Session a Day'**
  String get onePlaySessionADay;

  /// Filter option for two play sessions per day
  ///
  /// In en, this message translates to:
  /// **'Two Play Session a Day'**
  String get twoPlaySessionsADay;

  /// Filter option for more than two play sessions per day
  ///
  /// In en, this message translates to:
  /// **'More Than Two Play Session a Day'**
  String get moreThanTwoPlaySessionsADay;

  /// Button label to apply the selected filters
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// Section title for veterinary specializations
  ///
  /// In en, this message translates to:
  /// **'Vet Specialties'**
  String get vetSpecialties;

  /// Booking history
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory;

  /// Confirmation message shown before cancelling a booking
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get cancelBookingConfirmation;

  /// Button text to cancel a booking
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Button text to give a review
  ///
  /// In en, this message translates to:
  /// **'Give Review'**
  String get giveReview;

  /// Instruction to user to tap the card elements to see more information
  ///
  /// In en, this message translates to:
  /// **'Tap the cards to view details'**
  String get tapCardsToViewDetails;

  /// Confirmation message shown before deleting a pet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this pet? This action cannot be undone.'**
  String get deletePetConfirmation;

  /// Title for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// Text for cancel button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Text for delete button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Text for no button in dialogs
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Text for yes button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Label showing the list of vet specialties joined by comma
  ///
  /// In en, this message translates to:
  /// **'Specialties: {vetSpecialtyNames}'**
  String specialtiesLabel(String vetSpecialtyNames);

  /// Title for the account settings page
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Label for the button or list tile to edit user profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Label for the toggle switch to enable or disable dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for the logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Title of the Edit User Profile page
  ///
  /// In en, this message translates to:
  /// **'Edit User Profile'**
  String get editUserProfile;

  /// Label for the user's display name input field
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Title for the booking details page
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// Label indicating the status of a booking
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @reservationDates.
  ///
  /// In en, this message translates to:
  /// **'Reservation Dates'**
  String get reservationDates;

  /// Label indicating whether pick-up service is used
  ///
  /// In en, this message translates to:
  /// **'Use Pick-up Service'**
  String get usePickupService;

  /// Label showing the list or count of pets that are included in a booking
  ///
  /// In en, this message translates to:
  /// **'Reserved Pets'**
  String get reservedPets;

  /// Section title that lists all individual pricing items or components
  ///
  /// In en, this message translates to:
  /// **'Pricings'**
  String get pricings;

  /// Label showing the sum of all pricing components
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Prompt message telling user to enable location services to find nearby pet daycare
  ///
  /// In en, this message translates to:
  /// **'Turn on location to find the nearest pet daycare'**
  String get turnOnLocationMessage;

  /// Button label to enable location settings
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOn;

  /// Label for pet daycare and boarding facilities
  ///
  /// In en, this message translates to:
  /// **'Pet Daycare & Boarding'**
  String get petDaycareBoarding;

  /// Distance from user to location
  ///
  /// In en, this message translates to:
  /// **'{range}km away'**
  String kmAway(double range);

  /// Label for the business operating hours
  ///
  /// In en, this message translates to:
  /// **'Operational Hour'**
  String get operationalHour;

  /// Label for listing the requirements for booking
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// Indicates that pet vaccination is mandatory
  ///
  /// In en, this message translates to:
  /// **'Pet Vaccination Required'**
  String get petVaccinationRequired;

  /// Indicates that pet vaccination is not mandatory
  ///
  /// In en, this message translates to:
  /// **'Pet Vaccination Not Required'**
  String get petVaccinationNotRequired;

  /// Sentence informing user that vaccination is required
  ///
  /// In en, this message translates to:
  /// **'Pet vaccination is required to book'**
  String get petVaccinationIsRequired;

  /// Sentence informing user that unvaccinated pets can still book
  ///
  /// In en, this message translates to:
  /// **'Unvaccinated pets can book at this daycare'**
  String get petVaccinationIsNotRequired;

  /// Section title for extra services offered
  ///
  /// In en, this message translates to:
  /// **'Additional Services'**
  String get additionalServices;

  /// Label for grooming services
  ///
  /// In en, this message translates to:
  /// **'Grooming Service'**
  String get groomingService;

  /// Indicates a service is available
  ///
  /// In en, this message translates to:
  /// **'Service provided'**
  String get serviceProvided;

  /// Indicates a service is not available
  ///
  /// In en, this message translates to:
  /// **'Service not provided'**
  String get serviceNotProvided;

  /// Label for pet pick-up service
  ///
  /// In en, this message translates to:
  /// **'Pick-Up Service'**
  String get pickupService;

  /// Indicates food is available at the facility
  ///
  /// In en, this message translates to:
  /// **'In-House Food Provided'**
  String get inHouseFoodProvidedDetails;

  /// Label for daily walk sessions
  ///
  /// In en, this message translates to:
  /// **'Number of Walks'**
  String get numberOfWalks;

  /// Label for daily play sessions
  ///
  /// In en, this message translates to:
  /// **'Number of Playtime'**
  String get numberOfPlaytime;

  /// Button to view reviews
  ///
  /// In en, this message translates to:
  /// **'View Reviews'**
  String get viewReviews;

  /// Button to book an available time slot
  ///
  /// In en, this message translates to:
  /// **'Book A Slot'**
  String get bookSlot;

  /// Label indicating the number of slots that have been booked
  ///
  /// In en, this message translates to:
  /// **'slots booked'**
  String get slotsBooked;

  /// Title for the reviews section or page
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  /// Shows the number of reviews, e.g., '120 Reviews'
  ///
  /// In en, this message translates to:
  /// **'{count} Reviews'**
  String reviewsCount(int count);

  /// Label or button to choose pets for the booking
  ///
  /// In en, this message translates to:
  /// **'Pick Pets'**
  String get pickPets;

  /// Prompt text asking user to select a date range for booking
  ///
  /// In en, this message translates to:
  /// **'Choose Booking Date'**
  String get chooseBookingDate;

  /// Label for the input field where user selects booking date
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDateLabel;

  /// Label on the button used to confirm and book the selected slot
  ///
  /// In en, this message translates to:
  /// **'Book Slot'**
  String get bookSlotButton;

  /// Button or label prompting the user to select or add an address
  ///
  /// In en, this message translates to:
  /// **'Choose an address'**
  String get chooseAddress;

  /// Prompt telling the user to choose a valid date range for booking or availability
  ///
  /// In en, this message translates to:
  /// **'Please select the available date range'**
  String get selectDateRange;

  /// Message shown when a pet is required to have valid vaccination documents to proceed
  ///
  /// In en, this message translates to:
  /// **'Pet must have a valid and up-to-date vaccination record'**
  String get vaccinationRequired;

  /// Error message shown when the selected pet type is not accepted
  ///
  /// In en, this message translates to:
  /// **'Pet category not supported'**
  String get unsupportedPetCategory;

  /// Label or section title for the list of user's saved addresses
  ///
  /// In en, this message translates to:
  /// **'Saved Address'**
  String get savedAddress;

  /// Label for additional user-entered information or remarks
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Indicates that an item has been selected (usually appears with a number or context)
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// Confirmation message shown before deleting a saved address
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address? This action cannot be undone.'**
  String get deleteAddressConfirmation;

  /// Button or title to add a new address
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// Label for optional notes field
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// Example text to help the user write address notes
  ///
  /// In en, this message translates to:
  /// **'e.g. Black front door, White wall with 2 plants'**
  String get notesExample;

  /// Label for location field
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get location;

  /// Label for address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Button label to use the user's current GPS location
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// Message shown when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Location request denied, please enable location in the settings'**
  String get locationRequestDenied;

  /// Title for the section displaying information about a pet
  ///
  /// In en, this message translates to:
  /// **'Pet Details'**
  String get petDetails;

  /// Title for the section showing the pet's vaccination history
  ///
  /// In en, this message translates to:
  /// **'Vaccination Records'**
  String get vaccinationRecords;

  /// Label showing the pet owner's name
  ///
  /// In en, this message translates to:
  /// **'owner: {name}'**
  String ownerName(String name);

  /// Label for the date when a vaccination was given
  ///
  /// In en, this message translates to:
  /// **'Date Administered:'**
  String get dateAdministered;

  /// Label for the next due date of a vaccination
  ///
  /// In en, this message translates to:
  /// **'Next Due Date:'**
  String get nextDueDate;

  /// A label for a button or action that allows the user to edit a record or information
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Label displaying the pet owner's name
  ///
  /// In en, this message translates to:
  /// **'owner: {ownerName}'**
  String petOwner(String ownerName);

  /// Title for the customers section
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// Button to sort the list by pets
  ///
  /// In en, this message translates to:
  /// **'Sort by Pets'**
  String get sortByPets;

  /// Button to sort the list by pet owners
  ///
  /// In en, this message translates to:
  /// **'Sort by Pet Owners'**
  String get sortByPetOwners;

  /// Message shown when no pets are booked
  ///
  /// In en, this message translates to:
  /// **'There are no booked pets'**
  String get noBookedPets;

  /// Button to send a photo to the pet owner
  ///
  /// In en, this message translates to:
  /// **'Send Photo To Pet Owner'**
  String get sendPhotoToOwner;

  /// Button to start a chat with the pet's owner
  ///
  /// In en, this message translates to:
  /// **'Chat pet\'s owner'**
  String get chatPetOwner;

  /// Message shown when there are no pet owners with bookings
  ///
  /// In en, this message translates to:
  /// **'There are no booked pet owners'**
  String get noBookedPetOwners;

  /// Button label to accept a booking or request
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Button label to reject a booking or request
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Label indicating that pick-up service is required
  ///
  /// In en, this message translates to:
  /// **'Pick-up required'**
  String get pickupRequired;

  /// Label indicating that pick-up service is not required
  ///
  /// In en, this message translates to:
  /// **'Pick-up not required'**
  String get pickupNotRequired;

  /// Button label to reject a booking request
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get rejectRequest;

  /// Confirmation message shown when rejecting a booking request
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this booking request? This action cannot be undone.'**
  String get rejectRequestConfirmation;

  /// Title for the list where pet daycare providers see pending booking requests to accept or reject.
  ///
  /// In en, this message translates to:
  /// **'Booking Queue'**
  String get bookingQueue;

  /// Title for the user's own pet daycare section or page
  ///
  /// In en, this message translates to:
  /// **'My Service'**
  String get myPetDaycare;

  /// Title shown when the user is setting up their account for the first time
  ///
  /// In en, this message translates to:
  /// **'Let\'s Set Up Your Account'**
  String get setupAccountTitle;

  /// Subtitle prompting user to input their account information
  ///
  /// In en, this message translates to:
  /// **'Enter your details to continue'**
  String get setupAccountSubtitle;

  /// Hint message about minimum password length
  ///
  /// In en, this message translates to:
  /// **'Must contain at least 8 characters'**
  String get passwordRequirement;

  /// Label for button to proceed to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Title displayed during signup role selection
  ///
  /// In en, this message translates to:
  /// **'Join Our Pet Daycare Community!'**
  String get signupTitle;

  /// Subtitle shown under the signup title
  ///
  /// In en, this message translates to:
  /// **'Choose your role to get started:'**
  String get signupSubtitle;

  /// Button title for user who wants to join as a pet owner
  ///
  /// In en, this message translates to:
  /// **'Pet Owner'**
  String get rolePetOwner;

  /// Description under the Pet Owner button
  ///
  /// In en, this message translates to:
  /// **'Discover trusted pet daycares & chat with vets.'**
  String get rolePetOwnerDesc;

  /// Button title for user who wants to join as a daycare provider
  ///
  /// In en, this message translates to:
  /// **'Pet Daycare Provider'**
  String get roleProvider;

  /// Description under the Pet Daycare Provider button
  ///
  /// In en, this message translates to:
  /// **'Connect with pet owners & grow your business.'**
  String get roleProviderDesc;

  /// Button title for user who wants to join as a veterinarian
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get roleVet;

  /// Description under the Veterinarian button
  ///
  /// In en, this message translates to:
  /// **'Provide expert care & guidance to pet owners.'**
  String get roleVetDesc;

  /// Button label to add a pet
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get addPet;

  /// Label for optional vaccination record section
  ///
  /// In en, this message translates to:
  /// **'Vaccination Record (Optional)'**
  String get vaccinationRecordOptional;

  /// Title or instruction to fill pet information
  ///
  /// In en, this message translates to:
  /// **'Fill Pet Info'**
  String get fillPetInfo;

  /// Label or instruction for selecting a category of pet
  ///
  /// In en, this message translates to:
  /// **'Choose pet category'**
  String get choosePetCategory;

  /// Instruction text asking user to input pet details
  ///
  /// In en, this message translates to:
  /// **'Enter your pet details to continue'**
  String get enterPetDetails;

  /// Instruction that adding vaccination record is optional
  ///
  /// In en, this message translates to:
  /// **'Add your pet\'s vaccination record (this step is optional)'**
  String get addVaccinationRecordOptional;

  /// Button label to create user account
  ///
  /// In en, this message translates to:
  /// **'Create My Account'**
  String get createMyAccount;

  /// Button label to skip a step
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Text shown while the account is being created
  ///
  /// In en, this message translates to:
  /// **'Creating Account'**
  String get creatingYourAccount;

  /// Prompt to upload or add a vaccination record photo
  ///
  /// In en, this message translates to:
  /// **'Click to add photo of the vaccination record'**
  String get clickToAddVaccinePhoto;

  /// Instructional text prompting the user to fill out their pet daycare or hotel information
  ///
  /// In en, this message translates to:
  /// **'Enter your pet daycare/hotel details to continue'**
  String get enterPetDaycareDetails;

  /// Label for the input field where the user enters the name of their pet daycare
  ///
  /// In en, this message translates to:
  /// **'Pet Daycare Name'**
  String get petDaycareName;

  /// Label for an optional description input field
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Prompt for users to upload at least one image of their pet daycare
  ///
  /// In en, this message translates to:
  /// **'Add images of your pet daycare (min. 1 image)'**
  String get addPetDaycareImages;

  /// Label for the section that defines business operating hours
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// Label for input field where user selects the opening time
  ///
  /// In en, this message translates to:
  /// **'Opening Hour'**
  String get openingHour;

  /// Label for input field where user selects the closing time
  ///
  /// In en, this message translates to:
  /// **'Closing Hour'**
  String get closingHour;

  /// Used between two time values (e.g., 9 AM to 5 PM)
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// Validation message when user has not added any image but it's required
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one image'**
  String get mustContainAtLeastOneImage;

  /// Title or heading for managing pet booking slots
  ///
  /// In en, this message translates to:
  /// **'Manage Your Pet Slots'**
  String get manageYourPetSlots;

  /// Error message shown when an operation fails unexpectedly
  ///
  /// In en, this message translates to:
  /// **'Something is wrong, please try again later'**
  String get somethingIsWrongTryAgain;

  /// Label for selecting the pricing model, such as per day or per night.
  ///
  /// In en, this message translates to:
  /// **'Pricing Model'**
  String get pricingModel;

  /// Label for dogs category
  ///
  /// In en, this message translates to:
  /// **'Dogs'**
  String get dogs;

  /// Label for other pets category
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// Question asking if cats are accepted
  ///
  /// In en, this message translates to:
  /// **'Accept cats?'**
  String get acceptCats;

  /// Question asking if bunnies are accepted
  ///
  /// In en, this message translates to:
  /// **'Accept bunnies?'**
  String get acceptBunnies;

  /// Prompt for user to select a pricing model.
  ///
  /// In en, this message translates to:
  /// **'Choose Pricing Model'**
  String get choosePricingModel;

  /// Label indicating the charge per unit, e.g. per day or per night.
  ///
  /// In en, this message translates to:
  /// **'Charge per {name}'**
  String chargePer(String name);

  /// Title shown when user is asked to configure the pet daycare services.
  ///
  /// In en, this message translates to:
  /// **'Configure Your Services'**
  String get configureYourServices;

  /// Label for indicating whether grooming service is available.
  ///
  /// In en, this message translates to:
  /// **'Grooming Provided'**
  String get groomingProvided;

  /// Label for indicating whether pickup service is available.
  ///
  /// In en, this message translates to:
  /// **'Pickup Provided'**
  String get pickupProvided;

  /// Label for indicating whether daily walks are provided for pets.
  ///
  /// In en, this message translates to:
  /// **'Daily Walks Provided'**
  String get dailyWalksProvided;

  /// Label for indicating whether daily playtime is provided for pets.
  ///
  /// In en, this message translates to:
  /// **'Daily Playtime Provided'**
  String get dailyPlaytimeProvided;

  /// Shown when the password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// Shown when the password entered is less than 8 characters.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 8 characters'**
  String get passwordTooShort;

  /// Generic message for any required text field left empty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get fieldCannotBeEmpty;

  /// Shown when price input is empty.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be empty'**
  String get priceEmpty;

  /// Shown when the price entered is 0 or negative.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get priceMustBeGreaterThanZero;

  /// Shown when the number of pet slots is invalid or less than 1.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid slot number'**
  String get invalidSlotNumber;

  /// Shown when the email field is empty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmpty;

  /// Shown when the email format is incorrect.
  ///
  /// In en, this message translates to:
  /// **'Email is not valid'**
  String get emailInvalid;

  /// Label for the price input field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Label for the number of pet slots
  ///
  /// In en, this message translates to:
  /// **'# of Slot'**
  String get numberOfSlots;

  /// Used after a price value, e.g., 'Price per Day' or 'Price per Night'. The {pricingModel} will be replaced by the actual pricing type name.
  ///
  /// In en, this message translates to:
  /// **'per {pricingModel}'**
  String perPricingModel(String pricingModel);

  /// Validation message when no pet types are selected for acceptance
  ///
  /// In en, this message translates to:
  /// **'Must accept at least one pet'**
  String get mustAcceptAtLeastOnePet;

  /// Displayed when the app fails to fetch the address from a service or database.
  ///
  /// In en, this message translates to:
  /// **'Something\'s wrong when fetching address'**
  String get fetchAddressError;

  /// Title for the page where users can edit their pet daycare details.
  ///
  /// In en, this message translates to:
  /// **'Edit Pet Daycare/Hotel'**
  String get editDaycare;

  /// Tab label showing general information about the daycare.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTab;

  /// Tab label for uploading or viewing daycare images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesTab;

  /// Tab label for managing available pet slots in the daycare.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get slotsTab;

  /// Tab label for configuring provided services (e.g. grooming, playtime).
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// Error message shown when the user's selected or entered location is not valid.
  ///
  /// In en, this message translates to:
  /// **'Invalid location'**
  String get invalidLocation;

  /// Confirmation dialog message asking the user to confirm deletion of a vaccination record. Irreversible action.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vaccination record? This action cannot be undone.'**
  String get confirmDeleteVaccination;

  /// Displayed when a pet does not have any vaccination records
  ///
  /// In en, this message translates to:
  /// **'There are no vaccination record for this pet.'**
  String get noVaccinationRecord;

  /// Displayed when an action or process finishes successfully
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully.'**
  String get operationSuccess;

  /// Generic error message shown when an unknown error occurs.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// Message shown when JWT token has expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get jwtExpired;

  /// Message shown when the user account has been deleted.
  ///
  /// In en, this message translates to:
  /// **'User has been deleted, please create a new account'**
  String get userDeleted;

  /// Informational message displayed when showing the user's past booking history
  ///
  /// In en, this message translates to:
  /// **'Your booking history shows here'**
  String get bookingHistoryInfo;

  /// Displayed when an image fails to load due to an error
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failToLoadImage;

  /// Label or title for choosing the user's preferred language
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// Prompt or instruction asking the user to select their preferred language
  ///
  /// In en, this message translates to:
  /// **'Choose Preferred Language'**
  String get choosePreferredLanguage;

  /// Validation error shown when the user hasn't selected any veterinarian specialties
  ///
  /// In en, this message translates to:
  /// **'Must choose at least one vet specialty'**
  String get mustChooseOneVetSpecialty;

  /// Label or title prompting the user to select one or more veterinarian specialties
  ///
  /// In en, this message translates to:
  /// **'Choose Vet Specialties'**
  String get chooseVetSpecialties;

  /// Shown when the user enters incorrect email or password during login.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// Displayed when requested data is not found or doesn't exist.
  ///
  /// In en, this message translates to:
  /// **'Data doesn\'t exist'**
  String get dataDoesNotExist;

  /// Label or title for a section that displays or requests information about a pet.
  ///
  /// In en, this message translates to:
  /// **'Pet Info'**
  String get petInfo;

  /// Title used when editing a pet daycare listing or profile
  ///
  /// In en, this message translates to:
  /// **'Edit Pet Daycare'**
  String get editPetDaycare;

  /// Label or title used when editing a pet's vaccination record
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccination Record'**
  String get editVaccinationRecord;

  /// Label or heading for a text that explains more details about something
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Button label or title for adding a new review
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// Validation message shown when a user must upload or select an image
  ///
  /// In en, this message translates to:
  /// **'Image required'**
  String get imageRequired;

  /// Label or button text to add a new vaccination record for a pet
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination Record'**
  String get addVaccinationRecord;

  /// Informational text displayed when no pet owners have messaged the user yet
  ///
  /// In en, this message translates to:
  /// **'Pet owners who message you will show up here.'**
  String get petOwnersMessageInfo;

  /// Prompt for users to choose one or more specialties (e.g., in a vet profile setup)
  ///
  /// In en, this message translates to:
  /// **'Select specialties'**
  String get selectSpecialties;

  /// Label or title prompting the user to rate a specific pet daycare
  ///
  /// In en, this message translates to:
  /// **'Rate {petDaycareName}'**
  String ratePetDaycare(String petDaycareName);

  /// Error message shown when the location input field is empty
  ///
  /// In en, this message translates to:
  /// **'Please Set an Address'**
  String get locationCannotBeEmpty;

  /// Displayed when user tries to save a vaccination record without an image.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Record\'s Image Required'**
  String get vaccinationImageRequired;

  /// Displayed when user selects a next due date earlier than or equal to the administered date.
  ///
  /// In en, this message translates to:
  /// **'Next Due date must be greater than the date administered'**
  String get nextDueDateValidationError;

  /// Edit address title
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// Button label to capture a photo using the camera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Button label to send or upload an image.
  ///
  /// In en, this message translates to:
  /// **'Send Image'**
  String get sendImage;

  /// Displayed when the user tries to submit a rating with zero value.
  ///
  /// In en, this message translates to:
  /// **'Ratings cannot be zero'**
  String get ratingCannotBeZero;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
