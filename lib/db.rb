#!/usr/bin/env ruby

class Db

	def initialize(db_file)
		@amounts = [1,2,4,5,6,8,10,12]
		@distances = [25, 50, 75, 100, 125, 150, 200]
		@strokes = ["free", "breast"]

		write_db(make_string, db_file)
	end

	def make_string
		string = ""
		for amount in 0..@amounts.count - 1
			for distance in 0..@distances.count - 1
				string += '- "'
				string += "#{@amounts[amount]}x#{@distances[distance]} free none"
				string += '"'
				string += "\n"
				string += '- "'
				string += "#{@amounts[amount]}x#{@distances[distance]} breast none"
				string += '"'
				string += "\n"
			end
		end
		return string
	end

	def write_db(string, file)
		File.open("sets.yaml", 'w') { |file|
			file.write(string)
		}
	end
end

db = Db.new("sets.yaml")

# - "1x25 free none"
# - "4x75 io k/s/k up"
#- "1x25 free none"
#- "4x75 io k/s/k up"
#- "1x50 free none"
#- "2x50 free none"
#- "4x50 free none"
#- "6x50 free none"
#- "2x75 free none"
#- "4x75 free none"
#- "1x100 free none"
#- "2x100 free none"
#- "3x100 free none"
#- "4x100 free none"
#- "1x200 free none"
#- "2x200 free none"
#- "4x100 im none any"
#- "1x400 free none"