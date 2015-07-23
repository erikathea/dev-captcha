#!/usr/bin/env ruby

require 'rubygems'
require 'curb'
require 'json'
require_relative 'member'

http = Curl.get('https://raw.githubusercontent.com/infoshift/dev-captcha/master/team.json')

team_json =
  if http.status == '200 OK'
    JSON.parse(http.body_str)
  else
    {}
  end

unless team_json.keys.include?('members')
  puts 'Sorry, no members found.'
  exit
end

team = team_json['members']
team.each do |member|
  Member.new(member)
end


### Test cases:
puts "Testing filter_by_location"
puts " Member.filter_by_location('PQ'):"
puts " #{Member.filter_by_location('PQ')} "
puts "---"
puts " Member.filter_by_location('QC')"
puts " #{Member.filter_by_location('QC')} "
puts "---"
puts " Member.filter(location:'PQ') "
puts " #{Member.filter(location:'PQ')} "
puts "---"
puts " Member.filter(location:'QC') "
puts " #{Member.filter(location:'QC')} "
puts "---"
puts "---"
puts "Testing filter_by_name"
puts " Member.filter_by_name('John') "
puts " #{Member.filter_by_name('John')} "
puts "---"
puts " Member.filter_by_name('Jez') "
puts " #{Member.filter_by_name('Jez')} "
puts "---"
puts " Member.filter(name:'John') "
puts " #{Member.filter(name:'John')} "
puts "---"
puts " Member.filter(name:'Jez') "
puts " #{Member.filter(name:'Jez')} "
puts "---"
puts "---"
puts "Testing filter_by_age"
puts " Member.filter_by_age(23, 30) #{Member.filter_by_age(23, 30)} "
puts "---"
puts " Member.filter(age: [23, 30]) #{Member.filter(age:[23, 30])} "
puts "---"
puts "---"
puts "Testing dynamic filter_by_"
puts " Member.filter(name: 'Gel', location:'PQ') "
puts " #{Member.filter(name:'Gel', location:'PQ')} "
puts "---"
puts " Member.filter_by_name_and_location('Gel', 'PQ') "
puts " #{Member.filter_by_name_and_location('Gel', 'PQ')} "
puts "---"
puts " Member.filter_by_location_and_name('PQ', 'Chiz') "
puts " #{Member.filter_by_location_and_name('PQ', 'Chiz')} "
puts "---"
puts " Member.filter_by_name_and_age('Ry', 22) "
puts " #{Member.filter_by_name_and_age('Ry', 22)} "
puts "---"
puts " Member.filter_by_name_and_age('Ry', [20, 25]) "
puts " #{Member.filter_by_name_and_age('Ry', [20, 25])} "
puts "---"
puts " Member.search(name: 'Barry') "
puts " #{Member.search(name: 'Barry')} "
puts "---"
puts " Member.filter_by_sex(sex: 'M') "
puts " #{Member.filter_by_sex(sex: 'M')} "
puts "---"
puts " Member.filter_by_name_and_sex(name:'Jerry', sex: 'M') "
puts " #{Member.filter_by_name_and_sex(name:'Jerry', sex: 'M')} "
puts "---"
puts "END"

