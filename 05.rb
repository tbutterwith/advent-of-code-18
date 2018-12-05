file = ''

File.open("data/05.txt", "r") do |f|
  f.each_line do |line|
    file = line
  end
end

# PART ONE
def reduce_file file_input
  starting_counter = -1
  polymer_counter = 0
  polymer_found = true
  char_array = file_input.split('')
  indexes = Array.new

  while starting_counter != polymer_counter do
    starting_counter = polymer_counter
    i = 0
    while i < char_array.length - 1  do
      char = char_array[i]
      is_upper = char.upcase == char
      char_next = char_array[i+1]
      next_is_upper = (char_next && char_next.upcase == char_next)

      if (is_upper && char.downcase == char_next)
        polymer_counter += 1
        indexes.push i
        i += 1
      elsif (!is_upper && next_is_upper && char.upcase == char_next)
        polymer_counter += 1
        indexes.push i
        i += 1
      end
      i += 1
    end

    indexes.each.with_index do |index, counter|
      first = char_array.delete_at(index - counter*2) # first char
      second = char_array.delete_at(index - counter*2) # second char
    end
    indexes = Array.new
  end

  char_array.length
end


# PART TWO
letters = 'abcdefghijklmnopqrstuvwxyz'
polymers = Hash.new

letters.split('').each do |letter|
  file_clone = file.dup
  reduced_lower = file_clone.gsub! letter, ''
  reduced = reduced_lower.gsub! letter.upcase, ''
  length = reduce_file reduced
  polymers[letter] = length
end

puts polymers.values.min