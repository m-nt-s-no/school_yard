class PossibleEventConflictDetector
  def initialize(proposed_event, group_members)
    @proposed_event = proposed_event
    @group_members = group_members
  end

  def detect_member_conflicts
    puts "detect_member_conflicts"
    puts @proposed_event.starts_at.class
    puts @proposed_event.ends_at.class
    conflicts = 0

    @group_members.each do |member|
      puts "Checking member: #{member.name}"
      member.calendar.each do |event|
        # Skip the event if it's the same as the proposed event being edited
        if @proposed_event.id && @proposed_event.id == event.id
          next
        end
        if (@proposed_event.ends_at > event.starts_at) && (@proposed_event.starts_at < event.ends_at)
          conflicts += 1
          break
        end
      end
    end

    conflicts
  end
end
