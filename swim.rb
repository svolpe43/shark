#!/usr/bin/env ruby

require "yaml"

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

##
# Practice - The root object of the script
#   @up, @main, @down - three phases of the practice
#   @set_list - database of all possible sets
class Practice

	def initialize(distance, yaml_file)
		@up = Phase.new("Warm Up")
		@main = Phase.new("Main Set")
		@down = Phase.new("Cool Down")

		@set_list;

		allocate_distance(distance)
		set_set_list(yaml_file)
		calculate_sets

		print
	end

	# create a database of sets to choose from
	def set_set_list(yaml_file)

		list = []

		# get yaml data
    	YAML.load_file(yaml_file).each{ |i| list.push(Set.new(i))}

		# TODO - figure out how to do one distance the other way
		@set_list = list.sort_by { |a| [ a.total_distance, a.distance ] }
	end

	# allocate the right distance for different phase of the practice
	def allocate_distance(total)

		# TODO - should be a range from .5 - .2 incr of .05 - 6 possibilites
		incr = rand(0..5)
		@up.target_distance = total * (0.2 + (0.05 * incr))

		total -= @up.target_distance

		@down.target_distance = 200
		total -= @down.target_distance

		@main.target_distance = total
	end

	def calculate_sets()

		# restrict the index chosen by keeping track of maximum index allowed
		max_index = @set_list.count - 1

		# create a waiting list of possible indexes to call
		@indexes = []
		fib = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946]
		for i in 0..@set_list.count - 1
			for j in 0..fib[i]
		   		@indexes.push(i)
		  end
		end

		fill_phase(@up)
		fill_phase(@main)

		@down.add_set(Set.new("1x200 chill out"))
	end

	# the meat of the alg besides sorting, picks indexes with restricted randomness
	def fill_phase(phase)
		max_index = @set_list.count - 1
		while phase.distance_left > 1 do

			# find an index that is currently allowed
			while true
				index = @indexes[rand(0..@indexes.count - 1)]
				if index <= max_index
					break
				end
			end

			# add the new item!
			phase.add_set(@set_list[index]) 

			# update the max_index
			if phase.distance_left < @set_list[max_index].total_distance
				current_distance = @set_list[max_index].total_distance
				for i in (max_index).downto(0)
					max_index = i
					if phase.distance_left >= @set_list[i].total_distance
							break
					end
				end
			end
		end

		return phase
	end

	def print()

		@up.print_sets
		puts "Total:     #{@up.target_distance}\n\n"
		@main.print_sets
		puts "Total:     #{@main.target_distance}\n\n"
		@down.print_sets
		puts "Total:     #{@down.target_distance}\n\n"
	end
end

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
end

##
# System - a wrapper for choosing practices and creating a log of the data
#
# create empty list of practices
# paginate 5 practices with a number to choose from
# wait for input
	# if we get just a number - log the practice to the swim.log
	# if we get a next string - paginate another 5 practices
class System
	def initialize()
		@practice_distance = 2000
		@yaml_file = "sets.yaml"
		@practices = []
		@min_index = 0
		@max_index = 4
		@pagination_amount = 5

		# 5 practices then print them
		paginate_practices()
		print_practices()

		while true
			resp = gets

			if /\A\d+\z/.match(resp)
				pick_cmd(resp.to_i - 1)
				break
			elsif resp == "next" || resp == "n"
				puts "Next called"
				next_cmd()
				next
			elsif resp == "previous" || resp == "p"
				puts "Previous called"
				previous_cmd()
				next
			end
		end
	end

	# show the next 5 practices
	def next_cmd
		paginate_practices()
		print_practices()
	end

	# show the previous 5 practices
	def previous_cmd
		if @min_index == 0
			puts "Already at the beginning."
		else
			@min_index -= @pagination_amount
			@max_index -= @pagination_amount
		end
	end

	def pick_cmd(index)
	 	# log practice
	 	# index + 1
	 	puts "You picked number #{index + 1}."
	 	#write.(@practice[index])
	end

	def print_practices()
		for i in @min_index..@max_index
			@practices[i].print()
			puts "------------------------------------------------------------\n"
		end
	end

	# pagination of the practices for viewing
	def paginate_practices()
		@min_index += @pagination_amount
		@max_index += @pagination_amount

		for i in 0..@pagination_amount - 1
			@practices.push(Practice.new(@practice_distance, @yaml_file))
		end
	end
end


# system = System.new()
practice = Practice.new(2000, "sets.yaml")



