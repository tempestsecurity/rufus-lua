#--
# Copyright (c) 2009, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


require 'rufus/lua/lib'


module Rufus::Lua

  class State

    def initialize (include_libs=true)
      @state = Lib.luaL_newstate
      Lib.luaL_openlibs(@state) if include_libs
    end

    def eval (s)
      err = Lib.luaL_loadbuffer(@state, s, Lib.strlen(s), 'line')
      raise_if_error('eval:compile', err)
      err = Lib.lua_pcall(@state, 0, 0, 0)
      raise_if_error('eval:call', err)
      ''
    end

    def close
      Lib.lua_close(@state)
    end

    protected

    def raise_if_error (where, err)
      return if err < 1
      s = Lib.lua_tolstring(@state, -1, nil)
      Lib.lua_settop(@state, -2)
      raise "#{where} : '#{s}' (#{err})"
    end
  end
end

