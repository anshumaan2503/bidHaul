import '../models/invoice.dart';

final List<InvoiceModel> dummyInvoices = [
  InvoiceModel(
    id: 'dummy-inv-1',
    invoiceNo: "INV-1001",
    userId: 'dummy-user',
    subscriptionId: 'dummy-sub-1',
    planName: 'Starter Freight Plan',
    date: "01 Aug 2026",
    amount: 999.0,
    status: "PAID",
  ),
  InvoiceModel(
    id: 'dummy-inv-2',
    invoiceNo: "INV-1000",
    userId: 'dummy-user',
    subscriptionId: 'dummy-sub-2',
    planName: 'Starter Freight Plan',
    date: "01 Jul 2026",
    amount: 999.0,
    status: "PAID",
  ),
  InvoiceModel(
    id: 'dummy-inv-3',
    invoiceNo: "INV-0999",
    userId: 'dummy-user',
    subscriptionId: 'dummy-sub-3',
    planName: 'Starter Freight Plan',
    date: "01 Jun 2026",
    amount: 499.0,
    status: "PAID",
  ),
];