module Jekyll
  class SnippetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @attributes = {}
      
      markup.scan(::Liquid::TagAttributes) do |key, value|
        @attributes[key] = value.gsub(/^'|"/, '').gsub(/'|"$/, '')
      end
      
      @src = @attributes['src']
      lang = @attributes['lang']
      
      tag = @attributes['tag']
      lines = @attributes['lines']
      
      if lines
        start, stop = lines.split("-")[0...2].map {|l| l.to_i }
      end
      
      
      if @src and lang
        if lines
          filetext = readFileLines(start, stop)
        elsif tag
          filetext = readFileTags(tag)
        else
          filetext = readFileComplete()
        end
        
        linenos = @attributes['linenos'] || ""
        
        text = "{% highlight #{lang} #{linenos} %}\n#{filetext}{% endhighlight %}"
        @tag = Liquid::Template.parse(text)
      
      else
        raise SyntaxError.new <<-eos
Syntax Error in tag 'snippet'
while parsing the following markup: 
  #{markup}
Valid syntax: snippet src:<file> lang:<lang> [linenos] [lines:start-stop] [tag:tagname]
eos
      end
    end
    
    def readFileComplete()
      return File.readlines(@src).join("")
    end
    
    def readFileLines(start, stop)
      File.readlines(@src)[start .. stop].join("")
    end
    
    def readFileTags(tag)
      start = "[snippet:#{tag} start]"
      stop = "[snippet:#{tag} stop]"
      
      f = File.open(@src, "r")
      str = ""
      found = false
      for line in f.each_line
        if not found
          found = ( not line.index(start).nil?)
        else
          if line.index(stop)
            break
          else
            str << line
          end
        end
        
      end
      f.close
      
      warn "snippet: tag '#{tag}' not found in file '#{@src}'" unless found
      
      return str
    end
    
    def render(context)
      @tag.render(context)
    end
  end
end

Liquid::Template.register_tag('snippet', Jekyll::SnippetTag)
