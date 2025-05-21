#! /usr/bin/ruby -w

#Represents a Rogerian psychiatrist
class Shrink

    #initializes 'memory' of Eliza.
    def initialize()
      @he="he"
      @she="she"
      @they="they"
    end
  
    #read a statement and convert it to a psychiatric response.
    def generateResponse(blather)
      #downcase for ease of substitution
      blather = blather.downcase
  
      #change 'you', 'your', etc. to uppercase 'I', 'MY'
      blather.gsub!(/\byour\b/,"MY")
      blather.gsub!(/\byou\b/,'I')
      blather.gsub!(/\bi was\b/,'i were')
      blather.gsub!(/\bi am\b/,'i are')
  
      #Replace 'my' with 'your', 'me' with 'you', 'I' with 'you', etc.
      blather.gsub!(/\bmy\b/,"your")
      blather.gsub!(/\bme\b/,"you")
      blather.gsub!(/\bi\b/,'you')
  
      #Sub in past references, but only for the 1st occurrence or it looks weird
      blather.sub!(/\b(he|him)\b/, @he)
      blather.sub!(/\b(she|her)\b/, @she)
      blather.sub!(/\b(they|them)\b/, @they)
  
      #Get future references -- note that these do NOT change the immediate output
      hePat=/.*\b(your (father|brother|(ex-?)?(husband|boyfriend)))\b.*/
      shePat = /.*\b(your (mother|sister|(ex-?)?(wife|girlfriend)))\b.*/
      theyPat=/.*\bof(\w+)\b.*/
      @he=blather.sub(hePat, '\1').chomp if blather =~ hePat 
      @she=blather.sub(shePat, '\1').chomp if blather =~ shePat
      #support for they, following the pattern for "he" and "she".
      @they=blather.sub(theyPat, '\1').chomp if blather =~ theyPat
  
      #Deal with name
      namePat=/.*\byour name is (\w+).*/
      @name=blather.sub(namePat,'\1')
      blather.sub!(namePat,'nice to meet you, \1.  How can I help you')

      #remove well or perhaps from beginning of sentence
      blather.sub!(/\b(well|perhaps|also),(\s+)\b/, "")

      #Are you, eliza respond with IS IT IMPORTANT IF I AM <original statement>
      blank_you = /.*\bare I (.+)\b.*/
      return ("IS IT IMPORTANT IF I AM " + blather.sub(blank_you, '\1') + "?") if blather =~ blank_you

      #always, never, CAN YOU BE MORE SPECIFIC?
      not_specific = /.*\b(always|never)\b.*/
      return "CAN YOU BE MORE SPECIFIC?" if blather =~ not_specific

      #Finally, add one change of your own to make Eliza seem more human.
      question = /.*\bI think (.+)\b.*/
      return ("WHY DO YOU THINK " + blather.sub(question, '\1') + "?") if blather =~ question
  
      #results are uppercased, for aesthetics.
      return blather.upcase.chomp + "?"
    end
  end
  
  
  #main -- reads from standard input unless -test is the first parameter.
  eliza = Shrink.new()
  if ARGV[0] == "-test"
      ['My girlfriend never listens to me',
       "I think she might be deaf",
       "yes",
       "I am afraid of clowns",
       "Well, they just seem creepy",
       "Also, when I was a kid, a clown killed my dad",
        "Are you a clown in disguise?",
        "You think I can fly?",
      ].each do |stmt|
          puts stmt
          puts eliza.generateResponse(stmt)
      end
  else
    while line = gets
      response = eliza.generateResponse line
      puts response
    end
  end
  