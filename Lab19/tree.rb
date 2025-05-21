class Tree
    attr_accessor :value, :left, :right
    def initialize(value, left=nil, right=nil)
      @value = value
      @left = left
      @right = right
    end

    def each_node (&block)
        block.call self.value
        # block.call self
        left.each_node(&block) if left
        right.each_node(&block) if right
    end
    
    def method_missing(m, *args)
        mn = m.to_s
        path = mn.scan(/left|right/)

        node = self

        path.each do |direction|
            if direction == 'left'
                node = node.left
            elsif direction == 'right'
                node = node.right
            end
            break if node.nil?
        end

        node
    end
  end
  
  my_tree = Tree.new(42,
                     Tree.new(3,
                              Tree.new(1,
                                       Tree.new(7,
                                                Tree.new(22),
                                                Tree.new(123)),
                                       Tree.new(32))),
                     Tree.new(99,
                              Tree.new(81)))

  my_tree.each_node do |v|
    puts v
  end
  
  arr = []
  my_tree.each_node do |v|
    arr.push v
  end
  p arr
  
  p "Getting nodes from tree"
  p my_tree.left_left
  p my_tree.right_left
  p my_tree.left_left_right
  p my_tree.left_left_left_right
  
  