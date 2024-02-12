import ballerina/http;

enum OrderStatus {
    PENDING = "pending",
    IN_PROGRESS = "in progress",
    COMPLETED = "completed"
}

type Order record {|
    string username;
    string itemID;
    int quantity;

|};

map<Order> orders = {};
map<OrderStatus> orderStatus = {};
int orderId = 1000; // just for demonstration

service on new http:Listener(8080) {
    resource function post 'order(Order newOrder) returns http:Created|http:BadRequest? {
        // ...
        string orderId = nextOrderId(); // Accessing mutable state
        orders[orderId] = newOrder;     // Accessing mutable state
        orderStatus[orderId] = PENDING; // Accessing mutable state
        // ...
        return http:CREATED;
    }
}

function nextOrderId() returns string {
    int nextOrderId = orderId;
    orderId += 1;
    return nextOrderId.toString();
}