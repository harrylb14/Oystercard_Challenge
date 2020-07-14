require 'oystercard'

describe Oystercard do

  let(:station) { double("Station") }
  let(:top_up) { subject.top_up(Oystercard::MINIMUM_AMOUNT) }
  let(:touch_in) {subject.touch_in(station)}

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
    it 'Changes in_journey to true' do
      top_up
      touch_in
      expect(subject.in_journey?).to eq true
    end

    it 'Prevents touching in when in journey' do
      top_up
      touch_in
      expect { subject.touch_in(station) }.to raise_error("Already touched in")
    end

    it 'throws an error if balance is less than minimum amount' do
      expect { subject.touch_in(station) }.to raise_error 'Insufficient funds'
    end

    it 'Remembers the entry station' do
      top_up
      touch_in
      expect(subject.entry_station).to eq(station)
    end
  end

  describe '#touch_out' do
    it 'Changes in_journey to false' do
      top_up
      touch_in
      subject.touch_out
      expect(subject.in_journey?).to eq false
    end

    it 'Prevents touching out when not in journey' do
      expect { subject.touch_out }.to raise_error("Already touched out")
    end

    it 'Deducts balance by the minimum amount' do
      top_up
      touch_in
      expect { subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_AMOUNT)
    end

    it 'Sets entry station to nil' do
      top_up
      touch_in
      subject.touch_out
      expect(subject.entry_station).to eq(nil)
    end
  end
end
