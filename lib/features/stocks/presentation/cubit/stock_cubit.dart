import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final StockRepository stockRepository;

  StockCubit({required this.stockRepository}) : super(StockInitial());

  Future<void> loadMarketMovers({bool forceRefresh = false}) async {
    final cachedAny = await stockRepository.getCachedMarketMovers(
      allowExpired: true,
    );

    if (cachedAny != null) {
      emit(
        StockLoaded(
          topGainers: cachedAny.topGainers,
          mostActivelyTraded: cachedAny.mostActivelyTraded,
          isRefreshing: true,
          isStaleData: true,
        ),
      );

      final cachedFresh = await stockRepository.getCachedMarketMovers();
      if (cachedFresh != null && !forceRefresh) {
        emit(
          StockLoaded(
            topGainers: cachedFresh.topGainers,
            mostActivelyTraded: cachedFresh.mostActivelyTraded,
            isRefreshing: false,
            isStaleData: false,
          ),
        );
        return;
      }

      try {
        final fresh = await stockRepository.refreshMarketMovers(
          force: forceRefresh,
        );
        emit(
          StockLoaded(
            topGainers: fresh.topGainers,
            mostActivelyTraded: fresh.mostActivelyTraded,
            isRefreshing: false,
            isStaleData: false,
          ),
        );
      } catch (_) {
        emit(
          StockLoaded(
            topGainers: cachedAny.topGainers,
            mostActivelyTraded: cachedAny.mostActivelyTraded,
            isRefreshing: false,
            isStaleData: true,
          ),
        );
      }
      return;
    }

    emit(StockLoading());

    try {
      final movers = await stockRepository.refreshMarketMovers(
        force: forceRefresh,
      );
      emit(
        StockLoaded(
          topGainers: movers.topGainers,
          mostActivelyTraded: movers.mostActivelyTraded,
          isRefreshing: false,
          isStaleData: false,
        ),
      );
    } catch (e) {
      emit(StockError("Failed to fetch stocks: ${e.toString()}"));
    }
  }

  Future<void> refreshMarketMovers() async {
    await loadMarketMovers(forceRefresh: true);
  }
}
