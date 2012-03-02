module RubyQuiz
    class SecretSanta
        attr_reader :participants,:non_selected

        def initialize(participants = Array.new(), non_selected = Array.new())
            @participants, @non_selected = participants, non_selected
            input_participants unless participants.length > 0

            participants.map { |p| populate_acceptable_pick(p) }
        end

        def pick_out_of_a_hat
            participant = @participants[0]
            # populate_acceptable_pick(participant)
            while selected = participant.get_random_acceptable_pick(non_selected) do
                non_selected = remove_participant(selected)
                if(non_selected.length == 0)
                    participant.clear_already_picked_list
                    return 1
                end
                if (SecretSanta.new(participants[1..-1], non_selected).pick_out_of_a_hat == 1) then
                    participant.clear_already_picked_list
                    return 1
                end
                non_selected.unshift(selected)
            end
            participant.clear_already_picked_list
            return 0
        end

        def list_selections()
            participants.each do |part|
                selected = part.selected
                puts "From: #{part.first} #{part.last} #{part.email}"
                puts "  To: #{selected.first} #{selected.last} #{selected.email}"
            end
        end

        def input_participants
            while line = gets do
                line.chomp
                return unless line.length > 1
                self.parse_line(line)
            end
        end

        def parse_line(line)
            input = line.split

            if input.length != 3 then
                puts "Could not parse. Enter first last <email>"
                return
            end
            input[2].sub(/[<>]/,'')
            self.add_participant(input[0], input[1], input[2])
        end

        def add_participant(first, last, email)
            new_participant = Participant.new(first,last,email)
            self.participants.push(new_participant)
            self.non_selected.push(new_participant)
        end

        def remove_participant(participant)
            new_participants = Array.new()
            non_selected.each do |candidate|
                next if participant.is_same_as(candidate)
                new_participants.push(candidate)
            end
            return new_participants
        end

        def populate_acceptable_pick(participant)
            non_selected.each do |candidate|
                next if participant.is_same_last_name_as(candidate)
                participant.add_acceptable_pick(candidate)
            end
        end

        def list_participants()
            all_participants = Array.new()
            participants.each do |part|
                all_participants.push([part.index part.first, part.last, part.email])
            end
            return all_participants
        end

    end

    class Participant
        attr_reader :first, :last, :email, :selected

        def initialize(first, last, email)
            @first, @last, @email = first, last, email
            @acceptable_picks = Array.new()
            @attempted_picks = Array.new()
        end

        def add_acceptable_pick(pick)
            @acceptable_picks.push(pick)
        end

        def get_acceptable_picks
            return @acceptable_picks
        end

        def is_same_as(candidate)
            return (first == candidate.first and last == candidate.last)
        end

        def is_same_last_name_as(candidate)
            return (last == candidate.last)
        end

        def clear_already_picked_list
            @attempted_picks = []
        end

        def get_random_acceptable_pick(remaining_participants)
            all_available_to_select = (@acceptable_picks & remaining_participants)
            @attempted_picks.each do |already_done|
                all_available_to_select = remove_participant(all_available_to_select, already_done)
            end

            return unless all_available_to_select.length > 0

            @selected = all_available_to_select[rand(all_available_to_select.length)]
            @attempted_picks.push(@selected)
            return @selected
        end

        def remove_participant(all_available_to_select, already_done)
            new_avail = Array.new()
            all_available_to_select.each do |candidate|
                next if already_done.is_same_as(candidate)
                new_avail.push(candidate)
            end
            return new_avail
        end

        def pretty_print_name
            puts "  - #{first} #{last}"
        end

    end
end
