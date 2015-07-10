filename = ARGV.first
abort("No file found.") unless File.exist?(filename)
require 'json'

file = File.read(filename)
data = JSON.parse(file)

puts "1. What are the 5 most expensive items from each category?"
puts data.sort_by{|i| i['price']}.last(5).reverse

puts "2. Which cds have a total running time longer than 60 minutes?"
long_cds = Hash.new
data.each do |i|
  next unless i['type'] == "cd"
  time = 0
  i['tracks'].each do |t|
    time += t['seconds']
  end
  long_cds << i if ( time/60 >= 60 )
end
puts long_cds

puts "3. Which authors have also released cds?" #I will assume this means books AND cds for the sake of the exercise.
cd_authors = Array.new
book_authors = Array.new
data.each do |i|
  if i['type'] == "cd"
    cd_authors << i['author']
  elsif i['type'] == "book"
    book_authors << i['author']
  end
end
puts ( cd_authors & book_authors ).uniq

puts "4. Which items have a title, track, or chapter that contains a year?"
year = Hash.new
data.each do |i|
  catch :yearly do
    if i['title']['year'] != nil
      year << i
      throw :yearly
    end
    if i['tracks'] != nil
      i['tracks'].each do |t| 
        if t['year'] != nil
          year << i
          throw :yearly
        end
      end
    end
    if i['chapters'] != nil
      i['chapters'].each do |c| 
        if c['year'] != nil
          year << i
          throw :yearly
        end
      end
    end
  end
end
puts year
