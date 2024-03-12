import ballerina/io;

// Has two parameters of type `int`.
// The `returns` clause specifies the type of the return value.
function add(int x, int y) returns int {
    // x = 5; //DO: ERROR : parameters are final
    int sum = x + y;
    return sum;
}

// The function parameters can have default values.
// function calculateWeight(decimal mass, decimal gForce = 9.8) returns decimal {
//     return mass * gForce;
// }

function calculateWeight(decimal mass, decimal gForce = 9.8) {
    io:println(mass * gForce);
}

// The function returns `nil`. DO:returns ()
function print(anydata data) {
    io:println(data);
}

function sum(int... numbers) returns int {
    int sum = 0;
    foreach int num in numbers {
        sum += num;
    }
    return sum;
}

public function main() {
    // Invoke the function `add` by passing the arguments.
    int total = add(5, 11);
    // A function with no return type does not need a variable assignment.
    print(total);

    // Invoke the `calculateWeight` function with the default arguments.
    print(calculateWeight(5));

    // Invoke the `add` function with the named arguments.
    print(add(x = 5, y = 6));

    // The return value of the function can be ignored by assigning it to `_`.
    _ = calculateWeight(mass = 5, gForce = 10);

    // Invoke the `sum` function with a variable number of arguments.
    print(sum(1, 2));
    print(sum(1, 2, 3, 4, 5));
}
