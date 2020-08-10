require 'json'
require 'open-uri'

class GamesController < ApplicationController

  VOYELS = ["A", "E", "I", "O", "U", "Y"]
  CONSONNES = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]

  def new
    consonnes = Array.new(5) { CONSONNES.sample }
    voyels = Array.new(5) { VOYELS.sample }
    @letters = consonnes + voyels
    @letters = @letters.shuffle!
    session[:global_score] = 0 if session[:global_score].nil?
  end

def score
  @letters = params[:letters]
  @suggestion = params[:suggestion]
  suggestion = params[:suggestion]
  grid = params[:letters]
  if included?(suggestion.upcase, grid)
  if suggestion_is_english?(suggestion)
    score = suggestion.length
      @result = "Congrats, #{suggestion} is a valid word, your score is #{score}, your global score is #{session[:global_score] + score} 👍"
      session[:global_score] += score
  else
    @result = "Sorry, #{suggestion} is not an english word! 🙅‍♀️"
  end
  else
    @result = "Sorry, #{suggestion} is not in the grid! 🤷‍♀️"
  end
end

def suggestion_is_english?(*)
  url = "https://wagon-dictionary.herokuapp.com/#{@suggestion}"
  word_serialized = open(url).read
  word = JSON.parse(word_serialized)['found']
end

  def included?(suggestion, grid)
    suggestion.chars.all? { |letter| suggestion.count(letter) <= grid.count(letter) }
  end
end
