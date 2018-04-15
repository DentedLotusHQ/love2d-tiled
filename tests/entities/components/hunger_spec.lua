describe("an entity with hunger", function()
  local config = require('config')()
  local Vector2 = require('game.point')
  local Goblin = require('game.entities.goblin')
  local goblin = Goblin:new(config.goblins, Vector2:new(0, 0), {})

  it('should expose a total hunger value', function()
    assert.is_not_nil(goblin.totalHunger)
  end)

  it('should expose a current hunger value', function()
    assert.is_not_nil(goblin.currentHunger)
    assert.is_true(type(goblin.currentHunger) == 'number')
  end)

  it('should lose hunger over time', function()
    pending('TODO')
  
  end)

  it('should lose more hunger while doing strenuous activities', function()
    pending('TODO')
  
  end)

  it('should be able to replenish their hunger by eating', function()
    pending('TODO')
  end)
end)