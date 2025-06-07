// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get punchLine => 'The smarter way to find pet daycares & connect with vets!';

  @override
  String get passwordInputLabel => 'Password';

  @override
  String get loginBtn => 'Login';

  @override
  String get createAnAccountBtn => 'Create An Account';

  @override
  String get or => 'or';

  @override
  String get petsTitle => 'Pets';

  @override
  String petCategory(String category) {
    return 'Pet category: $category';
  }

  @override
  String get editPetTooltip => 'Edit pet';

  @override
  String get deletePetTooltip => 'Delete pet';

  @override
  String get editPetInfoTitle => 'Edit Pet Info';

  @override
  String get nameLabel => 'Name';

  @override
  String get petCategoryLabel => 'Pet category';

  @override
  String get spayedNeuteredLabel => 'Spayed/Neutered';

  @override
  String get saveAddressButton => 'Save Address';

  @override
  String get nameEmptyError => 'Please enter the Name';

  @override
  String get petCategoryEmptyError => 'Please select the Pet category';

  @override
  String get saveBtn => 'Save';

  @override
  String get petsNav => 'Pets';

  @override
  String get exploreNav => 'Explore';

  @override
  String get vetsNav => 'Vets';

  @override
  String get bookingsNav => 'Bookings';

  @override
  String get back => 'Back';

  @override
  String get petVaccination => 'Pet Vaccination';

  @override
  String get requiresVaccination => 'Requires Vaccination';

  @override
  String get noRequiresVaccination => 'Doesn\'t Require Vaccination';

  @override
  String get distanceFilter => 'Distance in kilometer (GPS and location permission must be enabled)';

  @override
  String get distanceInfo => 'To disable filter by distance, set slider to 0';

  @override
  String get maxDistanceInput => 'Max Distance';

  @override
  String get minDistanceInput => 'Min Distance';

  @override
  String get priceRange => 'Price Range';

  @override
  String get priceRangeInfo => 'To disable price range filter, set slider to 0';

  @override
  String get minPriceInput => 'Min Price';

  @override
  String get maxPriceInput => 'Max Price';

  @override
  String get facilities => 'Facilities';

  @override
  String get messages => 'Messages';

  @override
  String get pickupServiceProvided => 'Pick-Up Service Provided';

  @override
  String get inHouseFoodProvided => 'In-House Food Provided';

  @override
  String get groomingServiceProvided => 'Grooming Service Provided';

  @override
  String get dailyWalks => 'Daily Walks';

  @override
  String get noWalksProvided => 'No Walks Provided';

  @override
  String get oneWalkADay => 'One Walk a Day';

  @override
  String get twoWalksADay => 'Two Walks a Day';

  @override
  String get moreThanTwoWalksADay => 'More Than Two Walks a Day';

  @override
  String get dailyPlaytime => 'Daily Playtime';

  @override
  String get noPlaytimeProvided => 'No Playtime Provided';

  @override
  String get onePlaySessionADay => 'One Play Session a Day';

  @override
  String get twoPlaySessionsADay => 'Two Play Session a Day';

  @override
  String get moreThanTwoPlaySessionsADay => 'More Than Two Play Session a Day';

  @override
  String get applyFilter => 'Apply Filter';

  @override
  String get vetSpecialties => 'Vet Specialties';

  @override
  String get bookingHistory => 'Booking History';

  @override
  String get cancelBookingConfirmation => 'Are you sure you want to cancel this booking? This action cannot be undone.';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get giveReview => 'Give Review';

  @override
  String get tapCardsToViewDetails => 'Tap the cards to view details';

  @override
  String get deletePetConfirmation => 'Are you sure you want to delete this pet? This action cannot be undone.';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String specialtiesLabel(String vetSpecialtyNames) {
    return 'Specialties: $vetSpecialtyNames';
  }

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get logout => 'Logout';

  @override
  String get editUserProfile => 'Edit User Profile';

  @override
  String get displayName => 'Display Name';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get statusLabel => 'Status';

  @override
  String get reservationDates => 'Reservation Dates';

  @override
  String get usePickupService => 'Use Pick-up Service';

  @override
  String get reservedPets => 'Reserved Pets';

  @override
  String get pricings => 'Pricings';

  @override
  String get total => 'Total';

  @override
  String get turnOnLocationMessage => 'Turn on location to find the nearest pet daycare';

  @override
  String get turnOn => 'Turn On';

  @override
  String get petDaycareBoarding => 'Pet Daycare & Boarding';

  @override
  String kmAway(double range) {
    final intl.NumberFormat rangeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rangeString = rangeNumberFormat.format(range);

    return '${rangeString}km away';
  }

  @override
  String get operationalHour => 'Operational Hour';

  @override
  String get requirements => 'Requirements';

  @override
  String get petVaccinationRequired => 'Pet Vaccination Required';

  @override
  String get petVaccinationNotRequired => 'Pet Vaccination Not Required';

  @override
  String get petVaccinationIsRequired => 'Pet vaccination is required to book';

  @override
  String get petVaccinationIsNotRequired => 'Unvaccinated pets can book at this daycare';

  @override
  String get additionalServices => 'Additional Services';

  @override
  String get groomingService => 'Grooming Service';

  @override
  String get serviceProvided => 'Service provided';

  @override
  String get serviceNotProvided => 'Service not provided';

  @override
  String get pickupService => 'Pick-Up Service';

  @override
  String get inHouseFoodProvidedDetails => 'In-House Food Provided';

  @override
  String get numberOfWalks => 'Number of Walks';

  @override
  String get numberOfPlaytime => 'Number of Playtime';

  @override
  String get viewReviews => 'View Reviews';

  @override
  String get bookSlot => 'Book A Slot';

  @override
  String get slotsBooked => 'slots booked';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String reviewsCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Reviews';
  }

  @override
  String get pickPets => 'Pick Pets';

  @override
  String get chooseBookingDate => 'Choose Booking Date';

  @override
  String get bookingDateLabel => 'Booking Date';

  @override
  String get bookSlotButton => 'Book Slot';

  @override
  String get chooseAddress => 'Choose an address';

  @override
  String get selectDateRange => 'Please select the available date range';

  @override
  String get vaccinationRequired => 'Pet must have a valid and up-to-date vaccination record';

  @override
  String get unsupportedPetCategory => 'Pet category not supported';

  @override
  String get savedAddress => 'Saved Address';

  @override
  String get notes => 'Notes';

  @override
  String get selected => 'selected';

  @override
  String get deleteAddressConfirmation => 'Are you sure you want to delete this address? This action cannot be undone.';

  @override
  String get addAddress => 'Add Address';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get notesExample => 'e.g. Black front door, White wall with 2 plants';

  @override
  String get location => 'Location Name';

  @override
  String get address => 'Address';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get locationRequestDenied => 'Location request denied, please enable location in the settings';

  @override
  String get petDetails => 'Pet Details';

  @override
  String get vaccinationRecords => 'Vaccination Records';

  @override
  String ownerName(String name) {
    return 'owner: $name';
  }

  @override
  String get dateAdministered => 'Date Administered:';

  @override
  String get nextDueDate => 'Next Due Date:';

  @override
  String get edit => 'Edit';

  @override
  String petOwner(String ownerName) {
    return 'owner: $ownerName';
  }

  @override
  String get customers => 'Customers';

  @override
  String get sortByPets => 'Sort by Pets';

  @override
  String get sortByPetOwners => 'Sort by Pet Owners';

  @override
  String get noBookedPets => 'There are no booked pets';

  @override
  String get sendPhotoToOwner => 'Send Photo To Pet Owner';

  @override
  String get chatPetOwner => 'Chat pet\'s owner';

  @override
  String get noBookedPetOwners => 'There are no booked pet owners';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get pickupRequired => 'Pick-up required';

  @override
  String get pickupNotRequired => 'Pick-up not required';

  @override
  String get rejectRequest => 'Reject Request';

  @override
  String get rejectRequestConfirmation => 'Are you sure you want to reject this booking request? This action cannot be undone.';

  @override
  String get bookingQueue => 'Booking Queue';

  @override
  String get myPetDaycare => 'My Service';

  @override
  String get setupAccountTitle => 'Let\'s Set Up Your Account';

  @override
  String get setupAccountSubtitle => 'Enter your details to continue';

  @override
  String get passwordRequirement => 'Must contain at least 8 characters';

  @override
  String get next => 'Next';

  @override
  String get signupTitle => 'Join Our Pet Daycare Community!';

  @override
  String get signupSubtitle => 'Choose your role to get started:';

  @override
  String get rolePetOwner => 'Pet Owner';

  @override
  String get rolePetOwnerDesc => 'Discover trusted pet daycares & chat with vets.';

  @override
  String get roleProvider => 'Pet Daycare Provider';

  @override
  String get roleProviderDesc => 'Connect with pet owners & grow your business.';

  @override
  String get roleVet => 'Veterinarian';

  @override
  String get roleVetDesc => 'Provide expert care & guidance to pet owners.';

  @override
  String get addPet => 'Add Pet';

  @override
  String get vaccinationRecordOptional => 'Vaccination Record (Optional)';

  @override
  String get fillPetInfo => 'Fill Pet Info';

  @override
  String get choosePetCategory => 'Choose pet category';

  @override
  String get enterPetDetails => 'Enter your pet details to continue';

  @override
  String get addVaccinationRecordOptional => 'Add your pet\'s vaccination record (this step is optional)';

  @override
  String get createMyAccount => 'Create My Account';

  @override
  String get skip => 'Skip';

  @override
  String get creatingYourAccount => 'Creating Account';

  @override
  String get clickToAddVaccinePhoto => 'Click to add photo of the vaccination record';

  @override
  String get enterPetDaycareDetails => 'Enter your pet daycare/hotel details to continue';

  @override
  String get petDaycareName => 'Pet Daycare Name';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get addPetDaycareImages => 'Add images of your pet daycare (min. 1 image)';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get openingHour => 'Opening Hour';

  @override
  String get closingHour => 'Closing Hour';

  @override
  String get to => 'to';

  @override
  String get mustContainAtLeastOneImage => 'Must contain at least one image';

  @override
  String get manageYourPetSlots => 'Manage Your Pet Slots';

  @override
  String get somethingIsWrongTryAgain => 'Something is wrong, please try again later';

  @override
  String get pricingModel => 'Pricing Model';

  @override
  String get dogs => 'Dogs';

  @override
  String get others => 'Others';

  @override
  String get acceptCats => 'Accept cats?';

  @override
  String get acceptBunnies => 'Accept bunnies?';

  @override
  String get choosePricingModel => 'Choose Pricing Model';

  @override
  String chargePer(String name) {
    return 'Charge per $name';
  }

  @override
  String get configureYourServices => 'Configure Your Services';

  @override
  String get groomingProvided => 'Grooming Provided';

  @override
  String get pickupProvided => 'Pickup Provided';

  @override
  String get dailyWalksProvided => 'Daily Walks Provided';

  @override
  String get dailyPlaytimeProvided => 'Daily Playtime Provided';

  @override
  String get passwordEmpty => 'Password cannot be empty';

  @override
  String get passwordTooShort => 'Password must contain at least 8 characters';

  @override
  String get fieldCannotBeEmpty => 'This field cannot be empty';

  @override
  String get priceEmpty => 'Price cannot be empty';

  @override
  String get priceMustBeGreaterThanZero => 'Price must be greater than 0';

  @override
  String get invalidSlotNumber => 'Enter a valid slot number';

  @override
  String get emailEmpty => 'Email cannot be empty';

  @override
  String get emailInvalid => 'Email is not valid';

  @override
  String get price => 'Price';

  @override
  String get numberOfSlots => '# of Slot';

  @override
  String perPricingModel(String pricingModel) {
    return 'per $pricingModel';
  }

  @override
  String get mustAcceptAtLeastOnePet => 'Must accept at least one pet';

  @override
  String get fetchAddressError => 'Something\'s wrong when fetching address';

  @override
  String get editDaycare => 'Edit Pet Daycare/Hotel';

  @override
  String get detailsTab => 'Details';

  @override
  String get imagesTab => 'Images';

  @override
  String get slotsTab => 'Slots';

  @override
  String get servicesTab => 'Services';

  @override
  String get invalidLocation => 'Invalid location';

  @override
  String get confirmDeleteVaccination => 'Are you sure you want to delete this vaccination record? This action cannot be undone.';

  @override
  String get noVaccinationRecord => 'There are no vaccination record for this pet.';

  @override
  String get operationSuccess => 'Operation completed successfully.';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get jwtExpired => 'Session expired';

  @override
  String get userDeleted => 'User has been deleted, please create a new account';

  @override
  String get bookingHistoryInfo => 'Your booking history shows here';

  @override
  String get failToLoadImage => 'Failed to load image';

  @override
  String get preferredLanguage => 'Preferred Language';

  @override
  String get choosePreferredLanguage => 'Choose Preferred Language';

  @override
  String get mustChooseOneVetSpecialty => 'Must choose at least one vet specialty';

  @override
  String get chooseVetSpecialties => 'Choose Vet Specialties';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get dataDoesNotExist => 'Data doesn\'t exist';

  @override
  String get petInfo => 'Pet Info';

  @override
  String get editPetDaycare => 'Edit Pet Daycare';

  @override
  String get editVaccinationRecord => 'Edit Vaccination Record';

  @override
  String get description => 'Description';

  @override
  String get addReview => 'Add Review';

  @override
  String get imageRequired => 'Image required';

  @override
  String get addVaccinationRecord => 'Add Vaccination Record';

  @override
  String get petOwnersMessageInfo => 'Pet owners who message you will show up here.';

  @override
  String get selectSpecialties => 'Select specialties';

  @override
  String ratePetDaycare(String petDaycareName) {
    return 'Rate $petDaycareName';
  }

  @override
  String get locationCannotBeEmpty => 'Please Set an Address';

  @override
  String get vaccinationImageRequired => 'Vaccination Record\'s Image Required';

  @override
  String get nextDueDateValidationError => 'Next Due date must be greater than the date administered';
}
