#!/usr/bin/env ruby

class FileStat
    attr_reader :count,:added,:removed,:name

    def self.placeholder file_name
        FileStat.new( file_name, 0, 0, 0)
    end

    def initialize file_name, added, removed, count
        @name = file_name
        @added, @removed, @count = added, removed, count
    end

    def + other
        new_name = self.name == other.name ? self.name : '-'
        FileStat.new( new_name, self.added + other.added, self.removed + other.removed, self.count + other.count )
    end

    def net
        @added - @removed
    end

    def to_s
        "#{@name}: #{@count} commit#{@count != 1 ? 's' : ''}, +#{@added} -#{@removed}"
    end

end

class RepoStats

    attr_reader :files

    def initialize files
        @files = files
    end

    def self.read
        per_file = Hash.new{|h,file_name| h[file_name] = FileStat.placeholder( file_name) }
        commits = `git log --numstat | grep -E '^[0-9]+[[:space:]]+[0-9]+'`
        commits.each_line do | line |
            added, removed, file = line.split
            per_file[file] += FileStat.new(file, added.to_i, removed.to_i, 1)
        end
        puts "Read changes for #{per_file.size} files"
        RepoStats.new( per_file.each_value.to_a )
    end

    def filter &block
        matches = block && files.select(&block) || files
        matches = matches.to_a
        puts "#{matches.size} files match"
        RepoStats.new( matches )
    end

    def summarize
        files.inject(:+)
    end

    def to_s
        summarize.to_s
    end

end


r = RepoStats.read

require 'pry'
binding.pry
