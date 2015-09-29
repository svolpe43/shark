#!/usr/bin/env ruby

##
# Set - The most elementary part of a practice
#   Has a bunch of metrics 
#   proper string form - "<num>x<distance (yards)> <stroke> <special> <type>"
class Set

	# parse a set code into a set object
	def initialize(code)
		parts = code.split(/ /)

		details = parts[0].split(/x/)
			@amount = details[0].to_i
			@distance = details[1].to_i

		@stroke = parts[1]
		@sequence = parts[2] ? parts[2] : false

		@total_distance = @amount * @distance
	end

	def distance
		@distance
	end

	def total_distance
		@total_distance
	end

	def printSet()
		puts "#{@amount} x #{@distance}'s #{@stroke} for #{@amount * @distance} yards"
	end

	def get_string
		return "#{@amount} x #{@distance}'s #{@stroke} for #{@amount * @distance} yards\n"
	end
end