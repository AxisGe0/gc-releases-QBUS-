Config = {
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'emerald','carbon','ironore','copperore','goldore'},
    Sell = vector3(-97.12, -1013.8, 26.3),
    Objects = {
        ['pickaxe'] = 'prop_tool_pickaxe',
    },
    MiningPositions = {
        {coords = vector3(2992.77, 2750.64, 42.78), heading = 209.29},
        {coords = vector3(2983.03, 2750.9, 42.02), heading = 214.08},
        {coords = vector3(2976.74, 2740.94, 43.63), heading = 246.21}
    },
}

Strings = {
    ['press_mine'] = 'Press ~INPUT_CONTEXT~ to mine.',
    ['mining_info'] = 'Press ~INPUT_ATTACK~ to chop, X to stop.',
    ['you_sold'] = 'You sold %sx %s for %s',
    ['e_sell'] = 'Press ~INPUT_CONTEXT~ to sell all your mined items.',
    ['someone_close'] = 'There is a player too close to you!',
    ['mining'] = 'Mine',
    ['sell_mine'] = 'Sell mined items'
}