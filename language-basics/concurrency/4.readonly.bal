public function main() {

    //Immutable value
    // readonly means the value cannot be changed, but the reference can be changed
    int[] & readonly arr1 = [1,2,3]; 
    arr1[0] = 10; // cannot update 'readonly' value 
    arr1 = [1,2]; // OK

    readonly & int[] arr2 = [1,2,3]; 
    arr2[0] = 10; // cannot update 'readonly' value 
    arr2 = [1,2]; // OK

    // Final means the reference cannot be changed, but the value can be changed
    final int[] b = [];
    b[0] = 1; // OK
    b = [1]; // cannot assign a value to final 'b'

    // // Final and readonly means both the reference and the value cannot be changed
    final int[] & readonly c = [];
    c[0] = 1; // cannot update 'readonly' value    
    c = [1]; // cannot assign a value to final 'c'
}
