import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../models/invoice.dart';
import '../../../models/subscription_plan.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/invoice_provider.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../common/payment/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;
  final InvoiceModel? invoice;

  const PaymentScreen({
    super.key,
    required this.plan,
    this.invoice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _startPayment() async {
    final paymentProvider = context.read<PaymentProvider>();

    // Fetch invoice if not provided
    InvoiceModel? targetInvoice = widget.invoice;
    if (targetInvoice == null) {
      final invProvider = context.read<InvoiceProvider>();
      await invProvider.fetchMyInvoices();
      if (invProvider.myInvoices.isNotEmpty) {
        targetInvoice = invProvider.myInvoices.firstWhere(
          (inv) => inv.isPending,
          orElse: () => invProvider.myInvoices.first,
        );
      }
    }

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);

    if (targetInvoice == null || targetInvoice.id.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("No pending invoice found for this payment."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final order = await paymentProvider.createOrder(targetInvoice.id);
    if (!mounted) return;

    if (order == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(paymentProvider.errorMessage ?? "Failed to create payment order"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = context.read<AuthProvider>().user;

    var options = {
      'key': order.razorpayKeyId,
      'amount': order.amountInPaise,
      'name': 'BidHaul Logistics',
      'description': '${widget.plan.name} Subscription Payment',
      'order_id': order.razorpayOrderId,
      'prefill': {
        'contact': user?.phone ?? '',
        'email': user?.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      paymentProvider.handlePaymentFailed("Unable to launch Razorpay Checkout: $e");
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text("Unable to launch Razorpay Checkout: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final paymentProvider = context.read<PaymentProvider>();

    final invProvider = context.read<InvoiceProvider>();
    final targetInvoiceId = widget.invoice?.id ??
        (invProvider.myInvoices.isNotEmpty ? invProvider.myInvoices.first.id : '');

    final result = await paymentProvider.verifyPayment(
      invoiceId: targetInvoiceId,
      razorpayOrderId: response.orderId ?? '',
      razorpayPaymentId: response.paymentId ?? '',
      razorpaySignature: response.signature ?? '',
    );

    // Refresh state strictly from backend
    if (mounted) {
      await Future.wait([
        context.read<InvoiceProvider>().fetchMyInvoices(),
        context.read<SubscriptionProvider>().fetchSubscriptionStatus(),
      ]);
    }

    if (!mounted) return;

    if (result != null && result.isCaptured) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(plan: widget.plan),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentProvider.errorMessage ?? "Payment verification failed."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    final paymentProvider = context.read<PaymentProvider>();
    paymentProvider.handlePaymentFailed("Payment failed [${response.code}]: ${response.message}");

    if (mounted) {
      await Future.wait([
        context.read<InvoiceProvider>().fetchMyInvoices(),
        context.read<SubscriptionProvider>().fetchSubscriptionStatus(),
      ]);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Cancelled / Failed: ${response.message}"),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("External wallet selected: ${response.walletName}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Payment",
                          style: AppTypography.displayHero(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(widget.plan.name, style: AppTypography.h1()),
                  const SizedBox(height: AppSpacing.md),
                  Text("Amount", style: AppTypography.microBadge()),
                  Text(
                    "₹${widget.plan.monthlyPrice.toStringAsFixed(0)}",
                    style: AppTypography.h2(color: AppColors.primaryCyan),
                  ),
                  const Spacer(),
                  Consumer<PaymentProvider>(
                    builder: (context, paymentProvider, _) {
                      final isShutdown = paymentProvider.isGatewayShutdown;
                      return Column(
                        children: [
                          if (isShutdown) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.redAccent),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Payment Gateway is currently shutdown by Super Admin for system maintenance.",
                                      style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          PrimaryButton(
                            title: isShutdown
                                ? "Payment Gateway Paused"
                                : (paymentProvider.isLoading ? "Processing..." : "Pay Now (Razorpay)"),
                            onPressed: (paymentProvider.isLoading || isShutdown)
                                ? null
                                : () => _startPayment(),
                          ),
                        ],
                      );
                    },
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
