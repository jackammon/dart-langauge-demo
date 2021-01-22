// jammon17@georgefox.edu
// CSIS 420 Programing Languages
// n!

void main(List<String> arguments) {
    /// The string input from the command-line
    var input;

    if (arguments.isNotEmpty) {
        input = arguments[0];

        if (isInt(input)) {
            print(factorial(int.parse(input)));
        } else {
            printErrorMessage('an integer was not provided!');
        }
    } else {
        printErrorMessage('no input was provided!');
    }
}

/// Recursively finds factorial of [n]
int factorial(int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

/// Checks if the given string [s] is an int
bool isInt(String s) {
    if (s == null) {
        return false;
    }
    return int.tryParse(s) != null;
}

/// Prints the given error message [reason]
void printErrorMessage(String reason) {
    print('Error: $reason');
}