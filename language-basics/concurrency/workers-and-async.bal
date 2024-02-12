// bal run workers-and-async.bal -- 1 2 3 4
import ballerina/io;

public function main(int... ints) returns error? {
   // default-worker-init

   worker w returns int {
       int sum = 0;
       foreach int i in ints {
           sum += i;
       }
       return sum;
   }

   future<int> startFuture = start int:sum(...ints);
   future<int> workerFuture = w;

   int startSum = check wait startFuture;
   int workerSum = check wait workerFuture;

   io:println("Sum from start function: ", startSum);
   io:println("Sum from worker: ", workerSum);
}

