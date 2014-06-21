
#
# Specifying rufus-lua
#
# Sat Mar 14 23:51:42 JST 2009
#

require 'spec_base'


describe Rufus::Lua::State do

  describe 'a Lua coroutine' do

    before do
      @s = Rufus::Lua::State.new
    end
    after do
      @s.close
    end

    it 'can be returned to Ruby' do

      expect(@s.eval(
        'return coroutine.create(function (x) end)'
      ).class).to eq(Rufus::Lua::Coroutine)
    end

    it 'has a status visible from Ruby' do

      co = @s.eval(
        'return coroutine.create(function (x) end)'
      )
      expect(co.status).to eq('suspended')
    end

    it 'can be resumed from Ruby' do

      @s.eval(%{
        co = coroutine.create(function (x)
          while true do
            coroutine.yield(x)
          end
        end)
      })
      expect(@s['co'].resume(7)).to eq [ true, 7.0 ]
      expect(@s['co'].resume()).to eq [ true, 7.0 ]
    end

    it 'can be resumed from Ruby (and is not averse to \0 bytes)' do

      @s.eval(%{
        co = coroutine.create(function (x)
          while true do
            coroutine.yield(x)
          end
        end)
      })
      s = [ 0, 64, 0, 0, 65, 0 ].pack('c*')
      expect(@s['co'].resume(s)).to eq [ true, s ]
      expect(@s['co'].resume()).to eq [ true, s ]
    end
  end
end

