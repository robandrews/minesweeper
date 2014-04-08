class Grid
  attr_accessor :contents
  def initialize(contents, horizontal = 8, vertical = 8, h_size=8, v_size=2)
    @vertical = vertical
    @horizontal = horizontal
    @h_size = h_size
    @v_size = v_size
    @contents = contents # || Array.new(horizontal, Array.new(vertical))
  end
  
  #need to make a method that center justifies the strings, so they are formatted properly when
  #we throw them into the draw_grid method.
  def draw_grid
    print_cap
    (0...@vertical).each do |vert_index|
      (0..@v_size).each do |block_height|
        (0...@horizontal).each do |horizontal_index|
          if block_height == (@v_size/2)
            print "|" + " "*(@h_size/2)
            "#{print @contents[horizontal_index][vert_index]}|"
            print " "*(@h_size/2-1)
          else
            print "|"; print " "*@h_size
          end
        end
        print "|\n" 
        
      end
      print_cap
    end
  end
  
  def size
    puts "This is a #{@horizontal} by #{@vertical} grid, (x,y)=(0,0) starts at upper left"
  end
  
  def print_cap
     print "+"; @horizontal.times{print "-"*@h_size + "+"}; print "\n"
  end
  
end