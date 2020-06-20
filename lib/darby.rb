
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

module Darby; end
