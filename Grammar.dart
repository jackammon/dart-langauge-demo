// jammon17@georgefox.edu
// CSIS 420 Programing Languages
// Grammar

import 'dart:collection';
import 'dart:io';
import 'dart:math';


void main(List<String> arguments) {

    Grammar grammar;
    var dataFile;
    var start;
    var map;
    var queue;
    var random;

    if (arguments.isNotEmpty) {
        try {
            dataFile = File(arguments[0]);
            grammar = Grammar(dataFile.readAsStringSync());
        } catch (e) {
            print(e);
        }

        start = grammar.startSymbol;
        map = grammar.symbolTable;
        queue = Queue<Symbol>();
        random = Random();

        queue.addFirst(start);

        while(queue.isNotEmpty) {

            var token = queue.removeFirst();

            if (token.isNonTerminal()) {

                List<List<Symbol>> outerList = map[token];

                var innerList = outerList[random.nextInt(outerList.length)];

                for (var i = innerList.length - 1; i >= 0; i--) {
                    queue.addFirst(innerList[i]);
                }
            }
            else {
                stdout.write(token._value + ' ');
            }
        }
    }
    else {
        print('Error: No file was provided!');
    }
}

class Grammar {

    Symbol startSymbol;
    var symbolTable;

    Grammar(String input) {

        final START_TOKEN = '{';
        final END_TOKEN = '}';
        final BODY_END = ';';

        symbolTable = <Symbol, List<List<Symbol>>>{};

        List<Symbol> symbolList = [];

        var readingAProduction = false;
        var readingBodies = false;

        Symbol leftHandSideSymbol;
        String currentSymbol;

        var tokenizedInput = [];

        tokenizedInput = input.split(RegExp('\\s+'));

        var itr = tokenizedInput.iterator;

        while(itr.moveNext()) {
            currentSymbol = itr.current;

            if (!readingAProduction) {
                readingAProduction = (currentSymbol == START_TOKEN);
            }
            else if (currentSymbol == END_TOKEN) {
                readingAProduction = false;
                readingBodies = false;
            }
            else {

                if(!readingBodies) {
                    leftHandSideSymbol = Symbol((currentSymbol));

                    symbolTable[leftHandSideSymbol] = <List<Symbol>>[];

                    readingBodies = true;

                    // if startSymbol is not null then set it to leftHandSideSymbol
                    startSymbol ??= leftHandSideSymbol;
                }
                else {
                    if (currentSymbol == BODY_END) {
                        symbolTable[leftHandSideSymbol].add(symbolList);

                        symbolList = <Symbol>[];
                    }
                    else {
                        if (currentSymbol == '\\n') {
                            symbolList.add(Symbol('\n'));
                        }
                        else {
                            symbolList.add(Symbol(currentSymbol));
                        }
                    }
                }
            }
        }
    }
}

/// Simple class representing terminal and non-terminal grammar symbols
class Symbol {

    final RegExp NON_TERM = RegExp('^<.*>\$');

    final String _value;

    Symbol(this._value);

    bool isNonTerminal() {
        // See if the pattern matches the NON_TERM pattern
        return NON_TERM.hasMatch(_value);
    }

    bool isTerminal() {
        return !isNonTerminal();
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is Symbol &&
        runtimeType == other.runtimeType &&
        _value == other._value;

    @override
    int get hashCode => _value.hashCode;
}