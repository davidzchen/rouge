# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class TextPb < RegexLexer
      title "TextPB"
      desc "Protocol Buffers text format"
      tag 'textpb'
      filenames '*.pb'
      mimetypes 'text/x-textpb'

      identifier = /[a-zA-Z0-9_-]+/
      extension = /\[[a-zA-Z0-9_\.]+\]/
      enum = /[a-zA-Z0-9_]+/

      state :comment do
        rule /(\s*)(#.*$)/ do
          groups Text, Comment::Single
        end
      end

      state :root do
        rule /\s+/, Text
        mixin :comment

        rule /(#{identifier})(\s*)({)/ do
          groups Name::Property, Text, Punctuation
        end

        rule /(#{extension})(\s*)({)/ do
          groups Name::Entity, Text, Punctuation
        end

        rule /}/, Punctuation

        rule /(#{identifier})(\s*)(:)(\s*)/ do
          groups Name::Property, Text, Punctuation, Text
          push :value
        end
      end

      state :value do
        rule /\n/, Text, :pop!
        rule /(true|false)/, Keyword::Constant
        rule /\-?\d+/, Num::Integer
        rule /(\d+\.\d*|\d*\.\d+)/, Num::Float
        rule /#{enum}/, Str::Symbol
        rule /"/, Str, :string_double
        rule /'/, Str, :string_single
        mixin :comment
      end

      state :string do
        rule /\\[0t\tn\n "\\ r]/, Str::Escape
      end

      state :string_double do
        mixin :string
        rule /"/, Str, :pop!
        rule /[^\\"]+/, Str
      end

      state :string_single do
        mixin :string
        rule /'/, Str, :pop!
        rule /[^\\']+/, Str
      end
    end
  end
end
