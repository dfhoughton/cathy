require "cathy"

# a chat bot that takes a long, long time to warm up
# all Cathy learns is the probability a given word begins a sentences
# and the probability that a given word follows the two preceding words
# a "word" to Cathy is whatever is between two spaces
class ChattyCathy
  # the easy way to begin a conversation
  def self.chat!
    new.chat
  end

  private

  def initialize
    @starters = Cathy.new
    @bigrams = {}
  end

  def chat
    greet

    loop do
      text = listen

      if ["", "bye", "goodbye", "quit"].include?(text.downcase.gsub(/\W+/, ""))
        farewell
        break
      end

      ponder(text)

      respond
    end
  end

  def greet
    puts <<~GREETING
      Hi, I'm Chatty Cathy! Let's have a chat!

      You tell me something. Press enter when you're done. Then I'll
      respond. If you want to quit, respond with "bye", "goodbye",
      or "quit", or just press enter without saying anything at all.

      I will learn to chat from what you tell me. At first I will only know
      how to repeat what you say. The more you repeat yourself the less I
      will repeat myself. But it will take me a l-o-o-o-n-g time to start being original.
    GREETING
  end

  def listen
    puts
    print "You: "
    $stdin.readline
  end

  def ponder(text)
    words = [:start] + text.strip.split(/\s+/) + [:end]
    @starters.add(words[1])
    (0...words.length - 2).each do |i|
      *bigram, word = words[i...i + 3]
      (@bigrams[bigram] ||= Cathy.new).add word
    end
  end

  def respond
    words = [w1 = @starters.pick]
    w2 = @bigrams[[:start, w1]].pick
    while w2 != :end
      words << w2
      w3 = @bigrams[[w1, w2]].pick
      w1 = w2
      w2 = w3
    end
    puts
    puts "Cathy: #{words.join " "}"
  end

  def farewell
    puts
    puts "Cathy: It's been good chatting with you!"
  end
end
