class CombinedSubscription
    constructor: (left, right) ->
        @left = left
        @right = right

    dispose: ->
        @left.dispose()
        @right.dispose()