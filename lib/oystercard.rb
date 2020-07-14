class Oystercard

  attr_accessor :balance, :entry_station, :journeys

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

  def touch_in(entry_station)

    fail "Already touched in" if in_journey?
    fail "Insufficient funds" if insufficient_funds?

    @entry_station = entry_station
  end

  def in_journey?
    !!@entry_station 
  end

  def touch_out(exit_station)

    fail "Already touched out" unless in_journey?
 
    @journeys << {entry_station: @entry_station, exit_station: exit_station}
    @entry_station = nil
    deduct(MINIMUM_AMOUNT)
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
