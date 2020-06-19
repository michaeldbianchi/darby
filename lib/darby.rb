
$:.unshift(__dir__)

require 'pry'
require 'active_model'
require 'daru'

require "initializers/global"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Darby; end
