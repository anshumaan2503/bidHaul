import '../models/negotiation_offer.dart';

final List<NegotiationOffer> dummyNegotiationOffers = [
  const NegotiationOffer(
    transporter: "ABC Logistics",
    initialBid: 42000,
    currentOffer: 41800,
    isAccepted: false,
  ),
  const NegotiationOffer(
    transporter: "BlueLine Cargo",
    initialBid: 42500,
    currentOffer: 42100,
    isAccepted: false,
  ),
  const NegotiationOffer(
    transporter: "SpeedX Logistics",
    initialBid: 43000,
    currentOffer: 42500,
    isAccepted: false,
  ),
  const NegotiationOffer(
    transporter: "Rapid Movers",
    initialBid: 43400,
    currentOffer: 43000,
    isAccepted: false,
  ),
  const NegotiationOffer(
    transporter: "Fast Freight",
    initialBid: 43800,
    currentOffer: 43400,
    isAccepted: false,
  ),
];