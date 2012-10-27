
commits = `git log --numstat | grep -E '^[0-9]+[[:space:]]+[0-9]+'`

per_file = Hash.new([0,0,0])

commits.each_line do | line |
    added, removed, file = line.split
    per_file[file] = per_file[file].zip([added.to_i, removed.to_i, 1]).map{|a,b|a+b}
end
puts per_file
