
PROJECT_ROOT = File.join(File.dirname(__FILE__), '..')
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'pry'
require 'active_model'
require 'daru'
require 'monkey_patch/daru_vector'

require "initializers/global_config"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Darby
  class << self
    def generate_analyzed_data
      puts "Generating portfolio and stock data"
      quantables.each(&:write!)
      puts "Completed generating portfolio and stock data"
    end

    def quantables
      @quantables ||= Darby::Stock.all + Darby::Portfolio.all
    end
  end
end
