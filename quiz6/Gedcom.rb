module RubyQuiz
  GEDCOM_ROOT  = -1
  INDI         = 0
  INDENT       = '  '

  class Gedcom
    attr_reader :gedcom_tree

    def initialize(string)
      lines=[]
      source_file = File.new(string, "r").each_line {|line| lines.push line }
      @gedcom_tree = GedcomTreeItem.new(GEDCOM_ROOT, 'gedcom', '')
      @gedcom_tree.add_children(self.parse_children(gedcom_tree, lines, nil))
    end

    def parse_children (current_element,lines,syblings)
      syblings = [] if syblings.nil?
      while lines.size > 0 do
        m = lines[0].match('\s*(\d+)\s+([^ ]+)\s+(.*$)')
        if m.size != 4 then
            lines.shift
            next
        end

        new_tree_element = GedcomTreeItem.new(m[1].to_i, m[2], m[3])
        return syblings if (m[1].to_i < current_element.level)

        lines.shift
        if (m[1].to_i == current_element.level)
          new_tree_element.add_children(self.parse_children(new_tree_element,lines,nil))
          syblings.push(new_tree_element)
        else
          current_element.add_children(self.parse_children(new_tree_element,lines,[ new_tree_element ]))
          return self.parse_children(current_element,lines,syblings)
        end
      end
      return syblings
    end

    def print_xml
      @gedcom_tree.print_tree
    end
  end

  class GedcomTreeItem
    attr_reader :level, :label, :value, :children

    def initialize(level, label, value)
      @level, @label, @value = level, label, value
      @children = []
    end

    def add_children(children_to_add = [])
      children_to_add.each { |child| @children.push(child) }
    end

    def print_tree
      return_string = "\n" + (INDENT * (@level + 1))
      if @children.size == 0 then
        return_string << "<#{@label.downcase}>#{value}</#{@label.downcase}>"
      else
        case @level
        when GEDCOM_ROOT
          return_string << "<#{@label.downcase}>"
        when INDI
          return_string << "<indi id=\"#{@label}\">"
        else
          return_string << "<#{@label.downcase} value=\"#{value}\">"
        end

        @children.each { |child| return_string << child.print_tree }

        return_string << "\n" + (INDENT * (@level + 1))
        case @level
        when INDI
          return_string << "</#{@value.downcase}>"
        else
          return_string << "</#{@label.downcase}>"
        end
      end
    end

  end
end
