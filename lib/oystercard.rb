require_relative 'journeylog'
require_relative 'journey'
class Oystercard

  attr_accessor :balance, :journey_log

  BALANCE_LIMIT = 90
  MINIMUM_AMOUNT = 1

  def initialize(balance = 0, journey_log = JourneyLog.new)
    @balance = balance
    @journey_log = journey_log
  end

  def top_up(amount)
    fail "Balance cannot exceed #{BALANCE_LIMIT}" if exceeded_balance?(amount)
    
    @balance += amount
  end

  def touch_in(entry_station)

    fail "Insufficient funds" if insufficient_funds?

    deduct(@journey_log.current_journey.fare) if in_journey?
    @journey_log.start(entry_station)
  end

  def in_journey?
    !!@journey_log.current_journey 
  end
  
  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(@journey_log.journeys.last.fare)
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def insufficient_funds? 
    @balance < MINIMUM_AMOUNT
  end

  def exceeded_balance?(amount)
    @balance + amount > BALANCE_LIMIT
  end
end
