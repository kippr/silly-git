#!/usr/bin/env ruby

class FileStat
    attr_reader :count,:added,:removed,:name
    def initialize file_name
        @name= file_name
        @count, @added, @removed = 0, 0, 0
    end

    def record added, removed
        @count += 1
        @added += added
        @removed += removed
    end

    def to_s
        "#{@name}: #{@count} commit#{@count != 1 ? 's' : ''}, #{@added} #{@removed}"
    end

end

class RepoStats

    attr_reader :per_file

    def initialize
        @per_file = Hash.new{|h,file_name| h[file_name] = FileStat.new(file_name) }
    end

    def read
        commits = `git log --numstat | grep -E '^[0-9]+[[:space:]]+[0-9]+'`
        commits.each_line do | line |
            added, removed, file = line.split
            added, removed = added.to_i, removed.to_i
            @per_file[file].record(added, removed)
        end
        puts "Read changes for #{@per_file.size} files"
        self
    end

    def filter &block
        match = block && @per_file.values.select(&block) || @per_file.each_value
        match = match.to_a
        puts "#{match.size} files match"
        match
    end


end


r = RepoStats.new.read

require 'pry'
binding.pry
