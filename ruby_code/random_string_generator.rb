class Array
# If +number+ is greater than the size of the array, the method
# will simply return the array itself sorted randomly
  def randomly_pick(number)
		sort_by{ rand }.slice(0...number)
	end
end

def random_string_generator length
	#Here we put all the characters we allow in our password
	valid_characters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", "^", "&"]
	#We initalize it as an empty string because we will append the characters
	rand_string = ""
	length.times do
		#we cannot do "randomly_pick(length)" because we want repeiting characters 
		rand_string<< valid_characters.randomly_pick(1).first
	end
	#what we return
	rand_string
end

#creating and showing a string with 8 characters
puts random_string_generator 8
