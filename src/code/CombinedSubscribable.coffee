class CombinedSubscribable
    constructor: (left, right) ->
        @left = left
        @right = right

    extend: (requestedExtenders) ->
        @left.extend requestedExtenders
        @right.extend requestedExtenders
        @

    notifySubscribers: (valueToWrite, event) ->
        @left.notifySubscribers valueToWrite, event
        @right.notifySubscribers valueToWrite, event

    getSubscriptionsCount: -> @left.getSubscriptionsCount() + @right.getSubscriptionsCount()

    once: (callback, target, event) ->
        composed = (newValue) ->
            subscription.dispose()
            callback newValue
        subscription = new CombinedSubscription @left.once(composed, target, event), @right.once(composed, target, event)
    
    or: (other) -> new CombinedSubscribable @, other
    
    subscribe: (callback, target, event) ->
        a = @left.subscribe callback, target, event
        b = @right.subscribe callback, target, event
        new CombinedSubscription a, b