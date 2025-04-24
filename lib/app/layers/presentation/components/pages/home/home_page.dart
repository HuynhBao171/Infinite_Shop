import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/presentation/components/pages/home/home_controller.dart';
import 'package:infinite_shop/app/layers/presentation/components/widgets/product/product_item.dart';
import 'package:infinite_shop/core/arch/presentation/controller/controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Page widget for the home feature
class HomePage extends StatelessWidget with ControllerProvider<HomeController> {
  /// Default constructor
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Shop', style: TextStyle(fontSize: 22)),
        elevation: 0,
        centerTitle: true,
        actions: [
          // Add network status indicator
          Observer(
            builder: (context) {
              if (ctrl.hasConnectivity.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(Icons.wifi_off_rounded, color: Colors.red[400]),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildSearchBar(ctrl),

              // Offline indicator banner when no connectivity
              Observer(
                builder: (context) {
                  if (!ctrl.hasConnectivity.value) {
                    return Container(
                      width: double.infinity,
                      color: Colors.red[100],
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 24.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            color: Colors.red[700],
                            size: 20,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'You are offline. Some features may not be available.',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Expanded(
                child: Observer(
                  builder: (context) {
                    if (ctrl.hasError.value) {
                      return _buildErrorView;
                    }

                    return Stack(
                      children: [
                        _buildProductsGrid(screenWidth),

                        Observer(
                          builder: (context) {
                            if (ctrl.isLoading.value &&
                                ctrl.products.value.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(HomeController ctrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 20.r),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: TextField(
            controller: ctrl.searchController,
            style: TextStyle(fontSize: 16),
            onChanged: (value) => ctrl.setSearchQuery(value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(fontSize: 16),
              prefixIcon: const Icon(Icons.search, size: 24),
              suffixIcon: Observer(
                builder: (context) {
                  return ctrl.searchQuery.value.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, size: 22),
                        onPressed: ctrl.resetSearch,
                      )
                      : const SizedBox.shrink();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(double screenWidth) => Builder(
    builder: (context) {
      final ctrl = controller(context);

      return Observer(
        builder: (context) {
          final products = ctrl.products.value;
          final isLoading = ctrl.isLoading.value;

          if (products.isEmpty && !isLoading) {
            return _buildEmptyView;
          }

          // Calculate number of columns based on screen width
          int crossAxisCount = _calculateColumnCount(screenWidth);

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                // Access the private method through a workaround - scrolling will trigger loading
                // The scroll controller already has a listener to load more products
                return true;
              }
              return false;
            },
            child: CustomScrollView(
              controller: ctrl.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(20.r),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 24.r,
                      crossAxisSpacing: 24.r,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];
                      return ProductItem(
                        key: ValueKey(
                          product.id,
                        ), // Added ValueKey for product identity
                        product: product,
                        onTap: () => _onProductTap(context, product),
                        onToggleFavorite: ctrl.toggleFavorite,
                      );
                    }, childCount: products.length),
                  ),
                ),

                // Show appropriate bottom widget based on state
                SliverToBoxAdapter(
                  child: Observer(
                    builder: (context) {
                      // Show loading indicator when loading more items
                      if (isLoading && products.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.r),
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      }

                      // Show paging error message if there was a paging error
                      if (ctrl.hasPagingError.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.orange[700],
                                  size: 28,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Failed to load more products',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton(
                                  onPressed: ctrl.retryPaging,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Show end of results message when user has seen all items
                      if (ctrl.hasReachedMax.value && products.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green[700],
                                  size: 28,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'You\'ve seen all products',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox(height: 40);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  /// Calculate the optimal number of columns based on screen width
  int _calculateColumnCount(double width) {
    if (width > 1600) return 6;
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    if (width > 400) return 2;
    return 1;
  }

  Widget get _buildEmptyView => Builder(
    builder: (context) {
      final ctrl = controller(context);

      return Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 120.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 32.h),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.h),
              Observer(
                builder: (context) {
                  final query = ctrl.searchQuery.value;
                  final hasConnectivity = ctrl.hasConnectivity.value;

                  if (!hasConnectivity) {
                    return Column(
                      children: [
                        Text(
                          'You\'re currently offline',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: ctrl.retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 16.h,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Text(
                    query.isEmpty
                        ? 'Try adding some products to your shop'
                        : 'Try a different search term',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  Widget get _buildErrorView => Builder(
    builder: (context) {
      final ctrl = controller(context);

      return Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 120.sp, color: Colors.red[300]),
              SizedBox(height: 32.h),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Observer(
                  builder: (context) {
                    return Text(
                      ctrl.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              SizedBox(height: 40.h),
              ElevatedButton.icon(
                onPressed: ctrl.retry,
                icon: const Icon(Icons.refresh, size: 24),
                label: const Text('Retry', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 20.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  void _onProductTap(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${product.title}',
          style: TextStyle(fontSize: 16),
        ),
        behavior: SnackBarBehavior.floating,
        width: 500,
        margin: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      ),
    );
  }
}
