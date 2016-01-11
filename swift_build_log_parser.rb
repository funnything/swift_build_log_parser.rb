# coding: utf-8
require 'logger'

logger = Logger.new STDOUT
logger.level = Logger::INFO

scheme = nil
in_build_section = false
in_project_section = false

by_file = []
by_method = []
build_time = nil

while l = gets
  l.chomp!

  if !scheme
    raise l unless l =~ /Loading settings for scheme '(.+)'/
    scheme = $1
    logger.info "scheme: #{scheme}"
  elsif !in_build_section
    if l =~ /^=== BUILD ===/
      in_build_section = true
      logger.debug "build section begin from: #{l}"
    end
  elsif !in_project_section
    if l =~ %r!^    #{scheme} / #{scheme}!
      in_project_section = true
      logger.debug "project section begin from: #{l}"
    end
  else
    if l =~ /^      ✓ Compile (.+).swift \(([0-9]+) ms\)$/
      by_file << {name: $1, time: $2.to_i}
      logger.debug [$1, $2].join(' ')
    elsif l =~ /^([0-9.]+)ms\t([^\t]+)\t(.+)$/
      time, location, method = $1, $2, $3
      time = time.to_f
      location = location.split('/')[-1]

      by_method << {time: time, location: location, method: method}

      logger.debug [time, location, method].join(' ')
    elsif l =~ /\*\* BUILD SUCCEEDED \*\* \(([0-9]*) ms\)/
      build_time = $1
      logger.debug build_time
    end
  end
end

puts '=== File ==='
by_file.sort_by { |i| i[:time] }.reverse.each { |i|
  puts '%6dms %s' % [i[:time], i[:name]]
}

puts

puts '=== Method ==='
by_method.select { |i| i[:time] > 50 }.sort_by { |i| i[:time] }.reverse.each { |i|
  puts '%8.1fms %s %s' % [i[:time], i[:location], i[:method]]
}

puts

puts "=== Build time ==="
puts "#{build_time} ms"
