// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get welcomeTo => 'Selamat datang di';

  @override
  String get punchLine => 'Cara lebih cerdas untuk menemukan penitipan hewan & terhubung dengan dokter hewan!';

  @override
  String get passwordInputLabel => 'Kata sandi';

  @override
  String get loginBtn => 'Login';

  @override
  String get createAnAccountBtn => 'Buat Akun';

  @override
  String get or => 'atau';

  @override
  String get petsTitle => 'Hewan Peliharaan';

  @override
  String petCategory(String category) {
    return 'Kategori hewan: $category';
  }

  @override
  String get editPetTooltip => 'Ubah data hewan';

  @override
  String get deletePetTooltip => 'Hapus data hewan';

  @override
  String get editPetInfoTitle => 'Ubah Informasi Hewan';

  @override
  String get nameLabel => 'Nama';

  @override
  String get petCategoryLabel => 'Kategori Hewan';

  @override
  String get spayedNeuteredLabel => 'Sudah di Sterilisasi';

  @override
  String get saveAddressButton => 'Simpan Alamat';

  @override
  String get nameEmptyError => 'Silakan masukkan Nama';

  @override
  String get petCategoryEmptyError => 'Silakan pilih Kategori Hewan';

  @override
  String get saveBtn => 'Simpan';

  @override
  String get petsNav => 'Hewan';

  @override
  String get exploreNav => 'Jelajah';

  @override
  String get vetsNav => 'Dokter Hewan';

  @override
  String get bookingsNav => 'Pemesanan';

  @override
  String get back => 'Kembali';

  @override
  String get petVaccination => 'Vaksinasi Hewan Peliharaan';

  @override
  String get requiresVaccination => 'Membutuhkan Vaksinasi';

  @override
  String get noRequiresVaccination => 'Tidak Membutuhkan Vaksinasi';

  @override
  String get distanceFilter => 'Jarak dalam kilometer (GPS dan izin lokasi harus diaktifkan)';

  @override
  String get distanceInfo => 'Untuk menonaktifkan penyaringan berdasarkan jarak, atur penggeser ke 0';

  @override
  String get maxDistanceInput => 'Jarak Maksimum';

  @override
  String get minDistanceInput => 'Jarak Minimum';

  @override
  String get priceRange => 'Rentang Harga';

  @override
  String get priceRangeInfo => 'Untuk menonaktifkan penyaringan berdasarkan rentang harga, atur penggeser ke 0';

  @override
  String get minPriceInput => 'Harga Maksimum';

  @override
  String get maxPriceInput => 'Harga Minimum';

  @override
  String get facilities => 'Fasilitas';

  @override
  String get messages => 'Pesan';

  @override
  String get pickupServiceProvided => 'Layanan Antar-Jemput Disediakan';

  @override
  String get inHouseFoodProvided => 'Makanan di Tempat Disediakan';

  @override
  String get groomingServiceProvided => 'Layanan Perawatan Disediakan';

  @override
  String get dailyWalks => 'Jalan-Jalan Harian';

  @override
  String get noWalksProvided => 'Tidak Menyediakan Jalan-Jalan';

  @override
  String get oneWalkADay => 'Satu Kali Jalan-Jalan per Hari';

  @override
  String get twoWalksADay => 'Dua Kali Jalan-Jalan per Hari';

  @override
  String get moreThanTwoWalksADay => 'Lebih dari Dua Kali Jalan-Jalan per Hari';

  @override
  String get dailyPlaytime => 'Waktu Bermain Harian';

  @override
  String get noPlaytimeProvided => 'Tidak Menyediakan Waktu Bermain';

  @override
  String get onePlaySessionADay => 'Satu Sesi Bermain per Hari';

  @override
  String get twoPlaySessionsADay => 'Dua Sesi Bermain per Hari';

  @override
  String get moreThanTwoPlaySessionsADay => 'Lebih dari Dua Sesi Bermain per Hari';

  @override
  String get applyFilter => 'Terapkan Filter';

  @override
  String get vetSpecialties => 'Spesialisasi Dokter Hewan';

  @override
  String get bookingHistory => 'Riwayat Pemesanan';

  @override
  String get cancelBookingConfirmation => 'Apakah Anda yakin ingin membatalkan pemesanan ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get cancelBooking => 'Batalkan Pemesanan';

  @override
  String get giveReview => 'Beri Ulasan';

  @override
  String get tapCardsToViewDetails => 'Ketuk kartu untuk melihat detail';

  @override
  String get deletePetConfirmation => 'Apakah Anda yakin ingin menghapus hewan peliharaan ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get confirmDeleteTitle => 'Konfirmasi Hapus';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get no => 'Tidak';

  @override
  String get yes => 'Ya';

  @override
  String specialtiesLabel(String vetSpecialtyNames) {
    return 'Spesialisasi: $vetSpecialtyNames';
  }

  @override
  String get accountSettings => 'Pengaturan Akun';

  @override
  String get editProfile => 'Ubah Profil';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get logout => 'Keluar Dari Akun';

  @override
  String get editUserProfile => 'Ubah Profil Pengguna';

  @override
  String get displayName => 'Nama Tampilan';

  @override
  String get bookingDetails => 'Detail Pemesanan';

  @override
  String get statusLabel => 'Status';

  @override
  String get reservationDates => 'Tanggal Reservasi';

  @override
  String get usePickupService => 'Gunakan Layanan Penjemputan';

  @override
  String get reservedPets => 'Hewan yang Dititipkan';

  @override
  String get pricings => 'Rincian Harga';

  @override
  String get total => 'Total';

  @override
  String get turnOnLocationMessage => 'Aktifkan lokasi untuk menemukan penitipan hewan terdekat';

  @override
  String get turnOn => 'Aktifkan';

  @override
  String get petDaycareBoarding => 'Penitipan Hewan';

  @override
  String kmAway(double range) {
    final intl.NumberFormat rangeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rangeString = rangeNumberFormat.format(range);

    return '${rangeString}km away';
  }

  @override
  String get operationalHour => 'Jam Operasional';

  @override
  String get requirements => 'Persyaratan';

  @override
  String get petVaccinationRequired => 'Wajib Vaksinasi Hewan';

  @override
  String get petVaccinationNotRequired => 'Vaksinasi Hewan Tidak Wajib';

  @override
  String get petVaccinationIsRequired => 'Vaksinasi hewan diperlukan untuk melakukan pemesanan';

  @override
  String get petVaccinationIsNotRequired => 'Hewan yang belum divaksinasi dapat melakukan pemesanan di tempat ini';

  @override
  String get additionalServices => 'Layanan Tambahan';

  @override
  String get groomingService => 'Layanan Grooming';

  @override
  String get serviceProvided => 'Layanan tersedia';

  @override
  String get serviceNotProvided => 'Layanan tidak tersedia';

  @override
  String get pickupService => 'Layanan Antar-Jemput';

  @override
  String get inHouseFoodProvidedDetails => 'Makanan Disediakan';

  @override
  String get numberOfWalks => 'Jumlah Jalan-jalan';

  @override
  String get numberOfPlaytime => 'Jumlah Waktu Bermain';

  @override
  String get viewReviews => 'Lihat Ulasan';

  @override
  String get bookSlot => 'Pesan Slot';

  @override
  String get slotsBooked => 'slot dipesan';

  @override
  String get reviewsTitle => 'Ulasan';

  @override
  String reviewsCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Ulasan';
  }

  @override
  String get pickPets => 'Pilih Hewan Peliharaan';

  @override
  String get chooseBookingDate => 'Pilih Tanggal Pemesanan';

  @override
  String get bookingDateLabel => 'Tanggal Pemesanan';

  @override
  String get bookSlotButton => 'Pesan Slot';

  @override
  String get chooseAddress => 'Pilih alamat';

  @override
  String get selectDateRange => 'Silakan pilih rentang tanggal yang tersedia';

  @override
  String get vaccinationRequired => 'Hewan peliharaan harus memiliki catatan vaksinasi yang valid dan terbaru';

  @override
  String get unsupportedPetCategory => 'Kategori hewan peliharaan tidak didukung';

  @override
  String get savedAddress => 'Alamat Tersimpan';

  @override
  String get notes => 'Catatan';

  @override
  String get selected => 'dipilih';

  @override
  String get deleteAddressConfirmation => 'Apakah Anda yakin ingin menghapus alamat ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get addAddress => 'Tambah Alamat';

  @override
  String get notesOptional => 'Catatan (opsional)';

  @override
  String get notesExample => 'contoh: Blok 3 No. 2';

  @override
  String get location => 'Nama Lokasi';

  @override
  String get address => 'Alamat';

  @override
  String get useCurrentLocation => 'Gunakan Lokasi Saat Ini';

  @override
  String get locationRequestDenied => 'Permintaan lokasi ditolak, silakan aktifkan lokasi di pengaturan';

  @override
  String get petDetails => 'Detail Hewan';

  @override
  String get vaccinationRecords => 'Catatan Vaksinasi';

  @override
  String ownerName(String name) {
    return 'pemilik: $name';
  }

  @override
  String get dateAdministered => 'Tanggal Vaksinasi';

  @override
  String get nextDueDate => 'Tanggal Jatuh Tempo';

  @override
  String get edit => 'Ubah';

  @override
  String petOwner(String ownerName) {
    return 'pemilik: $ownerName';
  }

  @override
  String get customers => 'Pelanggan';

  @override
  String get sortByPets => 'Hewan Peliharaan';

  @override
  String get sortByPetOwners => 'Pemilik Hewan';

  @override
  String get noBookedPets => 'Tidak ada hewan peliharaan yang dipesan';

  @override
  String get sendPhotoToOwner => 'Kirim Foto ke Pemilik Hewan';

  @override
  String get chatPetOwner => 'Chat Pemilik Hewan';

  @override
  String get noBookedPetOwners => 'Tidak ada pemilik hewan yang melakukan pemesanan';

  @override
  String get accept => 'Terima';

  @override
  String get reject => 'Tolak';

  @override
  String get pickupRequired => 'Penjemputan diperlukan';

  @override
  String get pickupNotRequired => 'Penjemputan tidak diperlukan';

  @override
  String get rejectRequest => 'Tolak Pemesanan';

  @override
  String get rejectRequestConfirmation => 'Apakah Anda yakin ingin menolak pemesanan ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get bookingQueue => 'Antrian Pemesanan';

  @override
  String get myPetDaycare => 'Tempat Penitipan Saya';

  @override
  String get setupAccountTitle => 'Mari Buat Akun Anda';

  @override
  String get setupAccountSubtitle => 'Masukkan data diri Anda untuk melanjutkan ke tahap berikutnya';

  @override
  String get passwordRequirement => 'Harus terdiri dari minimal 8 karakter';

  @override
  String get next => 'Lanjut';

  @override
  String get signupTitle => 'Bergabung dengan Komunitas Penitipan Hewan Kami!';

  @override
  String get signupSubtitle => 'Pilih peran Anda untuk memulai:';

  @override
  String get rolePetOwner => 'Pemilik Hewan';

  @override
  String get rolePetOwnerDesc => 'Temukan penitipan hewan terpercaya & ngobrol dengan dokter hewan.';

  @override
  String get roleProvider => 'Penyedia Penitipan Hewan';

  @override
  String get roleProviderDesc => 'Terhubung dengan pemilik hewan & kembangkan bisnis Anda.';

  @override
  String get roleVet => 'Dokter Hewan';

  @override
  String get roleVetDesc => 'Beri perawatan dan panduan ahli untuk pemilik hewan.';

  @override
  String get addPet => 'Tambah Hewan';

  @override
  String get vaccinationRecordOptional => 'Catatan Vaksinasi (Opsional)';

  @override
  String get fillPetInfo => 'Isi Informasi Hewan';

  @override
  String get choosePetCategory => 'Pilih kategori hewan';

  @override
  String get enterPetDetails => 'Masukkan detail hewan peliharaan Anda untuk melanjutkan ke tahap berikutnya';

  @override
  String get addVaccinationRecordOptional => 'Tambahkan catatan vaksinasi hewan peliharaan Anda (langkah ini opsional)';

  @override
  String get createMyAccount => 'Buat Akun Saya';

  @override
  String get skip => 'Lewati';

  @override
  String get creatingYourAccount => 'Membuat Akun';

  @override
  String get clickToAddVaccinePhoto => 'Klik untuk menambahkan foto buku vaksinasi';

  @override
  String get enterPetDaycareDetails => 'Masukkan detail tempat penitipan/hotel hewan peliharaan Anda untuk melanjutkan';

  @override
  String get petDaycareName => 'Nama Tempat Penitipan Hewan';

  @override
  String get descriptionOptional => 'Deskripsi (opsional)';

  @override
  String get addPetDaycareImages => 'Tambahkan gambar tempat penitipan hewan Anda (min. 1 gambar)';

  @override
  String get operatingHours => 'Jam Operasional';

  @override
  String get openingHour => 'Jam Buka';

  @override
  String get closingHour => 'Jam Tutup';

  @override
  String get to => 'sampai';

  @override
  String get mustContainAtLeastOneImage => 'Harus ada setidaknya satu gambar';

  @override
  String get manageYourPetSlots => 'Kelola Slot';

  @override
  String get somethingIsWrongTryAgain => 'Terjadi kesalahan, silakan coba lagi nanti';

  @override
  String get pricingModel => 'Model Harga';

  @override
  String get dogs => 'Anjing';

  @override
  String get others => 'Lainnya';

  @override
  String get acceptCats => 'Menerima kucing?';

  @override
  String get acceptBunnies => 'Menerima kelinci?';

  @override
  String get choosePricingModel => 'Pilih Model Harga';

  @override
  String chargePer(String name) {
    return 'Biaya per $name';
  }

  @override
  String get configureYourServices => 'Konfigurasi Layanan Anda';

  @override
  String get groomingProvided => 'Layanan Grooming Tersedia';

  @override
  String get pickupProvided => 'Layanan Penjemputan Tersedia';

  @override
  String get dailyWalksProvided => 'Jalan-jalan Harian';

  @override
  String get dailyPlaytimeProvided => 'Waktu Bermain Harian';

  @override
  String get passwordEmpty => 'Kata sandi tidak boleh kosong';

  @override
  String get passwordTooShort => 'Kata sandi harus memiliki minimal 8 karakter';

  @override
  String get fieldCannotBeEmpty => 'Bagian ini tidak boleh kosong';

  @override
  String get priceEmpty => 'Harga tidak boleh kosong';

  @override
  String get priceMustBeGreaterThanZero => 'Harga harus lebih dari 0';

  @override
  String get invalidSlotNumber => 'Masukkan jumlah slot yang valid';

  @override
  String get emailEmpty => 'Email tidak boleh kosong';

  @override
  String get emailInvalid => 'Format email tidak valid';

  @override
  String get price => 'Harga';

  @override
  String get numberOfSlots => 'Jumlah Slot';

  @override
  String perPricingModel(String pricingModel) {
    return 'per $pricingModel';
  }

  @override
  String get mustAcceptAtLeastOnePet => 'Harus menerima setidaknya satu jenis hewan';

  @override
  String get fetchAddressError => 'Terjadi kesalahan saat mengambil alamat';

  @override
  String get editDaycare => 'Edit Penitipan';

  @override
  String get detailsTab => 'Detail';

  @override
  String get imagesTab => 'Gambar';

  @override
  String get slotsTab => 'Slot';

  @override
  String get servicesTab => 'Layanan';

  @override
  String get invalidLocation => 'Lokasi tidak valid';

  @override
  String get confirmDeleteVaccination => 'Apakah Anda yakin ingin menghapus catatan vaksinasi ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get noVaccinationRecord => 'Tidak ada catatan vaksinasi untuk hewan peliharaan ini.';

  @override
  String get operationSuccess => 'Tindakan berhasil diselesaikan.';

  @override
  String get unknownError => 'Kesalahan tidak diketahui';

  @override
  String get jwtExpired => 'Sesi telah berakhir';

  @override
  String get userDeleted => 'Pengguna telah dihapus, silakan buat akun baru';

  @override
  String get bookingHistoryInfo => 'Riwayat pemesanan Anda akan muncul di sini';

  @override
  String get failToLoadImage => 'Gagal memuat gambar';

  @override
  String get preferredLanguage => 'Bahasa Pilihan';

  @override
  String get choosePreferredLanguage => 'Pilih Bahasa Pilihan';

  @override
  String get mustChooseOneVetSpecialty => 'Harus memilih setidaknya satu spesialisasi dokter hewan';

  @override
  String get chooseVetSpecialties => 'Pilih Spesialisasi Dokter Hewan';

  @override
  String get invalidEmailOrPassword => 'Email atau kata sandi salah';

  @override
  String get dataDoesNotExist => 'Data tidak ditemukan';

  @override
  String get petInfo => 'Info Hewan';

  @override
  String get editPetDaycare => 'Edit Penitipan Hewan';

  @override
  String get editVaccinationRecord => 'Edit Catatan Vaksinasi';

  @override
  String get description => 'Deskripsi';

  @override
  String get addReview => 'Tambah Ulasan';

  @override
  String get imageRequired => 'Gambar diperlukan';

  @override
  String get addVaccinationRecord => 'Tambah Catatan Vaksinasi';

  @override
  String get petOwnersMessageInfo => 'Pemilik hewan yang mengirim pesan akan muncul di sini.';

  @override
  String get selectSpecialties => 'Pilih spesialisasi';

  @override
  String ratePetDaycare(String petDaycareName) {
    return 'Ulas $petDaycareName';
  }

  @override
  String get locationCannotBeEmpty => 'Anda Belum Memilih Alamat';
}
