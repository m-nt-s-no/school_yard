class EventConflictDetector
  def initialize(events)
    @events = events
  end

  def detect_event_conflicts
    conflicts = []
    @events.each do |event1|
      @events.each do |event2|
        next if event1 == event2
        if (event1.ends_at > event2.starts_at) && (event1.starts_at < event2.ends_at)
          conflicts.push(event1)
        end
      end
    end
    conflicts
  end
end
