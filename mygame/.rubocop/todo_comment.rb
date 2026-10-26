# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Custom
      # Flags every TODO comment so unfinished work fails the style check.
      #
      # @example
      #   # bad
      #   # TODO: Return true when the rank is "Ace".
      #
      #   # good
      #   # Aces are low in this game.
      class TodoComment < Base
        MSG = "Finish this TODO and remove the comment."

        def on_new_investigation
          processed_source.comments.each do |comment|
            add_offense(comment) if comment.text.match?(/\A#\s*TODO\b/)
          end
        end
      end
    end
  end
end

