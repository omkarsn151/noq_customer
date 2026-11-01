/// Where the slot grid comes from and what Submit does with the selection.
/// The grid payload is identical either way; only the endpoints differ.
sealed class SlotSource {
  const SlotSource();
}

/// Booking a new visit from the cart at [businessId].
class CartSlotSource extends SlotSource {
  final String businessId;

  const CartSlotSource(this.businessId);
}

/// Moving existing booking [bookingId]. Duration and price come from the
/// booking's frozen services, not the cart.
class RescheduleSlotSource extends SlotSource {
  final String bookingId;

  const RescheduleSlotSource(this.bookingId);
}
