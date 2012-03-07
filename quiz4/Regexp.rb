class Regexp
    attr_reader :matching_string
    def self.build(*args)
        matching_string = String.new()
        args.each { |arg|
            if arg.to_s.match('(\d+)\.\.(\d+)') then
                start_value, end_value = $1.to_i, $2.to_i
                return unless end_value > start_value

                start_value_length = start_value.to_s.length
                end_value_length = end_value.to_s.length
                length_dif = end_value_length - start_value_length
                if length_dif > 1 then
                    matching_string += format_acceptable_value("\\d{#{start_value_length+1},#{end_value_length-1}}")
                    matching_string += add_start_matches(start_value)
                    matching_string += add_end_matches(start_value)
                else
                    while start_value <= end_value do
                        matching_string += format_acceptable_value(start_value.to_s)
                        start_value += 1
                    end
                end
            else
                matching_string += format_acceptable_value(arg.to_s)
            end
        }
        matching_string.sub!(/^\|/, "")
        puts "matching_string #{matching_string}"
        self.new(matching_string)
    end

    def self.add_start_matches(value)
        return_string = String.new()
        length_of_value = value.to_s.length
        1.upto(length_of_value) do |position|
            digit = (value.div(10**(length_of_value-position)) % 10) + 1
            digit_boundry = String.new()
            if(digit == 9) then
                digit_boundry = '9'
            else
                digit_boundry = '[' + digit.to_s + '-9]'
            end
            start_part = value.to_s.slice(0,position-1)
            end_part = String.new()
            if (length_of_value - position) > 0 then
                end_part = '\d{' + (length_of_value - position).to_s + '}'
            end
            return_string += format_acceptable_value(start_part + digit_boundry + end_part)
        end
        return return_string
    end

    def self.add_end_matches(value)
        return_string = String.new()
        length_of_value = value.to_s.length
        1.upto(length_of_value) do |position|
            digit = (value.div(10**(length_of_value-position)) % 10) - 1
            digit_boundry = String.new()
            if(digit <= 0) then
                digit_boundry = '0'
            else
                digit_boundry = '[0-' + digit.to_s + ']'
            end
            start_part = value.to_s.slice(0,position-1)
            end_part = String.new
            if (length_of_value - position) > 0 then
                end_part = '\d{' + (length_of_value - position).to_s + '}'
            end
            return_string += format_acceptable_value(start_part + digit_boundry + end_part)
        end
        return return_string
    end

    def self.format_acceptable_value(value)
        return '|^' + value + '$'
    end
end
