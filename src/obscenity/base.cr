require "yaml"

class Obscenity
  class Base
    @@blacklist : Array(String) = [""]
    @@whitelist : Array(String) = [""]
    @@scoped_replacement : String | Symbol? = nil

    def self.blacklist
      @@blacklist = set_list_content Obscenity.config.blacklist
    end

    def self.blacklist=(value : Symbol)
      raise "invalid blacklist #{value}" if value != :default
      @@blacklist = Obscenity.config.blacklist
    end

    def self.blacklist=(value : Array(String) | String | Path)
      @@blacklist = set_list_content value
    end

    def self.whitelist
      @@whitelist = set_list_content Obscenity.config.whitelist
    end

    def self.whitelist=(value : Array(String) | String | Path)
      @@whitelist = set_list_content value
    end

    def self.whitelist=(value : Symbol)
      @@whitelist = set_list_content Obscenity::Config.new.whitelist
    end

    def self.profane?(text : String)
      return(false) unless text.size >= 3
      blacklist.each do |foul|
        return(true) if text =~ /\b#{foul}\b/i && !whitelist.includes?(foul)
      end
      false
    end

    def self.sanitize(text : String)
      return(text) unless text.size >= 3

      blacklist.each do |foul|
        text = text.gsub(/\b#{foul}\b/i, replace(foul)) unless whitelist.includes?(foul)
      end

      @@scoped_replacement = nil
      text
    end

    def self.replacement(chars : String | Symbol?)
      @@scoped_replacement = chars || :default
      self
    end

    def self.offensive(text : String)
      words = [] of String
      return(words) unless text.size >= 3
      blacklist.each do |foul|
        words << foul if text =~ /\b#{foul}\b/i && !whitelist.includes?(foul)
      end
      words.uniq
    end

    def self.replace(word)
      case content = @@scoped_replacement || Obscenity.config.replacement
      when :vowels            then word.gsub(/[aeiou]/i, '*')
      when :stars             then (0...word.size).map { "*" }.join
      when :nonconsonants     then word.gsub(/[^bcdfghjklmnpqrstvwxyz]/i, '*')
      when :default, :garbled then "$@!#%"
      else                         content
      end
    end

    private def self.set_list_content(list : Array(String))
      list
    end

    private def self.set_list_content(list : String | Path)
      File.open list, &.each_line.to_a
    end
  end
end
