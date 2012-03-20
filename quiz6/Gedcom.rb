module RubyQuiz
  class Gedcom
    attr_reader :gedcom_tree

    def initialize(string)
      if string == '' then
        print 'No file name given'
      else
        self.read_file(string)
      end
    end

    def read_file(string)
      source_file = File.new(string, "r")
      lines=[]
      source_file.each_line {|line|
        lines.push line
      }
      gedcom_tree = GedcomTreeItem.new(-1, 'gencom', '')
      gedcom_tree.add_children(self.parse_children(gedcom_tree, lines))
    end

    def parse_children (current_element,lines)
      return
      # return if no more lines
      # parse into level, tag, value
      # compare_element.level to current
      # if same, then
      #   pop from array
      #   create new treeitem
      #   call parse_children current_level, lines
      # if lower level than current_element.level then
      #   current_element.add_children(self.parse_children(level, @lines))
      # if greater level
      #   return current_element   *** needs to be array of same level elements
    end

    def print_xml
      puts "hi!"
    end

  end

  class GedcomTreeItem
    attr_reader :level, :label, :value, :children

    def initialize(level, label, value)
      @level, @label, @value = level, label, value
      @children = []
    end

    def add_children(children_to_add)
      return if children_to_add.nil?
      children_to_add.map do |child|
        @children.push(child)
      end
    end

  end
end
