class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter_input)
    #Checks for invalid input
    if letter_input.nil? || letter_input.empty? || letter_input.length != 1 || letter_input.match(/[^a-zA-Z]/)
      raise ArgumentError
    end

    letter = letter_input.downcase

    #Checks if letter has already been guessed
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    #Adds letter to guesses or wrong_guesses based on whether it is in the word
    if @word.downcase.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

    true
  end

  def check_win_or_lose
    #Checks if the number of wrong guesses is 7 or more
    return :lose if @wrong_guesses.length >= 7
    
    #Checks if all letters in the word have been guessed
    word_letters = @word.downcase.chars.uniq
    all_characters_guessed = word_letters.all? { |letter| @guesses.include?(letter) }
    return :win if all_characters_guessed

    :play
  end

  def word_with_guesses
    printed_word = ''

    #Iterates through each letter in the word and adds it to printed_word if it has been guessed, otherwise adds a dash
    @word.each_char do |letter|
      if @guesses.include?(letter.downcase)
        printed_word += letter
      else
        printed_word += '-'
      end
    end

    printed_word
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord.txt')
    Net::HTTP.get(uri)
  end
end