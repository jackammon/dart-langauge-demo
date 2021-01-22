// jammon17@georgefox.edu
// CSIS 420 Programing Languages
// Structured Information Sorter

import 'dart:io';

void main(List<String> arguments) {
    var dataFile;
    List<String> lines;
    List<Person> persons;

    if (arguments.isNotEmpty) {
        try {
            dataFile = File(arguments[0]);
        } catch (e) {
            printErrorMessage(e);
        }

        if (dataFile != null) {
            // process file into persons
            lines = dataFile.readAsLinesSync();

            try {
                persons = processLines(lines);
            } catch (e) {
                print(e);
            }

            if (persons != null) {
                // sort persons by their name
                persons.sort((a, b) => a.name.compareTo(b.name));
                printPersons(persons);
            }
        } else {
            printErrorMessage('provided field does not exist!');
        }
    } else {
        printErrorMessage('a file was not provided!');
    }
}

/// Prints the given error message [reason]
void printErrorMessage(String reason) {
    print('Error: $reason');
}

List<Person> processLines(List lines) {
    var personInformation;
    List<Person> persons = [];

    for (var line in lines) {
        personInformation = line.split(',');

        if (isInt(personInformation[1])) {
            persons
                .add(Person(personInformation[0],
                    int.parse(personInformation[1])));
        } else {
            throw Exception('invalid file data');
        }
    }

    return persons;
}

void printPersons(List<Person> persons) {
    var ages = 0;
    var count = 0;
    var avgAge;

    persons.forEach((person) {
        print(person.name);
        ages += person.age;
        count++;
    });
    avgAge = (ages / count);
    print('Avg age: ' + avgAge
        .toStringAsFixed(avgAge.truncateToDouble() == avgAge ? 0 : 2)
        .toString());
}

/// Checks if the given string [s] is an int
bool isInt(String s) {
    if (s == null) {
        return false;
    }
    return int.tryParse(s) != null;
}

/// A Person has a character string attribute called name and an integer attribute called age.
class Person {
    String name;
    int age;

    Person(this.name, this.age);
}
