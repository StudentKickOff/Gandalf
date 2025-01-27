# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'webmock'
WebMock.allow_net_connect!
url = 'https://raw.githubusercontent.com/ZeusWPI/hydra/62c7a07f7c3db3fc4460929338d3a3b1bbd06bdb/iOS/Resources/Associations.json'
hash = JSON(HTTParty.get(url).body)
WebMock.disable_net_connect!

hash.each do |club|
  next unless club['parentAssociation'] == 'FKCENTRAAL'

  club = Club.new do |c|
    c.internal_name = club['internalName'].downcase
    c.display_name = club['displayName']
    c.full_name = club['fullName'] unless club['fullName'].blank?
  end
  club.save
end

# Zeus peoples
club = Club.new do |c|
  c.internal_name = 'zeus'
  c.display_name = 'Zeus WPI'
  c.full_name = nil
end
club.save
