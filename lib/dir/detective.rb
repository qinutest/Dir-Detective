require 'open3'

class Dir::Detective
  class Result
    attr_accessor :path, :size

    def initialize(path, size = nil)
      @path = path
      @size = size
    end
  end

  def process(path_start = nil, &block)
    if (!path_start)
      return
    end

    size = '0'
    Dir.foreach(path_start) do |each|
      if (
        !each.match(/^(\.|\.\.)$/) && 
        !File.symlink?(path_start + '/' + each)
      )
        yield(path_start + '/' + each)

        begin
          if (File.directory?(path_start + '/' + each))
            process(path_start + '/' + each, &block)
          end
        rescue

        end
      end
    end
  end

  def get_size(path, size_least)
    if (File.directory?(path))
      size = 0
      Dir.glob(path + '**/*').each {|path_each|
        size += File.size(path_each)
      }
      size = size.to_s
    else
      begin
        size = File.stat(path).size.to_s
      rescue
        size = '0'
      end
    end

    if size.to_i > size_least
      return Dir::Detective::Result.new(path, size)
    end
  end
end
