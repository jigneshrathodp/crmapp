import 'package:flutter/material.dart';
import '../models/Order_model/get_order_model.dart';

class OrderListWidget extends StatefulWidget {
  final List<Data> orders;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  final Function(Data) onTap;

  const OrderListWidget({
    super.key,
    required this.orders,
    required this.onRefresh,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _searchQuery = '';

  List<Data> get _filtered {
    final q = _searchQuery.toLowerCase();
    return widget.orders.where((o) {
      return ('${o.orderId}').contains(q) ||
          (o.product?.name ?? '').toLowerCase().contains(q) ||
          (o.customer?.name ?? '').toLowerCase().contains(q) ||
          (o.customer?.phone ?? '').contains(q);
    }).toList();
  }

  List<Data> get _paged {
    final f = _filtered;
    final start = _currentPage * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, f.length);
    return f.sublist(start, end);
  }

  int get _totalPages => (_filtered.length / _rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final paged = _paged;
    final start = _currentPage * _rowsPerPage + 1;
    final end = _currentPage * _rowsPerPage + paged.length;

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: Column(
        children: [
          // ── Top Controls ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text('Show', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<int>(
                    value: _rowsPerPage,
                    underline: const SizedBox(),
                    items: [5, 10, 25, 50]
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _rowsPerPage = v!;
                      _currentPage = 0;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('entries', style: TextStyle(fontSize: 13)),
                const Spacer(),
                const Text('Search:', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 180,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (v) => setState(() {
                      _searchQuery = v;
                      _currentPage = 0;
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ── Table ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: paged.isEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 56, color: Colors.black26),
                                SizedBox(height: 12),
                                Text(
                                  'No Data Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.black87),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                    dataRowMinHeight: 70,
                    dataRowMaxHeight: 100,
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    dividerThickness: 1,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Product Image')),
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('Sub Total')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Shipping')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List.generate(paged.length, (i) {
                      final order = paged[i];
                      final globalIndex = _currentPage * _rowsPerPage + i + 1;
                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (s) => i.isEven ? Colors.white : Colors.grey.shade50,
                        ),
                        cells: [
                          // #
                          DataCell(Text(
                            '$globalIndex',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )),

                          // Order ID
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${order.orderId ?? 'N/A'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          )),

                          // Product Image
                          DataCell(Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: (order.product?.image != null &&
                                      order.product!.image!.isNotEmpty)
                                  ? Image.network(
                                      order.product!.image!,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => _cartPlaceholder(),
                                    )
                                  : _cartPlaceholder(),
                            ),
                          )),

                          // Product Name
                          DataCell(SizedBox(
                            width: 120,
                            child: Text(
                              order.product?.name ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )),

                          // Category
                          DataCell(Text(
                            order.product?.category ?? 'N/A',
                            style: const TextStyle(fontSize: 13),
                          )),

                          // Customer
                          DataCell(SizedBox(
                            width: 110,
                            child: Text(
                              order.customer?.name ?? 'N/A',
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),

                          // Phone
                          DataCell(Text(
                            order.customer?.phone ?? 'N/A',
                            style: const TextStyle(fontSize: 13),
                          )),

                          // Qty
                          DataCell(_priceBadge(
                            order.pricing?.quantity ?? 'N/A',
                            Colors.black87,
                          )),

                          // Sub Total
                          DataCell(_priceBadge(
                            '₹${order.pricing?.subTotal ?? 'N/A'}',
                            Colors.black54,
                          )),

                          // Total
                          DataCell(_priceBadge(
                            '₹${order.pricing?.totalPrice ?? 'N/A'}',
                            Colors.black87,
                          )),

                          // Shipping
                          DataCell(Text(
                            '₹${order.pricing?.shippingCost ?? 'N/A'}',
                            style: const TextStyle(fontSize: 13),
                          )),

                          // Action
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => widget.onTap(order),
                                icon: const Icon(Icons.visibility, color: Colors.black87, size: 20),
                                tooltip: 'View Detail',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                              IconButton(
                                onPressed: () => _confirmDelete(context, order),
                                icon: const Icon(Icons.delete, color: Colors.black54, size: 20),
                                tooltip: 'Delete',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                            ],
                          )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Text(
                  filtered.isEmpty
                      ? 'No entries found'
                      : 'Showing $start to $end of ${filtered.length} entries',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const Spacer(),
                _PaginationBar(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onPageChanged: (p) => setState(() => _currentPage = p),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartPlaceholder() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.shopping_cart_outlined, color: Colors.grey.shade400, size: 26),
    );
  }

  Widget _priceBadge(String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Data order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text('Are you sure you want to delete Order #${order.orderId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDelete(order.orderId!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Pagination ──────────────────────────────────────────────────────────────
class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PageBtn(
          label: 'Previous',
          enabled: currentPage > 0,
          onTap: () => onPageChanged(currentPage - 1),
        ),
        const SizedBox(width: 4),
        ...List.generate(totalPages.clamp(0, 5), (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _PageNumBtn(
            page: i,
            isActive: i == currentPage,
            onTap: () => onPageChanged(i),
          ),
        )),
        const SizedBox(width: 4),
        _PageBtn(
          label: 'Next',
          enabled: currentPage < totalPages - 1,
          onTap: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PageBtn({required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: Colors.grey.shade300),
        foregroundColor: Colors.black87,
        disabledForegroundColor: Colors.grey.shade400,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _PageNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumBtn({required this.page, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.transparent,
          border: Border.all(color: isActive ? Colors.black87 : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          '${page + 1}',
          style: TextStyle(
            fontSize: 13,
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
