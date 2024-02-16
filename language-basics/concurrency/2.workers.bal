// bal run isolated.bal -- 1 2 3 4
import ballerina/io;

public function main(int... ints) returns error? {
  // Code before any named workers are executed before named workers start.
   io:println("Initializing");
   final string greeting = "Hello";

  worker w returns int {
      int sum = 0;
      foreach int i in ints {
          sum += i;
      }
      return sum;
  }
  future<int> workerFuture = w;
  int workerSum = check wait workerFuture;

  io:println("Sum from worker: ", workerSum);
}
