require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].split('')
    @answer = params[:answer]


    if !in_the_grid?
      @result = :not_in_the_grid
    elsif !english_word?
      @result = :not_english_word
    else
      @result = :congrats
    end
  end

  private

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_serialized = open(url).read
    @word = JSON.parse(word_serialized)
    return @word['found'] == true
  end

  def in_the_grid?
    # @answer => String CATAAZ
    # @letters => Array C A T S A A A A A

    # normalisation
    # passer le asnwer string a un tableau de letters
    @answer_letters = @answer.upcase.split('')

    # pour chaque lettre de l'attempt, le nb de fois que la lettre apparait dans l'attempt doit etre INF OU EGAL par rapport au nb de fois que la meme lettre apparait dans la grille
    @answer_letters.all? { |letter| @answer_letters.count(letter) <= @letters.count(letter) }
  end
end
