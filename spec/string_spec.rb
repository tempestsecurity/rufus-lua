
#
# Specifying rufus-lua
#
# Sat Jun 21 11:04:02 JST 2014
#

require 'spec_base'

# adapted from https://github.com/jmettraux/rufus-lua/issues/14


describe 'lua strings' do

  context 'and \0 bytes' do

    before :each do
      @s = Rufus::Lua::State.new
    end
    after :each do
      @s.close
    end

    it 'are not truncated when returned to Ruby' do

      s = @s.eval('return string.char(1, 0, 0, 2, 0, 0)')

      expect(s.bytes.to_a).to eq([ 1, 0, 0, 2, 0, 0 ])
    end

    it 'are not truncated when passed from Ruby to Lua and back' do

      s = [ 65, 66, 0, 67, 0, 0, 68, 0 ].pack('c*')

      f = @s.eval(%{
        f = function(s)
          return { s = s, l = string.len(s) }
        end
        return f
      })

      expect(f.call(s).to_h).to eq({ 's' => s, 'l' => 8.0 })
    end

    it 'accept symbols containing the \0 character' do

      s = [ 65, 66, 0, 67, 0, 0, 68, 0 ].pack('c*').to_sym

      f = @s.eval(%{
        f = function(s)
          return { s = s, l = string.len(s) }
        end
        return f
      })

      expect(f.call(s).to_h).to eq({ 's' => s.to_s, 'l' => 8.0 })
    end
  end
end

