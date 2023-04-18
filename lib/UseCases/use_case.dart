/// abstract class for use cases
/// use cases are triggered by the state machine
/// or proactively by the use case itself
abstract class UseCase {
  /// method that is called by the state machine to execute use case
  void execute(String trigger);
}
