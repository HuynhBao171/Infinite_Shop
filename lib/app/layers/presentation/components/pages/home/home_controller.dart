import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:infinite_shop/app/core_impl/local_storage/predefined_local_storage_key_list.dart';
import 'package:infinite_shop/app/layers/domain/entities/product.dart';
import 'package:infinite_shop/app/layers/domain/usecases/product/fetch_products_usecase.dart';
import 'package:infinite_shop/app/layers/domain/usecases/product/search_products_usecase.dart';
import 'package:infinite_shop/core/arch/domain/usecase/usecase_provider.dart';
import 'package:infinite_shop/core/arch/presentation/controller/base_controller.dart';
import 'package:infinite_shop/core/local_storage/local_storage_provider.dart';
import 'package:infinite_shop/core/reactive/dynamic_to_obs_data.dart';

/// Controller for the home page
class HomeController extends BaseController
    with LocalStorageProvider, UseCaseProvider {
  /// Home controller constructor
  HomeController() {
    _setupSearchController();
    _setupScrollListener();
    _setupConnectivityListener();
    _loadFavorites();
    _fetchInitialProducts();
  }

  // Constants
  static const int _pageSize = 20;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  // Controllers
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  // State variables
  final products = listenableStatus<List<Product>>([]);
  final isLoading = listenable<bool>(false);
  final hasError = listenable<bool>(false);
  final errorMessage = listenable<String>('');
  final hasReachedMax = listenable<bool>(false);
  final searchQuery = listenable<String>('');
  final favoriteProductIds = listenableStatus<List<String>>([]);

  // New state variables for improved UX
  final hasConnectivity = listenable<bool>(
    true,
  ); // Default to true until checked
  final hasPagingError = listenable<bool>(false);
  final pagingErrorMessage = listenable<String>('');

  // Connectivity subscription
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Private properties
  int _currentSkip = 0;
  Timer? _debounceTimer;

  @override
  FutureOr<void> onDispose() async {
    searchController.dispose();
    scrollController.dispose();
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
  }

  /// Set up search controller
  void _setupSearchController() {
    searchController.addListener(() {
      if (searchController.text != searchQuery.value) {
        setSearchQuery(searchController.text);
      }
    });
  }

  /// Set up connectivity listener to monitor network status
  void _setupConnectivityListener() {
    // Initial connectivity check
    Connectivity().checkConnectivity().then((result) {
      hasConnectivity.value = result != ConnectivityResult.none;
    });

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      final isConnected = result != ConnectivityResult.none;
      hasConnectivity.value = isConnected;

      // Retry loading if we regained connectivity and had an error
      if (isConnected && (hasError.value || products.value.isEmpty)) {
        retry();
      }
    });
  }

  // PRODUCT LIST FUNCTIONALITY

  /// Set up scroll controller listener
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
          !isLoading.value &&
          !hasReachedMax.value) {
        _loadMoreProducts();
      }
    });
  }

  /// Load favorites from local storage
  Future<void> _loadFavorites() async {
    try {
      final favoriteIds = localStorage.get(
        LocalStorageKeyPredefined.favoriteProducts,
      );

      if (favoriteIds != null) {
        favoriteProductIds.value = favoriteIds;
        _updateProductFavoriteStatus();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      await localStorage.put(
        LocalStorageKeyPredefined.favoriteProducts,
        favoriteProductIds.value,
      );
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  /// Update favorite status for all products
  void _updateProductFavoriteStatus() {
    // Convert list of string IDs to set of integers for faster lookup
    final favoriteIdsSet =
        favoriteProductIds.value
            .map((idStr) => int.tryParse(idStr))
            .where((id) => id != null)
            .toSet();

    final updatedProducts =
        products.value.map((product) {
          product.isFavorite = favoriteIdsSet.contains(product.id);
          return product;
        }).toList();

    products.value = updatedProducts;
  }

  /// Toggle favorite status for a product
  Future<void> toggleFavorite(Product product) async {
    final productIdStr = product.id.toString();
    final updatedFavorites = List<String>.from(favoriteProductIds.value);

    if (product.isFavorite) {
      // Remove from favorites
      updatedFavorites.remove(productIdStr);
      product.isFavorite = false;
    } else {
      // Add to favorites
      if (!updatedFavorites.contains(productIdStr)) {
        updatedFavorites.add(productIdStr);
      }
      product.isFavorite = true;
    }

    favoriteProductIds.value = updatedFavorites;

    // Update the products list to trigger UI refresh
    final updatedProducts = List<Product>.from(products.value);
    final index = updatedProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      updatedProducts[index] = product;
      products.value = updatedProducts;
    }

    await _saveFavorites();
  }

  /// Fetch initial products
  Future<void> _fetchInitialProducts() async {
    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;
    hasPagingError.value = false;
    _currentSkip = 0;

    // Check connectivity before attempting to fetch
    if (!hasConnectivity.value) {
      hasError.value = true;
      errorMessage.value =
          'No internet connection available. Please check your network settings.';
      isLoading.value = false;
      return;
    }

    try {
      final result = await usecase<FetchProductsUseCase>()
          .execute(
            FetchProductsUseCaseRequest(
              limit: _pageSize,
              skip: _currentSkip,
              search: searchQuery.value.isEmpty ? null : searchQuery.value,
            ),
          )
          .then((response) => response.products);

      if (result != null) {
        // Convert list of string IDs to set of integers for faster lookup
        final favoriteIdsSet =
            favoriteProductIds.value
                .map((idStr) => int.tryParse(idStr))
                .where((id) => id != null)
                .toSet();

        // Update favorite status
        final productsWithFavorites =
            result.map((product) {
              product.isFavorite = favoriteIdsSet.contains(product.id);
              return product;
            }).toList();

        products.value = productsWithFavorites;
        hasReachedMax.value = result.length < _pageSize;
        _currentSkip = result.length;
      } else {
        products.value = [];
        hasReachedMax.value = true;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load products: $e';
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more products
  Future<void> _loadMoreProducts() async {
    if (isLoading.value || hasReachedMax.value) return;

    isLoading.value = true;
    hasPagingError.value = false;

    // Check connectivity before attempting to load more
    if (!hasConnectivity.value) {
      hasPagingError.value = true;
      pagingErrorMessage.value = 'No internet connection available';
      isLoading.value = false;
      return;
    }

    try {
      final result = await usecase<FetchProductsUseCase>()
          .execute(
            FetchProductsUseCaseRequest(
              limit: _pageSize,
              skip: _currentSkip,
              search: searchQuery.value.isEmpty ? null : searchQuery.value,
            ),
          )
          .then((response) => response.products);

      if (result != null && result.isNotEmpty) {
        // Convert list of string IDs to set of integers for faster lookup
        final favoriteIdsSet =
            favoriteProductIds.value
                .map((idStr) => int.tryParse(idStr))
                .where((id) => id != null)
                .toSet();

        // Update favorite status
        final productsWithFavorites =
            result.map((product) {
              product.isFavorite = favoriteIdsSet.contains(product.id);
              return product;
            }).toList();

        // Append to existing products
        final updatedProducts = [...products.value, ...productsWithFavorites];
        products.value = updatedProducts;

        _currentSkip += result.length;
        hasReachedMax.value = result.length < _pageSize;
      } else {
        hasReachedMax.value = true;
      }
    } catch (e) {
      // Set paging error flag
      hasPagingError.value = true;
      pagingErrorMessage.value = 'Failed to load more products';
      debugPrint('Failed to load more products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry loading more products after a paging error
  void retryPaging() {
    if (hasPagingError.value) {
      hasPagingError.value = false;
      _loadMoreProducts();
    }
  }

  /// Search for products with debounce
  void setSearchQuery(String query) {
    searchQuery.value = query;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      if (query.isEmpty) {
        _fetchInitialProducts();
      } else {
        _searchProducts();
      }
    });
  }

  /// Reset search
  void resetSearch() {
    searchQuery.value = '';
    searchController.clear();
    _fetchInitialProducts();
  }

  /// Retry loading products
  void retry() {
    if (searchQuery.value.isEmpty) {
      _fetchInitialProducts();
    } else {
      _searchProducts();
    }
  }

  /// Search products
  Future<void> _searchProducts() async {
    if (isLoading.value || searchQuery.value.isEmpty) return;

    isLoading.value = true;
    hasError.value = false;
    hasPagingError.value = false;
    _currentSkip = 0;

    // Check connectivity before attempting to search
    if (!hasConnectivity.value) {
      hasError.value = true;
      errorMessage.value =
          'No internet connection available. Please check your network settings.';
      isLoading.value = false;
      return;
    }

    try {
      final result = await usecase<SearchProductsUseCase>()
          .execute(SearchProductsUseCaseRequest(query: searchQuery.value))
          .then((response) => response.products);

      if (result != null) {
        // Convert list of string IDs to set of integers for faster lookup
        final favoriteIdsSet =
            favoriteProductIds.value
                .map((idStr) => int.tryParse(idStr))
                .where((id) => id != null)
                .toSet();

        // Update favorite status
        final productsWithFavorites =
            result.map((product) {
              product.isFavorite = favoriteIdsSet.contains(product.id);
              return product;
            }).toList();

        products.value = productsWithFavorites;
        hasReachedMax.value = true; // Search API doesn't support pagination
      } else {
        products.value = [];
        hasReachedMax.value = true;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to search products: $e';
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
