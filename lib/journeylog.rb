require_relative 'journey'
class JourneyLog
  attr_accessor :journey_class, :current_journey
  def initialize(journey_class: Journey)
    @journey_class = journey_class
    @journeys = []
  end

  def start(entry_station)
    @current_journey = journey_class.new(entry_station)
  end

  def finish(exit_station)
    current_journey.exit_station = exit_station
    @journeys << current_journey
    @current_journey = nil
  end

  def journeys
    @journeys.dup
  end

 private 

  def this_journey
    @current_journey ||= journey_class.new
  end

end