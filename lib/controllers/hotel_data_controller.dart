import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/hotel_model.dart';
import '../repository/hotel_repository.dart';

part 'hotel_data_controller.g.dart';

@riverpod
class HotelDataController extends _$HotelDataController {
  @override
  Future<Hotel> build() async {
    final hotelRepo = ref.watch(hotelRepositoryProvider);
    return (await hotelRepo.getHotelList()).first;
  }

  void setSelectedHotel(Hotel hotel) => state = AsyncValue.data(hotel);
}
