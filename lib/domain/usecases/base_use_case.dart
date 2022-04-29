abstract class BaseUseCase<TResult, TParams> {
  Future<TResult> execute(TParams params);
}