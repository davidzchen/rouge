def get_keywords(input)
  out = { command: [], option: [], auto: [] }
  input.each do |line|
    line =~ %r(^
      (?: syn[ ]keyword[ ](vimCommand|vimOpt|vimAutoEvent)[ ]contained )
      (.*)
    $)x

    next unless $1

    out_list = case $1
    when 'vimCommand'
      out[:command]
    when 'vimAutoEvent'
      out[:auto]
    when 'vimOpt'
      out[:option]
    end

    $2.scan(/([\w:]+)(?:\[(\w+)\])?/) do
      out_list << [$1, "#{$1}#{$2}"]
    end

    out_list.sort!
  end

  out
end

def render_keywords(keywords, &b)
  return enum_for(:render_keywords, keywords).to_a.join("\n") unless b

  yield '# DO NOT EDIT: automatically generated by `rake vimkeywords`.'
  yield '# see tasks/vim.rake for more info.'
  yield 'module Rouge'
  yield '  module Lexers'
  yield '    class VimL'
  yield '      def self.keywords'
  yield "        @keywords ||= #{keywords.inspect}"
  yield '      end'
  yield '    end'
  yield '  end'
  yield 'end'
end

task :vimkeywords do
  syntax_file = ENV['syntax_file'] || '/usr/share/vim/vimcurrent/syntax/vim.vim'
  output = nil

  File.open(syntax_file, 'r') do |f|
    output = render_keywords(get_keywords(f))
  end

  File.open('./lib/rouge/lexers/viml/keywords.rb', 'w') { |f| f << output }
end
