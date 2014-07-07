require 'FileUtils'

$recursionLevel = 0
$countHash = {:kick => 0,
		:hihat => 0,
		:clap => 0,
		:snare => 0,
		:bongo => 0,
		:bell => 0,
		:cymbal => 0,
		:ride => 0,
		:crash => 0,
		:tambourine => 0,
		:tom => 0,
		:rimshot => 0,
		:china => 0,
		:clave => 0,
		:whistle => 0,
		:click => 0,
		:wood => 0,
		:conga => 0,
		:guitar => 0,
		:djembe => 0,
		:cabasa => 0,
		:shaker => 0,
		:triangle => 0,
		:cowbell => 0,
		:bass => 0,
		:percs => 0,
		:unknown => 0
	}

$hash = {:kick => ["bd", "kick", "kik"],
		:hihat => ["hh", "hihat", "hi-hat", "hat", "close", "open"],
		:clap => ["clap"],
		:snare => ["snare", "sd", "snr", "nare"],
		:bongo => ["bongo"],
		:bell => ["bell"],
		:cymbal => ["cymbal", "cymb"],
		:ride => ["ride"],
		:crash => ["crash", "crsh"],
		:tambourine => ["tamb"],
		:tom => ["tom"],
		:rimshot => ["rimshot", "rimsh", "rim", "sidestick"],
		:china => ["china"],
		:clave => ["clave"],
		:whistle => ["whistle"],
		:click => ["click", "klik"],
		:wood => ["wood", "block"],
		:conga => ["conga"],
		:guitar => ["guitar"],
		:djembe => ["djembe"],
		:cabasa => ["cabasa"],
		:shaker => ["shaker", "shkr", "maraca"],
		:triangle => ["triangle", "tri"],
		:cowbell => ["cowbell", "cow", "cwbl"],
		:bass => ["bass"],
		:percs => ["guira", "quijada", "agogo", "guiro", "timbale", "castanets", "cuica"]
	}

def moveFile(file)

	valid = false

	$hash.each_pair do |key, value|
		value.each do |value|	
			if file.downcase.include?(String(value).downcase) && !file.downcase.include?(".asd")
				puts "#{file} " +(" "*(50-file.length))+ "includes #{value}"
				$countHash[key] += 1
				valid = true


				newFileLocation = $out+"/"+String(key)

				if Dir.exists? newFileLocation
					puts "it exists"
					FileUtils.cp File.absolute_path(file), newFileLocation+"/"
				else
					puts "it doesn't exist" + newFileLocation
					FileUtils.mkdir_p String(newFileLocation)
					#FileUtils.cp File.absolute_path(file), newFileLocation+"/"
				end

				break
			end
		end

		if valid 
			break
		end
	end

	if valid == false
		if !file.include?(".asd") 
			puts file
			$countHash[:unknown] += 1
		end
	end
end


def moveBetweenFiles(_dir)

	Dir.chdir(_dir)
	Dir.foreach(Dir.pwd) do |dir|

		if File.directory?(File.absolute_path(dir)) && dir != "." && dir != ".." && dir != ".DS_Store"
			
			$recursionLevel += 1

			#print "recursion level: " + String($recursionLevel) + " " + File.absolute_path(dir)		

			moveBetweenFiles File.absolute_path(dir)

			Dir.chdir(_dir)

			$recursionLevel -= 1
		elsif File.directory?(File.absolute_path(dir)) == false && dir != "." && dir != ".." && dir != ".DS_Store"

			moveFile dir
		end
	end
end

$out = ARGV[1]

moveBetweenFiles ARGV[0]

puts $countHash.to_s
