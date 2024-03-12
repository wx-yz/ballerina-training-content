import ballerina/http;

type Order record {
    string id;
    string status;
    // ...
};

service on new http:Listener(8080) {
    isolated resource function post r1(Order ord) {
        f1(ord.cloneReadOnly()); 
    }

    isolated resource function post r2(Order ord) {
        f2(ord); // invalid invocation of a non-isolated function in an 'isolated' function
                 // While `f2` can be inferred to be `isolated`, that is not enough here.
                 // has to be isolated explicitly.   
    }

    isolated resource function post r3(Order & readonly ord) {
        f3(ord);
    }
}

isolated function f1(Order & readonly ord) {
    string id = ord.id;
    // ... does not access module-level mutable state
    // Since `ord` is immutable, we know it cannot be updated here.
}

// implicitly final and the type is `map<string> & readonly`
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

isolated function f3(Order & readonly ord) {
    orderMap[ord.id.toString()] = ord; // invalid access of mutable storage in an 'isolated' function
    // Although the arguments are safe, the function accesses a mutable
    // module-level variable, which is not safe.
}

// //there may be valid requirements to access shared mutable state in a safe manner (e.g., appropriately using lock statements).
// isolated function f3(Order & readonly ord) {
//     lock {
//         orderMap[ord.id.toString()] = ord;
//         // OK now, since any and all access of `orderMap` happens within a lock statement
//     }
// }