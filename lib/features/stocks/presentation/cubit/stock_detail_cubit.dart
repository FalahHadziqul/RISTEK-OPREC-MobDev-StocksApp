import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_detail.dart';
import '../../domain/repositories/stock_repository.dart';

part 'stock_detail_state.dart';

class StockDetailCubit extends Cubit<StockDetailState> {
  final StockRepository stockRepository;

  StockDetailCubit({required this.stockRepository})
    : super(StockDetailInitial());

  Future<void> loadStockDetail(String symbol) async {
    emit(StockDetailLoading());

    try {
      final detail = await stockRepository.getStockDetail(symbol);
      emit(StockDetailLoaded(detail));
    } catch (e) {
      emit(StockDetailError('Failed to load details: ${e.toString()}'));
    }
  }
}
