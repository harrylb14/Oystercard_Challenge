require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :station, zone: 1 }
  let(:exit_station) { double :station, zone: 1 }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }
  let(:top_up) { subject.top_up(Oystercard::MINIMUM_AMOUNT) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:touch_out) { subject.touch_out (exit_station) }

  it 'Adds balance of zero to a new card' do
    expect(subject.balance).to eq(0)
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
    
    it 'throws an error if balance is less than minimum amount' do
      expect { touch_in }.to raise_error 'Insufficient funds'
    end
  
    it 'deducts penalty fare if card is not touched out' do 
      top_up
      subject.touch_in(entry_station)
      expect { subject.touch_in(entry_station) }.to change{ subject.balance }.by(-Journey::PENALTY_FARE)
    end

    it 'does not deduct penalty fare if chard is touched out' do
      top_up
      expect { subject.touch_in(entry_station) }.not_to change{ subject.balance }
    end
  end

  describe '#touch_out' do
    
    it 'Deducts balance by the minimum amount if journey is complete' do
      top_up
      touch_in
      expect { touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_AMOUNT)
    end
    it 'Deducts balance by penalty fare if not topped in' do
      top_up
      expect { touch_out }.to change{ subject.balance }.by(-Journey::PENALTY_FARE)
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

