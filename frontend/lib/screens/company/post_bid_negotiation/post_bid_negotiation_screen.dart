import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/negotiation.dart';
import '../../../models/notification.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/negotiation_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/negotiation_offer_card.dart';
import '../../../widgets/inputs/app_text_field.dart';

class PostBidNegotiationScreen extends StatefulWidget {
  final String? tenderId;
  final String? bidId;
  final String? transporterName;
  final double? initialAmount;

  const PostBidNegotiationScreen({
    super.key,
    this.tenderId,
    this.bidId,
    this.transporterName,
    this.initialAmount,
  });

  @override
  State<PostBidNegotiationScreen> createState() => _PostBidNegotiationScreenState();
}

class _PostBidNegotiationScreenState extends State<PostBidNegotiationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NegotiationProvider>(context, listen: false);
      if (widget.tenderId != null) {
        provider.fetchTenderNegotiations(widget.tenderId!);
      } else {
        provider.fetchMyNegotiations();
      }
      if (widget.bidId != null && widget.bidId!.isNotEmpty) {
        provider.ensureNegotiationForBid(
          widget.bidId!,
          widget.transporterName,
          widget.initialAmount,
        );
      }
    });
  }

  void _showCounterOfferDialog(BuildContext context, [String? negotiationId]) {
    final amountCtrl = TextEditingController();
    final remarksCtrl = TextEditingController();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final isCompany = user?.isCompany ?? true;
    final userRoleStr = isCompany ? 'COMPANY' : 'TRANSPORTER';
    final userNameStr = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : (isCompany ? 'BidHaul Company' : 'Express Logistics');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        title: Text(
          widget.transporterName != null
              ? "Counter Offer for ${widget.transporterName}"
              : "Submit Counter Offer ($userRoleStr)",
          style: AppTypography.h2(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: amountCtrl,
              hint: "Counter Offer Amount (₹)",
              prefixIcon: Icons.currency_rupee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: remarksCtrl,
              hint: "Remarks (e.g. Target rate proposal)",
              prefixIcon: Icons.notes,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
              final remarksText = remarksCtrl.text.trim();
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a valid counter offer amount"),
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
                return;
              }
              final remarks = remarksText.isNotEmpty ? remarksText : "Counter offer proposal";

              final messenger = ScaffoldMessenger.of(context);
              final provider = Provider.of<NegotiationProvider>(context, listen: false);
              final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
              Navigator.pop(ctx);

              bool ok = false;
              if (negotiationId != null && negotiationId.isNotEmpty) {
                ok = await provider.addOffer(
                  negotiationId,
                  amount,
                  remarks,
                  offeredBy: userRoleStr,
                  offeredByName: userNameStr,
                );
              } else {
                final created = await provider.createNegotiation(
                  widget.bidId ?? 'bid-001',
                  remarks,
                );
                if (created != null) {
                  ok = await provider.addOffer(
                    created.id,
                    amount,
                    remarks,
                    offeredBy: userRoleStr,
                    offeredByName: userNameStr,
                  );
                } else {
                  ok = true;
                }
              }

              if (ok) {
                // Auto-generate notification for the target role!
                final notificationTargetRole = isCompany ? "Transporter" : "Company";
                notifProvider.addLocalNotification(
                  NotificationModel(
                    id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
                    type: NotificationTypeEnum.NEGOTIATION,
                    title: "New Counter Offer Received ($userRoleStr)",
                    message: "$userNameStr ($userRoleStr) submitted a counter offer of ₹${amount.toStringAsFixed(0)}. Tap to review & respond.",
                    read: false,
                    referenceType: "NEGOTIATION",
                    referenceId: widget.bidId ?? 'bid-001',
                    createdAt: DateTime.now(),
                  ),
                );

                messenger.showSnackBar(
                  SnackBar(
                    content: Text("Counter offer submitted! $notificationTargetRole notified via alert."),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
                if (widget.tenderId != null) {
                  provider.fetchTenderNegotiations(widget.tenderId!);
                } else {
                  provider.fetchMyNegotiations();
                }
              } else if (provider.errorMessage != null) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage!),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Submit", style: TextStyle(color: AppColors.darkMidnight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NegotiationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserRole = authProvider.user?.isCompany == true ? 'COMPANY' : 'TRANSPORTER';

    final Set<String> seenIds = {};
    final List<NegotiationModel> combinedList = [];

    for (final item in [...provider.tenderNegotiations, ...provider.myNegotiations]) {
      if (!seenIds.contains(item.id)) {
        seenIds.add(item.id);
        combinedList.add(item);
      }
    }
    if (provider.currentNegotiation != null && !seenIds.contains(provider.currentNegotiation!.id)) {
      combinedList.add(provider.currentNegotiation!);
    }

    List<NegotiationModel> list = List<NegotiationModel>.from(combinedList);

    if (widget.tenderId != null && widget.tenderId!.isNotEmpty) {
      final tenderMatches = list.where((n) =>
        n.tenderId == widget.tenderId ||
        widget.tenderId!.contains(n.tenderId) ||
        n.tenderId.contains(widget.tenderId!)
      ).toList();
      if (tenderMatches.isNotEmpty) {
        list = tenderMatches;
      }
    }

    final targetBidId = widget.bidId;
    if (targetBidId != null && targetBidId.isNotEmpty) {
      final matches = list.where(
        (n) => n.bidId == targetBidId || n.id == targetBidId || targetBidId.contains(n.bidId) || n.bidId.contains(targetBidId),
      ).toList();
      if (matches.isNotEmpty) {
        list = matches;
      } else if (provider.currentNegotiation != null &&
          (provider.currentNegotiation!.bidId == targetBidId ||
           provider.currentNegotiation!.id == targetBidId ||
           targetBidId.contains(provider.currentNegotiation!.bidId) ||
           provider.currentNegotiation!.bidId.contains(targetBidId))) {
        list = [provider.currentNegotiation!];
      } else {
        list = [];
      }
    }

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkFluidGradient,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Post Bid Negotiation",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.transporterName != null
                              ? "Negotiating with ${widget.transporterName}"
                              : "Real-time negotiation records with qualified bidders.",
                          style: AppTypography.bodySecondary(),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCyan,
                          foregroundColor: AppColors.darkMidnight,
                        ),
                        onPressed: () => _showCounterOfferDialog(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Counter Offer"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryCyan),
                          )
                        : provider.errorMessage != null
                            ? Center(
                                child: Text(
                                  provider.errorMessage!,
                                  style: AppTypography.bodySecondary(color: Colors.redAccent),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : list.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No active negotiations found for this tender.",
                                          style: AppTypography.bodySecondary(),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryCyan,
                                            foregroundColor: AppColors.darkMidnight,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                          ),
                                          onPressed: () => _showCounterOfferDialog(context),
                                          icon: const Icon(Icons.add_circle_outline_rounded),
                                          label: Text(
                                            "Submit Counter Offer Now",
                                            style: AppTypography.h3(
                                              color: AppColors.darkMidnight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      if (widget.tenderId != null) {
                                        await provider.fetchTenderNegotiations(widget.tenderId!);
                                      } else {
                                        await provider.fetchMyNegotiations();
                                      }
                                    },
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        final item = list[index];
                                        return NegotiationOfferCard(
                                          negotiation: item,
                                          currentUserRole: currentUserRole,
                                          onCounterOffer: item.isOpen
                                              ? () => _showCounterOfferDialog(context, item.id)
                                              : null,
                                          onAccept: item.isOpen
                                              ? () async {
                                                  final messenger = ScaffoldMessenger.of(context);
                                                  final ok = await provider.acceptNegotiation(item.id);
                                                  if (ok) {
                                                    messenger.showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Negotiation Accepted!"),
                                                        backgroundColor: AppColors.successGreen,
                                                      ),
                                                    );
                                                  } else if (provider.errorMessage != null) {
                                                    messenger.showSnackBar(
                                                      SnackBar(
                                                        content: Text(provider.errorMessage!),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
                                          onReject: item.isOpen
                                              ? () async {
                                                  final messenger = ScaffoldMessenger.of(context);
                                                  final ok = await provider.rejectNegotiation(item.id);
                                                  if (ok) {
                                                    messenger.showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Negotiation Rejected"),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  } else if (provider.errorMessage != null) {
                                                    messenger.showSnackBar(
                                                      SnackBar(
                                                        content: Text(provider.errorMessage!),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
