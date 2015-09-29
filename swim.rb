#!/usr/bin/env ruby

require "yaml"
require 'pry-byebug'

require_relative "lib/phase.rb"
require_relative "lib/practice.rb"
require_relative "lib/set.rb"
yaml_file = "sets.yaml"

distance = 2500

##
# System - a wrapper for choosing practices and creating a log of the data
class System
	def initialize(distance, yaml_file)
		@practice_distance = distance
		@yaml_file = yaml_file
		@practices = []
		@set_list = set_set_list(@yaml_file)

		# amount to show each time
		pagination_amount = 2

		# 5 practices then print them
		make_practices(pagination_amount)

		while true
			resp = gets.chomp
			if /\A\d+\z/.match(resp)
				pick_practice(resp.to_i - 1)
				break
			elsif resp == "next" || resp == "n"
				puts "Next? Okay!"
				make_practices(pagination_amount)
				next
			elsif resp == "quit" || resp == "q"
				exit
			end
		end
	end

	def pick_practice(index)
	 	# log practice

	 	File.open("swim.log", 'a') { |file| 
	 		file.write(@practices[index].get_string)
	 	}

	 	puts "You picked number #{index + 1}."
	end

	# pagination of the practices for viewing
	def make_practices(amount)
		for i in 1..amount
			# the fucking probalem is definitely in this call
			# binding.pry
			practice = Practice.new(@practice_distance, @set_list)
			@practices.push(practice)

			puts "Practice #{@practices.count}"
			practice.print
			puts "------------------------------------------------------------\n"
		end
	end

	# create a database of sets to choose from
	def set_set_list(yaml_file)

		list = []

		# get yaml data
    	YAML.load_file(yaml_file).each{ |i| list.push(Set.new(i))}

		# TODO - figure out how to do one distance the other way
		@set_list = list.sort_by { |a| 
			[ a.total_distance, a.distance ] 
			#[a[:gender], a[:name]] <=> [b[:gender], b[:name]]
		}

		#@set_list.each{ |l|
		#	puts l.get_string
		#}
	end

	def read_log(log_file)
		@num_practices = 0
		File.open("swim.log", 'r'){ |l|
			@practices += l.count("|")
		}
	end
end

system = System.new(distance, yaml_file)



