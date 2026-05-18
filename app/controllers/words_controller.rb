require "open-uri"
require "json"
require "time"

class WordsController < ApplicationController
  def home
  end

  def word
    @grid = Array.new(10) { ("A".."Z").to_a.sample }.join
    @time = Time.now
  end

  def answer
    @grid = params[:grid].to_s
    @word = params[:mot].to_s

    @is_in_grid = included_in_grid?(@word, @grid)
    @is_english_word = english_word?(@word)

    @count = @word.length
    @timestop = Time.now

    if params[:start_time].present?
      @time = Time.parse(params[:start_time])
      @duration = (@timestop - @time).to_i
    else
      @duration = 0
    end
  end

  private

def included_in_grid?(word, grid)
  word.upcase.chars.all? do |letter|
    word.upcase.count(letter) <= grid.upcase.count(letter)
  end
end

  def english_word?(word)
    url = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(url.read)
    json["found"]
  end
end
