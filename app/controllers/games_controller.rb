require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def letters
    grid = []
    10.times do
      grid << ('A'..'Z').to_a.sample(1)
    end
    grid.flatten
  end

  def new
    @letters = letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split("")
    @message = run_game(@word, @letters)
  end

private

def run_game(word, letters)
  result = {}
  if !check_english(word)
    result[:message] = "Sorry but #{word} doesn't seem to be a valid English word.."
  elsif !check_grid(word, letters)
    result[:message] = "Sorry but #{word} cannot be build out of #{letters.join(',')}."
  else
    result[:message] = "Congratulations! #{word} is a vaid English word."
  end
  result[:message]
end

def check_english(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  check = open(url).read
  result = JSON.parse(check)
  result['found']
end

def check_grid(word, letters)
  letters_hash = {}
  word_hash = {}
  letters.each do |letter|
    letters_hash.key?(letter) ? letters_hash[letter] += 1 : letters_hash[letter] = 1
  end
  word.upcase.chars.each do |attempt_letter|
    word_hash.key?(attempt_letter) ? word_hash[attempt_letter] += 1 : word_hash[attempt_letter] = 1
  end
  word_hash.all? { |letter, count| count <= letters_hash[letter] if letters_hash.key?(letter) }
end

end
