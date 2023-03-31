abstract class UseCase {
  Map<String, dynamic> settings = {};

  /// method that is called by the state machine to execute use case
  String execute(String trigegr);

  /// method that triggers use case proactively
  void trigger();
}
