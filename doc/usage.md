## Usage

### Combine observables and subscribables with `or`.
    var combined = obsA.or(obsB);

### Fire `once` and unsubscribe.
    var value = 0;
    obsA.once(function(newValue){ value = newValue; });
    obsA(1);
    obsA(2);
    // value is 1

### Combine `once` with `or` for greater control.
    var value = 0;
    var obsA = ko.observable();
    var obsB = ko.observable();
    var combined = obsA.or(obsB);
    combined.once(function(newValue){ value = newValue; });
    obsB(1);
    obsA(2);
    // value is 1