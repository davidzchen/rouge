describe Rouge::Lexers::TextPb do
  let(:subject) { Rouge::Lexers::TextPb.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pb'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-textpb'
    end
  end
end
