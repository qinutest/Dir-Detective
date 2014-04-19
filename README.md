Dir-Detective
=============

a recursive detective for directory.

##SYNOPSIS

    require 'dir/detective'

    path_start = '/'
    size_least = 102400000

    dd = Dir::Detective.new
    dd.process(path_start) do |path|
      result = dd.get_size(path, size_least)
      if (result)
        puts result.size + ' ' + result.path
      end
    end
