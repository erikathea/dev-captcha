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
puts " Member.filter_by_location('PQ') #{Member.filter_by_location('PQ')} "
puts " Member.filter_by_location('QC') #{Member.filter_by_location('QC')} "
puts " Member.filter(location:'PQ') #{Member.filter(location:'PQ')} "
puts " Member.filter(location:'QC') #{Member.filter(location:'QC')} "

puts " Member.filter_by_name('John') #{Member.filter_by_name('John')} "
puts " Member.filter_by_name('Jez') #{Member.filter_by_name('Jez')} "
puts " Member.filter(name:'John') #{Member.filter(name:'John')} "
puts " Member.filter(name:'Jez') #{Member.filter(name:'Jez')} "

puts " Member.filter_by_age(23, 30) #{Member.filter_by_age(23, 30)} "
puts " Member.filter(age: [23, 30]) #{Member.filter(age:[23, 30])} "

puts " Member.filter(name: 'Gel', location:'PQ') #{Member.filter(name:'Gel', location:'PQ')} "

puts " Member.filter_by_name_and_location('Gel', 'PQ') #{Member.filter_by_name_and_location('Gel', 'PQ')} "

puts " Member.search(name: 'Barry') #{Member.search(name: 'Barry')} "

puts " Member.filter_by_sex(sex: 'M') #{Member.filter_by_sex(sex: 'M')} "
puts " Member.filter_by_name_and_sex(name:'Jerry', sex: 'M') #{Member.filter_by_name_and_sex(name:'Jerry', sex: 'M')} "
