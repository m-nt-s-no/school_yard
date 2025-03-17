class PossibleEventConflictDetector
  def initialize(proposed_event, group_members)
    @proposed_event = proposed_event
    @group_members = group_members
  end

  def detect_member_conflicts
    conflicts = 0

    @group_members.each do |member|
      member.calendar.each do |event|
        #not all event conflicts being detected, check logic below
        if (@proposed_event.ends_at > event.starts_at) && (@proposed_event.starts_at < event.ends_at)
          conflicts += 1
          break
        end
      end
    end

    conflicts
  end
end
