class Obscenity
  BLACKLIST = {% read_file "#{__DIR__}/../config/blacklist" %}
end

require "./obscenity/error"
require "./obscenity/config"
require "./obscenity/base"
require "./obscenity/version"

class Obscenity
  def self.config=(config)
    @@config = config
  end

  def self.configure(proc)
    @@config = Config.new(proc)
  end

  def self.config
    @@config ||= Config.new
  end

  def self.profane?(word)
    Obscenity::Base.profane?(word)
  end

  def self.sanitize(text)
    Obscenity::Base.sanitize(text)
  end

  def self.replacement(chars)
    Obscenity::Base.replacement(chars)
  end

  def self.offensive(text)
    Obscenity::Base.offensive(text)
  end
end
