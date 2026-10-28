class ApiEndpoints {
  ApiEndpoints._();

  static const String baseurl = "http://3.111.20.58/api/";

  //====================Auth====================

  //request-otp
  static const String requestOtp = "v1/customer/auth/otp/request";

  //verify-otp
  static const String verifyOtp = "v1/customer/auth/otp/verify";

  //refresh-token
  static const String refreshToken = "v1/customer/auth/token/refresh";

  //update-name
  static const String updateName = "v1/customer/auth/profile";

  //====================Uplaod====================

  static const String upload = "v1/uploads";

  static const String deleteUpload = "v1/uploads/";

  //====================Business Details====================
  static const String getBusinessDetails = "v1/customer/businesses";

  //====================Cart====================
  static const String addToCart = "v1/customer/cart/items";

  static const String getCartItems = "v1/customer/cart";

  static const String removeCartItem = "v1/customer/cart/items";

  //====================Slots====================
  static const String getSlots = "v1/customer/businesses";

  //====================Bookings====================
  static const String getBookingsList = "v1/customer/bookings";

  static const String createBooking = "v1/customer/bookings";

  // + "/{booking_id}"
  static const String getBookingDetails = "v1/customer/bookings";

  //====================Promo Code====================
  static const String getPromoCodes = "v1/customer/cart/promos";
  static const String applyPromoCode = "v1/customer/cart/promo";
  static const String removePromoCode = "v1/customer/cart/promo";

  //====================Businesses====================
  static const String getBusinesses = "v1/customer/businesses";

  //====================Categories====================
  static const String getCategories = "v1/categories";

  //====================Home====================
  static const String customerHome = "v1/customer/home";

  //====================Favorites====================
  static const String favorites = "v1/customer/favorites";
}
