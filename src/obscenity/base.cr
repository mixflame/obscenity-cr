require "yaml"

class Obscenity
  class Base
    @@blacklist : Array(String) = [""]
    @@whitelist : Array(String) = [""]
    @@scoped_replacement : (String | Nil | Symbol) = nil

    def self.blacklist
      # @@blacklist = set_list_content(Obscenity.config.blacklist)
      @@blacklist = YAML.parse(BLACKLIST).as_a.map(&.as_s)
    end

    def self.blacklist=(value)
      @@blacklist = value == :default ? set_list_content(Obscenity::Config.new.blacklist) : value
    end

    def self.whitelist
      @@whitelist = set_list_content(Obscenity.config.whitelist)
    end

    def self.whitelist=(value)
      @@whitelist = value == :default ? set_list_content(Obscenity::Config.new.whitelist) : value
    end

    def self.profane?(text)
      return(false) unless text.to_s.size >= 3
      blacklist.each do |foul|
        return(true) if text =~ /\b#{foul}\b/i && !whitelist.includes?(foul)
      end
      false
    end

    def self.sanitize(text)
      return(text) unless text.to_s.size >= 3

      blacklist.each do |foul|
        text = text.gsub(/\b#{foul}\b/i, replace(foul)) unless whitelist.includes?(foul)
      end
      @@scoped_replacement = nil
      text
    end

    def self.replacement(chars)
      @@scoped_replacement = chars
      self
    end

    def self.offensive(text)
      words = [] of String
      return(words) unless text.to_s.size >= 3
      blacklist.each do |foul|
        words << foul if text =~ /\b#{foul}\b/i && !whitelist.includes?(foul)
      end
      words.uniq
    end

    def self.replace(word)
      content = @@scoped_replacement || Obscenity.config.replacement
      case content
      when :vowels            then word.gsub(/[aeiou]/i, '*')
      when :stars             then (0...word.size).map { "*" }.join
      when :nonconsonants     then word.gsub(/[^bcdfghjklmnpqrstvwxyz]/i, '*')
      when :default, :garbled then "$@!#%"
      else                         content
      end
    end

    def self.set_list_content(list)
      case list
      when Array(String) then list
      when String        then File.open(list.to_s) { |file| YAML.parse(file) }.as_a.map(&.as_s)
      else                    [] of String
      end
    end
  end
end
