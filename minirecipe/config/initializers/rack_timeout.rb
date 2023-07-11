if defined?(Rack::Timeout)
  Rack::Timeout::Logger.level = Logger::WARN
end
