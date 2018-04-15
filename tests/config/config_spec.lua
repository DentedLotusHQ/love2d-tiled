require 'busted'
describe('the config object', function()
  local parseConfig = require('config')
  local config = parseConfig()

  describe('when requesting the goblin config', function()

    local goblin = config['goblins']
    it('will return all the required parameters', function()
      assert.is_not_nil(goblin)
      tw = goblin.tileWidth
      th = goblin.tileHeight
      speed = goblin.speed
      ts = goblin.tileset
      assert.is_not_nil(tw)
      assert.is_true(type(tw) == 'number')
      assert.is_not_nil(th)
      assert.is_true(type(th) == 'number')
      assert.is_not_nil(speed)
      assert.is_true(type(speed) == 'number')
      assert.is_not_nil(ts)
      assert.is_true(type(ts) == 'string')
    end)
  end)
end)