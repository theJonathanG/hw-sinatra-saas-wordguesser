require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]

    #Checks if the guess is valid and updates the game state accordingly
    begin
      guess_result = @game.guess(letter)
      if !guess_result
        flash[:message] = "You have already used that letter."
      end

    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end

    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    if @game.word.nil? || @game.word.empty?
      redirect '/new'
      return
    end

    #Checks the game state and redirects to the appropriate route based 
    #on whether the player has won, lost, or is still playing
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    #Checks if the game state is not a win and redirects to /show if it is not
    if @game.word.nil? || @game.word.empty? || @game.check_win_or_lose != :win
      redirect '/show'
    end

    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    #Checks if the game state is not a lose and redirects to /show if it is not
    if @game.word.nil? || @game.word.empty? || @game.check_win_or_lose != :lose
      redirect '/show'
    end

    erb :lose # You may change/remove this line
  end
end