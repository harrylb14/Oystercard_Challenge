require_relative 'journey.rb'
class Oystercard

  attr_accessor :balance, :current_journey, :journeys

  BALANCE_LIMIT = 90
  MINIMUM_AMOUNT = 1

  def initialize(balance = 0)
    @balance = balance
    @journeys = []
  end

  def top_up(amount)
    fail "Balance cannot exceed #{BALANCE_LIMIT}" if exceeded_balance?(amount)
    
    @balance += amount
  end

  def touch_in(entry_station, current_journey = Journey)

    fail "Insufficient funds" if insufficient_funds?
    deduct(@current_journey.fare) if in_journey? 
    @current_journey = current_journey.new(entry_station)
  end

  def in_journey?
    !!@current_journey && !@current_journey.complete?
  end
  
  def touch_out(exit_station, incomplete_journey = Journey)
    @current_journey ||= incomplete_journey.new
    @current_journey.finish(exit_station)
    deduct(@current_journey.fare)
    @journeys << {entry_station: current_journey.entry_station, exit_station: exit_station }
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
