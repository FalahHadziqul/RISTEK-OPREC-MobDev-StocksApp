import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final StockRepository stockRepository;

  StockCubit({required this.stockRepository}) : super(StockInitial());

  Future<void> loadTopGainers() async {
    emit(StockLoading());

    try {
      final stocks = await stockRepository.getTopGainers();
      emit(StockLoaded(stocks));
    } catch (e) {
      emit(StockError("Failed to fetch stocks: ${e.toString()}"));
    }
  }
}