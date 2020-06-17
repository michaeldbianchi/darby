require 'global'

Global.backend(:filesystem, environment: ENV["ENV"] || 'development', path: 'config/global')
