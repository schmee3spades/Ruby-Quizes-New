module RubyQuiz
  class LanguageFilter
    def initialize( *banned_words )
      @banned_words = banned_words.flatten.sort
      @clean_calls = 0
    end

    attr_reader :clean_calls

    def clean?( text )
      @clean_calls += 1
      @banned_words.each do |word|
        return false if text =~ /\b#{word}\b/
      end
      true
    end

    def verify( *suspect_words )
      suspect_words.flatten.sort == @banned_words
    end
  end
end
