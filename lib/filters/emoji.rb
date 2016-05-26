module Filters
  class Emoji
    def initialize(text)
      @emoji_index = ::Emoji::Index.new
      @text = text
      filter_emoji
    end

    def text
      @text
    end

    private

    def filter_emoji
      @text = @text
              .gsub(':thumbsup:', ':thumbs_up_sign:')
              .gsub(':+1:', ':thumbs_up_sign:')
      matches = @text.scan(/:[a-z0-9_\+-]+?:/)
      return unless matches
      matches.each do |match|
        clean = match.gsub(/:/, '')
        moji = @emoji_index.find_by_name(clean)
        next unless moji
        @text = @text.gsub(match, moji['moji'])
      end
    end
  end
end
