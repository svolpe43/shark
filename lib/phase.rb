#!/usr/bin/env ruby

##
# Phase - A section on the practice that has its own mode. ie warm-up main-set and cool-down
#   @sets - List of all the sets in the phase of the practice
#   @distance - length in meters of all sets in phase
class Phase
	def initialize(type)
		@type = type
		@sets = [];
		@distance = 0;
	end

	def distance
		@distance
	end

	def target_distance=(value)
    	@target_distance = value
    	@distance_left = @target_distance
	end

	def target_distance
		@target_distance
	end

	def print_sets()
		puts "#{@type}\n"
		@sets.each{ |t| t.printSet }
	end

	def get_string
		out = "#{@type}\n"

		@sets.each{ |s| out += s.get_string }


		return out
	end

	def add_set(set)
		@distance += set.total_distance
		@distance_left = @target_distance - @distance
		@sets.push(set)
		return @distance
	end

	def distance_left
		@distance_left
	end
end