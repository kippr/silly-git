
commits = `git log --numstat | grep -E '^[0-9]+[[:space:]]+[0-9]+'`

class FileStat
    def initialize file_name
        @file_name = file_name
        @count, @added, @removed = 0, 0, 0
    end

    def record added, removed
        @count += 1
        @added += added
        @removed += removed
    end

    def to_s
        "#{@file_name}: #{@count} commit#{@count != 1 ? 's' : ''}, #{@added} #{@removed}"
    end

end


per_file = Hash.new{|h,file_name| h[file_name] = FileStat.new(file_name) }
total = FileStat.new('Total')

commits.each_line do | line |
    added, removed, file = line.split
    added, removed = added.to_i, removed.to_i
    per_file[file].record(added, removed)
    total.record(added, removed)
end

num_files = per_file.size


require 'pry'
binding.pry
