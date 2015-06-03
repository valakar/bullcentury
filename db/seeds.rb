# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[{name: 'Leisure', key: 'leisure'},
 {name: 'Media', key: 'media'},
 {name: 'Art', key: 'art'},
 {name: 'Crazy', key: 'crazy'},
 {name: 'Innovation', key: 'innovation'},
 {name: 'Social projects', key: 'social_projects'}].each do |category|
  Category.create!(category) unless Category.find_by_name(category[:name])
end

[{ name: 'United States Dollar', key: :usd, sign:'$' },
 { name: 'Euro', key: :eur, sign:'€' },
 { name: 'Ukrainian Hryvna', key: :uah, sign:'₴' },
 { name: 'Hungarian Forint', key: :huf, sign:'Ft' }].each do |currency|
  Currency.create!(currency) unless Currency.find_by_key(currency[:key])
end

[{ name: 'Ukraine'},
 { name: 'USA'},
 { name: 'Hungary'},
 { name: 'Romania'}].each do |country|
  Country.create!(country) unless Country.find_by_name(country[:name])
end

[{ name: 'Kiev', country_id: '1'},
 { name: 'Lviv', country_id: '1'},
 { name: 'Kharkiv', country_id: '1'},
 { name: 'Dnipropetrovsk', country_id: '1'},
 { name: 'Odessa', country_id: '1'},
 { name: 'Donetsk', country_id: '1'},
 { name: 'Zaporizhia', country_id: '1'},
 { name: 'Kryvyi Rih', country_id: '1'},
 { name: 'Mykolaiv', country_id: '1'},
 { name: 'Mariupol', country_id: '1'},
 { name: 'Luhansk', country_id: '1'},
 { name: 'Makiivka', country_id: '1'},
 { name: 'Rivne', country_id: '1'}].each do |city|
  City.create!(city) unless City.find_by_name(city[:name])
end

[{ name: 'New York', country_id: '2'},
 { name: 'Los Angeles', country_id: '2'},
 { name: 'Chicago', country_id: '2'},
 { name: 'Houston', country_id: '2'}].each do |city|
  City.create!(city) unless City.find_by_name(city[:name])
end

[{ name: 'Budapest', country_id: '3'},
 { name: 'Debrecen', country_id: '3'},
 { name: 'Miskolc', country_id: '3'},
 { name: 'Szeged', country_id: '3'}].each do |city|
  City.create!(city) unless City.find_by_name(city[:name])
end

[{ name: 'Bucharest', country_id: '4'},
 { name: 'Cluj-Napoca', country_id: '4'},
 { name: 'Timișoara', country_id: '4'},
 { name: 'Iași', country_id: '4'}].each do |city|
  City.create!(city) unless City.find_by_name(city[:name])
end