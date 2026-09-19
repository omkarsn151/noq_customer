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

  //====================Business====================
  static const String getBusinessList = "v1/customer/businesses";

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
}
