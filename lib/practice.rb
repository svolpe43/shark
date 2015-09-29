#!/usr/bin/env ruby

##
# Practice - The root object of the script
#   @up, @main, @down - three phases of the practice
#   @set_list - database of all possible sets
class Practice

	def initialize(distance, set_list)
		@up = Phase.new("Warm Up")
		@main = Phase.new("Main Set")
		@down = Phase.new("Cool Down")
		@distance = distance

		@set_list = set_list;

		allocate_distance(distance)
		
		calculate_sets

		# print
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

		# create a list of possible indexes to call based on fibinacci sequence
		@indexes = []
		#fib = make_fib(@set_list.count)

		#for i in 0..@set_list.count - 1
		#	for j in 0..fib[i]
		#   		@indexes.push(i)
		#  end
		#end

		# actually fill the phases with sets
		fill_phase(@up)
		fill_phase(@main)

		@down.add_set(Set.new("1x200 chill-out"))
	end

	def make_fib(amount)
		# [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233]
		fib = []
		fib[0] = 1
		fib[1] = 2

		for i in 2..amount - 1
			fib[i] = fib[i - 1] + fib[i - 2]
		end

		return fib
	end

	# the meat of the alg besides sorting, picks indexes with restricted randomness
	def fill_phase(phase)
		max_index = @set_list.count - 1
		while phase.distance_left > 1 do

			# find an index that is currently allowed
			while false
				index = @indexes[rand(0..@indexes.count - 1)]
				if index <= max_index
					break
				end
			end

			# add the new item!
			phase.add_set(@set_list[rand(0..max_index)]) 

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

	def get_string
		out = ""

		n = DateTime.now.strftime("%A %B %e, %H:%M:%S")

		out += "#{n} | #{@distance} yrds\n"

		out += @up.get_string
		out += @main.get_string
		out += @down.get_string

		out += "----------------------------------------------------------\n\n"

		return out
	end

	def print()

		@up.print_sets
		puts "Total:     #{@up.target_distance.to_i}\n\n"
		@main.print_sets
		puts "Total:     #{@main.target_distance.to_i}\n\n"
		@down.print_sets
		puts "Total:     #{@down.target_distance.to_i}\n\n"
	end
end