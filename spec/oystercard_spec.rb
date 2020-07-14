require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }
  let(:top_up) { subject.top_up(Oystercard::MINIMUM_AMOUNT) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:touch_out) { subject.touch_out (exit_station) }

  it 'Adds balance of zero to a new card' do
    expect(subject.balance).to eq(0)
  end

  it 'has an empty list of journeys by default' do
    expect(subject.journeys).to be_empty
  end

  it 'stores a journey' do
    top_up
    touch_in
    touch_out
    expect(subject.journeys).to include journey
  end

  describe '#top_up(amount)' do
    it 'increases the balance by amount' do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end
    it 'throw an error if the new balance is above limit' do
      subject.top_up(Oystercard::BALANCE_LIMIT)
      expect { subject.top_up(1) }.to raise_error "Balance cannot exceed #{Oystercard::BALANCE_LIMIT}"
    end
  end

  describe '#touch_in' do
    
    it 'Prevents touching in when in journey' do
      top_up
      touch_in
      expect { subject.touch_in(entry_station) }.to raise_error("Already touched in")
    end

    it 'throws an error if balance is less than minimum amount' do
      expect { touch_in }.to raise_error 'Insufficient funds'
    end

    it 'Remembers the entry station' do
      top_up
      touch_in
      expect(subject.entry_station).to eq(entry_station)
    end
  end

  describe '#touch_out' do
    
    it 'Prevents touching out when not in journey' do
      expect { subject.touch_out(exit_station) }.to raise_error("Already touched out")
    end

    it 'Deducts balance by the minimum amount' do
      top_up
      touch_in
      expect { touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_AMOUNT)
    end

    it 'Sets entry station to nil' do
      top_up
      touch_in
      expect { touch_out }.to change{ subject.entry_station }.to nil
    end
  end

  describe '#in_journey?' do 
    it 'returns true if the card is in journey' do
      top_up
      touch_in
      expect(subject).to be_in_journey
    end

    it 'returns false if the card is not touched in' do
      expect(subject).not_to be_in_journey
    end

    it 'returns false if the card has been touched out' do
      top_up
      touch_in
      touch_out
      expect(subject).not_to be_in_journey
    end
  end
end

