import '../models/invoice.dart';

final List<Invoice> dummyInvoices = [
  const Invoice(
    invoiceNo: "INV-1001",
    date: "01 Aug 2026",
    amount: 999,
    status: "Paid",
  ),
  const Invoice(
    invoiceNo: "INV-1000",
    date: "01 Jul 2026",
    amount: 999,
    status: "Paid",
  ),
  const Invoice(
    invoiceNo: "INV-0999",
    date: "01 Jun 2026",
    amount: 499,
    status: "Paid",
  ),
];