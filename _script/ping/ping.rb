require 'open-uri'

open('http://subrational.com') { |f|
  puts f.read
}
