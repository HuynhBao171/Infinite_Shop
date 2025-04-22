import 'package:infinite_shop/core/di/injectable.dart';

/// The base use case class that defines the contract for executing a use case.
///
/// A use case represents a specific task or operation in the application.
/// It takes a request object as input and returns a response object as output.
/// Implementations of this class should provide the logic to run the use case.
abstract class BaseUseCase<Request, Response> implements Injectable {
  /// Executes the use case with the given [request] object.
  ///
  /// Returns a [Future] that completes with the [Response] object.
  Future<Response> execute(Request request);
}
