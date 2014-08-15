ko.subscribable.fn['once'] = (callback, target, event) ->
    composed = (newValue) ->
        subscription.dispose()
        callback newValue
    subscription = @subscribe composed, target, event

ko.subscribable.fn['or'] = (other) -> new CombinedSubscribable @, other