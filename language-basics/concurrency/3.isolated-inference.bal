import ballerina/http;
 
type Order record {
    string id;
    string status;
    // ...
};

service on new http:Listener(8080) {
    resource function post r1(Order ord) { //This resource will be inferred as isolated
        f1(ord.cloneReadOnly()); 
    }

    resource function post r2(Order ord) { //This resource will be inferred as isolated
        f2(ord);
    }

    resource function post r3(Order & readonly ord) { //This resource will NOT be inferred as isolated
        f3(ord);
    }
}

function f1(Order & readonly ord) {
    string id = ord.id;
    // ... does not access module-level mutable state
    // Since `ord` is immutable, we know it cannot be updated here.
}

// Configurables ae implicitly final and the type is `map<string> & readonly`
configurable map<string> statusKeys = {
    pending: "Pending",
    in\-progress: "In Progress",
    completed: "Completed"
};

function f2(Order ord) {
    string id = ord.id;
    // Safe as long as the caller guarantees exclusive access to `ord`
    // until this function completes.
    // Accessing `statusKeys` is OK since it is implictly final and immutable.
    ord.status = statusKeys.get("in-progress");
    // ... does not access module-level mutable state
}

map<Order> orderMap = {};

function f3(Order & readonly ord) {
    orderMap[ord.id.toString()] = ord;
    // Although the arguments are safe, the function accesses a mutable
    // module-level variable, which is not safe.
}