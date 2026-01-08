class ItemDetailsStrings {
  static const String failedToLoad = 'Failed to load item.\n';
  static const String itemNotFound = 'Item not found';
  static const String noTitle = 'No Title';
  static const String description = 'Description';
  static const String currentHighestBid = 'Current Highest Bid';
  static const String price = 'Price';
  static const String currentBids = 'Current Bids';
  static const String offers = 'Offers';
  static const String placeBid = 'Place Bid';
  static const String editBid = 'Edit Bid';
  static const String editOffer = 'Edit Offer';
  static const String pendingOffer = 'Pending Offer';
  static const String yourItem = 'Manage Item';
  static const String currencySymbol = '₱';
  static const String auction = 'Auction';
  static const String tradeOnly = 'Trade Only';
  static const String cashOnly = 'Cash Only';
  static const String mixed = 'Mixed';
  static const String categoryPrefix = 'Category: ';
  static const String errorPrefix = 'Error fetching item details: ';
  static const String ownerDebugMsg = 'User is owner of this item';

  // New strings
  static const String placeYourBid = 'Place your Bid';
  static const String placeYourOffer = 'Place your Offer';
  static const String confirmBid = 'Confirm Bid';
  static const String submitOffer = 'Submit Offer';
  static const String reviewOffer = 'Review Offer';
  static const String submitFinalOffer = 'Submit Final Offer';
  static const String sellerLookingFor = 'Seller is looking for:';
  static const String currentOffers = 'Current Offers';
  static const String makeAnOffer = 'Make an Offer';
  static const String offerATrade = 'Offer a Trade';
  static const String noOffers = "No offers yet. Be the first!";
  static const String currentHighest = "Current Highest Bid";
  static const String miniMumBid = "Minimum Bid:";
  static const String placeATrade = "Place a Trade";
  static const String offerCombine ="Offer cash, trade an item, or combine both";
  static const String photos = "Photos";
  static const String addPhotos = "Add photos";
  static const String itemTitle =  "Item title";
  static const String condition =  "Condition";
  static const String cancel =  "Cancel";


  // Defaults
  static const String defaultCategory = 'General';
  static const String defaultCondition = 'Used';

  // Types
  static const String typeCash = 'cash';
  static const String typeTrade = 'trade';
  static const String typeMix = 'mix';
  
  // Table names
  static const String tableItems = 'items';
  static const String fieldProfiles = 'profiles';
  static const String fieldOffers = 'offers';

  //hint text
  static const String hint0 = '0';
  static const String hintTextTitle = "e.g. Nike Air Max";

  static const String hintTextCategory = "Select Category";
  //suffix
  static const String over3 = "/3";

  //Message
  static const String enterValidAmount = "Please enter a valid amount";
  static const String enterTitle = "Please enter item title";
  static const String enterCategory = "Please select a category";

  static const String confirmOffer =  "Confirm Offer?";
  static const String areYouSure = "Are you sure you want to submit this offer?";
  static const String pleaseLogin = "Please login to submit an offer";
  static const String failedSubmitOffer =   "Failed to submit offer";
  static const String errorSubmit =   "Error submitting offer";


  //condition
  static const String labelNew= "New";
  static const String labelFair= "Fair";
  static const String labelBroken = "Broken";
  static const String labelUsed = "Used";

  static const String yesSubmit= "Yes, Submit";
  static String getLoadingErrorMessage(String error) => '$failedToLoad $error';

  // Offer Status Modal Strings
  static const String whatHappensNext = "What happens next?";
  static const String offerSent = "Offer Sent";
  static const String offerSentSubtitle = "Seller received your proposal";
  static const String sellerReview = "Seller Review";
  static const String sellerReviewSubtitle = "They accept or reject your offer";
  static const String chatAndMeet = "Chat & Meet";
  static const String chatAndMeetSubtitle = "Details unlock upon acceptance";

  static const String statusUnderReview = "Under Review";
  static const String statusUnderReviewSubtitle = "Please wait for seller response";
  static const String statusAccepted = "Offer Accepted!";
  static const String statusAcceptedSubtitle = "You can now chat with the seller.";
  static const String statusRejected = "Offer Rejected";
  static const String statusRejectedSubtitle = "The seller declined this offer.";

  static const String labelYourItem = "Your Item";
  static const String labelSellerItem = "Seller Item";
  static const String labelCashOffer = "Cash Offer";
  static const String defaultItemName = "Item";
  static const String sellerPrefix = "Seller: @";

  static const String btnPending = "Pending";
  static const String btnDealChat = "Deal Chat";
  static const String btnRejected = "Rejected";
  static const String msgNavigatingChat = "Navigating to Chat...";
}
