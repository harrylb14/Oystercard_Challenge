require_relative 'station'
class Journey
  attr_accessor :entry_station, :exit_station
  PENALTY_FARE = 6
  def initialize(entry_station=nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def finish(exit_station)
    @exit_station = exit_station
    self
  end

  def complete?
    !!@exit_station 
  end

  def fare
    @entry_station == nil || @exit_station == nil ? PENALTY_FARE : price
  end

  private 
  
  def price
    Oystercard::MINIMUM_AMOUNT + (@exit_station.zone - @entry_station.zone).abs
  end
 
end