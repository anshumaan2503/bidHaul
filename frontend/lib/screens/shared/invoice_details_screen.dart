import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/invoice.dart';
import '../../providers/auth_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/app_status_badge.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoiceId,
  });

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late Razorpay _razorpay;
  InvoiceModel? _activePaymentInvoice;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInvoice();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadInvoice() async {
    await context.read<InvoiceProvider>().fetchInvoice(widget.invoiceId);
  }

  Future<void> _startPayment(InvoiceModel invoice) async {
    _activePaymentInvoice = invoice;
    final paymentProvider = context.read<PaymentProvider>();

    final order = await paymentProvider.createOrder(invoice.id);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);

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
      'description': 'Invoice #${invoice.invoiceNo.isNotEmpty ? invoice.invoiceNo : invoice.id}',
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
    final invoice = _activePaymentInvoice;
    if (invoice == null) return;

    final paymentProvider = context.read<PaymentProvider>();

    final result = await paymentProvider.verifyPayment(
      invoiceId: invoice.id,
      razorpayOrderId: response.orderId ?? '',
      razorpayPaymentId: response.paymentId ?? '',
      razorpaySignature: response.signature ?? '',
    );

    // Refresh state strictly from backend
    if (mounted) {
      await Future.wait([
        context.read<InvoiceProvider>().fetchInvoice(invoice.id),
        context.read<InvoiceProvider>().fetchMyInvoices(),
        context.read<SubscriptionProvider>().fetchSubscriptionStatus(),
      ]);
    }

    if (!mounted) return;

    if (result != null && result.isCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment verified successfully! Invoice settled & Subscription active."),
          backgroundColor: AppColors.successGreen,
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
        _loadInvoice(),
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
      appBar: AppBar(
        title: const Text("Invoice Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.selectedInvoice == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoice = provider.selectedInvoice;
          if (invoice == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? "Invoice details not found",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadInvoice,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadInvoice,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice Card Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassBorderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "INVOICE NUMBER",
                              style: AppTypography.microBadge(),
                            ),
                            AppStatusBadge(status: invoice.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          invoice.invoiceNo.isNotEmpty ? invoice.invoiceNo : invoice.id,
                          style: AppTypography.h1(color: AppColors.primaryCyan),
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _infoRow("Plan Name", invoice.planName.isNotEmpty ? invoice.planName : "Subscription Plan"),
                        _infoRow("Amount", "₹${invoice.amount.toStringAsFixed(2)}"),
                        if (invoice.billingPeriod != null)
                          _infoRow("Billing Period", invoice.billingPeriod!),
                        if (invoice.date != null)
                          _infoRow("Issued Date", invoice.date!.length >= 10 ? invoice.date!.substring(0, 10) : invoice.date!),
                        if (invoice.dueDate != null)
                          _infoRow("Due Date", invoice.dueDate!.length >= 10 ? invoice.dueDate!.substring(0, 10) : invoice.dueDate!),
                        if (invoice.paidAt != null)
                          _infoRow("Paid Date", invoice.paidAt!.length >= 10 ? invoice.paidAt!.substring(0, 10) : invoice.paidAt!),
                        if (invoice.paymentOrderReference != null)
                          _infoRow("Order Ref", invoice.paymentOrderReference!),
                        if (invoice.paymentReference != null)
                          _infoRow("Payment Ref", invoice.paymentReference!),
                        _infoRow("Subscription ID", invoice.subscriptionId),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.primaryCyan),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            invoice.isPaid
                                ? "This invoice has been fully settled."
                                : "Invoice is currently ${invoice.status.toUpperCase()}. Tap Pay Now to complete Razorpay payment.",
                            style: AppTypography.bodySecondary(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (!invoice.isPaid)
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
                                  : () => _startPayment(invoice),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
