class Oystercard

  attr_accessor :balance, :entry_station

  BALANCE_LIMIT = 90
  MINIMUM_AMOUNT = 1
  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount)
    fail "Balance cannot exceed #{BALANCE_LIMIT}" if exceeded_balance?(amount)
    
    @balance += amount
  end

  def touch_in(station)

    fail "Already touched in" if in_journey?
    fail "Insufficient funds" if insufficient_funds?

    @entry_station = station
  end

  def in_journey?
    !!@entry_station 
  end

  def touch_out

    fail "Already touched out" unless in_journey?

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
