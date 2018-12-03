require 'set'
require 'ostruct'

class Claim
  attr_accessor :id, :loc, :size, :get_x_loc, :get_x_end

  def initialize(claim_def)
    parse_claim claim_def
  end

  def parse_claim(claim_def)
    parsed_claim = claim_def.split(/#|@|:/).reject(&:empty?)
    @id = parsed_claim[0]
    @loc = parsed_claim[1].strip!
    @size = parsed_claim[2].strip!
  end

  def get_x_loc
    return @loc.split(',')[0].to_i
  end

  def get_y_loc
    return @loc.split(',')[1].to_i
  end

  def get_x_len
    return @size.split('x')[0].to_i
  end

  def get_y_len
    return @size.split('x')[1].to_i
  end

  def get_x_end
    return get_x_loc + get_x_len
  end

  def get_y_end
    return get_y_loc + get_y_len
  end
  
  private :parse_claim
end

fabric = Array.new(1000) { Array.new(1000) { OpenStruct.new(:count => 0, :ids => Array.new) } }
ids = Set.new
overlapping_claims = Set.new

claims = Array.new
File.open("data/03.txt", "r") do |f|
  f.each_line do |line|
    claim = Claim.new line
    claims.push claim
    ids.add(claim.id)
  end
end


claims.each do |claim|
  fabric.each.with_index(claim.get_x_loc) do |y_grid, x|
    if x < claim.get_x_end
      y_grid.each.with_index(claim.get_y_loc) do |val, y|
        if y < claim.get_y_end
          fabric[x][y].count += 1
          fabric[x][y].ids.push claim.id
          if fabric[x][y].count > 1
            overlapping_claims.merge fabric[x][y].ids
          end
        end
        break if y >= claim.get_y_end
      end
    end
    break if x >= claim.get_x_end
  end
end


counter = 0

fabric.each.with_index do |y_grid, i|
  y_grid.each do |val|
    if val.count >= 2
      counter += 1
    end
  end
end

puts counter

puts (ids-overlapping_claims).to_a