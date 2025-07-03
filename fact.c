#include <stdio.h> // Include the standard input/output library

void fact() {
    int n; // Declare a variable to store the input number
    long long factorial = 1; // Declare a variable to store the factorial, initialized to 1.
                             // Use long long to handle larger factorial values.

    printf("Enter a non-negative integer: "); // Prompt the user for input
    scanf("%d", &n); // Read the integer entered by the user

    // Check for negative input
    if (n < 0) {
        printf("Factorial is not defined for negative numbers.\n");
    } 
    // Handle the special case of 0!
    else if (n == 0) {
        printf("Factorial of 0 is 1.\n");
    } 
    // Calculate factorial for positive integers
    else {
        for (int i = 1; i <= n; i++) { // Loop from 1 to n
            factorial *= i; // Multiply 'factorial' by the current loop variable 'i'
        }
        printf("Factorial of %d is %lld\n", n, factorial); // Print the result
    }

    // return 0; // Indicate successful program execution
}

