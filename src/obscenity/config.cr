class Obscenity
  class Config
    property replacement : Symbol = :garbled
    property blacklist : Array(String) { read_default_blacklist }
    property whitelist : Array(String) { DEFAULT_WHITELIST }

    DEFAULT_WHITELIST = [] of String
    DEFAULT_BLACKLIST = "#{__DIR__}/../../config/blacklist"

    def initialize(proc = nil)
      proc.call(self) if proc
      validate_config_options
    end

    def blacklist=(value : Symbol)
      raise "invalid blacklist #{value}" if value != :default
      @blacklist = read_default_blacklist
    end

    def whitelist=(value : Symbol)
      raise "invalid whitelist #{value}" if value != :default
      @whitelist = DEFAULT_WHITELIST
    end

    def blacklist=(filepath : String | Path)
      @blacklist = read_ndl_file_at filepath
    end

    def whitelist=(filepath : String | Path)
      @whitelist = read_ndl_file_at filepath
    end

    def validate_config_options
      [@blacklist, @whitelist].each { |content| validate_list_content(content) if content }
    end

    def validate_list_content(content : Array(String))
      raise Obscenity::EmptyContentList.new "Content array is empty." if content.empty?
    end

    private def read_default_blacklist
      # Read the default blacklist from the file
      read_ndl_file_at DEFAULT_BLACKLIST
    end

    private def read_ndl_file_at(location) : Array(String)
      File.open location, &.each_line.to_a
    end
  end
end
