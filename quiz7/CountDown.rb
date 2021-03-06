module RubyQuiz
  class CountDown
    attr_reader :numbers, :target, :closest_value, :closest_solution, :found

    def initialize(numbers_to_use, target)
      @numbers = (numbers_to_use.split(",")).collect { |n| n.to_i }
      @target = target.to_i
      found = 0
    end

    def find_solution()
      (1..@numbers.length).each { |num_cards_used|
        @numbers.combination(num_cards_used).to_a.uniq.each { |sn|

          sn.permutation.to_a.each { |attempting_array|
            operator_arrays = [['*'] * (attempting_array.length-1),
                ['+'] * (attempting_array.length-1),
                ['-'] * (attempting_array.length-1),
                ['/'] * (attempting_array.length-1)].flatten.combination(attempting_array.length - 1).to_a.uniq

            num_possible_parens = (num_cards_used * (num_cards_used + 1)) / 2
            (0..num_possible_parens).each { |number_of_parens| 
              paren_arrays_open  = [['('] * number_of_parens,
                                    [' '] * (num_possible_parens - number_of_parens)].flatten.permutation.to_a.uniq
              paren_arrays_open.each { |popen|
                paren_arrays_close = [[')'] * number_of_parens,
                                      [' '] * (num_possible_parens - number_of_parens)].flatten.permutation.to_a.uniq
                paren_arrays_close.each { |pclose|
                  next if(!pclose.index([')']).nil? and !popen.index(['(']).nil? and pclose.index([')']) > popen.index(['(']))
                  next if(pclose.count([')']) != popen.count(['(']));
                  operator_arrays.each { |op|
                    computation_string = ''
                    pa = popen.zip(pclose).flatten
                    next unless(is_valid_paren_array(pa) == 1)
                    parens_open_array = popen.dup
                    parens_close_array = pclose.dup
                    (0..num_cards_used-1).each { |iter|
                      (iter..attempting_array.length-1).each { computation_string += parens_open_array.shift }
                      computation_string += "#{attempting_array[iter]}"
                      (0..iter).each { computation_string += parens_close_array.shift }
                      computation_string += "#{op[iter]}"
                    }
                    check_solution(computation_string)
                    return if(@found == 1)
                  }
                }
              }
            }
          }
        }
      }
    end

    def is_valid_paren_array(test_array)
        num_open_parens = 0
        num_close_parens = 0
        test_array.each { |value|
          if value == ')' then
              return 0 if(num_close_parens >= num_open_parens)
              num_close_parens+=1
          end
          if value == '(' then
              num_open_parens+=1
          end
        }
        return 1 if (num_open_parens == num_close_parens)
        return 0
    end

    def check_solution(string)
        begin
puts(string)
           this_value = eval(string).to_f
        if this_value == @target then
            @found = 1
            @closest_solution = string
        else
            if((@closest_value.nil?) or ((this_value - @target).abs < (@closest_value - @target).abs)) then
                @closest_value = this_value
                @closest_solution = string
            end
        end
        rescue Exception => exc
            return
        end
    end
  end
end

