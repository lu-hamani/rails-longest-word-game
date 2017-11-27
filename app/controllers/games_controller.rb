require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def game
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
    @end_time = @start_time + 60
  end

  def score
    @grid = params[:grid].split
    @answer = params[:query].upcase
    if (@answer.size < 10) && english_word?(@answer) && valid?(@answer)
      compute_score
      @message = "You scored #{@player_score} points"
    else
      @message = "Your answer is not valid"
    end
  end

  # def timer
  #   @end_time = @start_time + 60
  # end

  def valid?(answer)
    raise
    @answer.chars.all? { |letter| @answer.count(letter) <= @grid.count(letter) }
  end

  def compute_score
    if @answer.size >= 8
      @player_score = "10"
    elsif @answer.size >= 6
      @player_score = "7"
    else
      @player_score = "4"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{@answer}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
