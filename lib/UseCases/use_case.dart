/// abstract class for use cases
/// use cases are triggered by the state machine
/// or proactively by the use case itself
abstract class UseCase {
  Map<String, dynamic> settings = {};

  /// method that is called by the state machine to execute use case
  void execute(String trigger);

  /// method that triggers use case proactively
  bool checkTrigger();
}
