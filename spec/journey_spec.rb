require 'journey'
describe Journey do
  
  let(:entry_station) { double :station, name: "Marylebone", zone: 1 }
  let(:final_station) { double :station, zone: 2 }
  let(:subject) {described_class.new("Marylebone") }
  it 'gives the journey an entry station if provided' do
    expect(subject.entry_station).to eq "Marylebone" 
  end

  describe '#finish' do 
    it 'finishes the journey and returns itself' do
      expect(subject.finish(final_station)).to eq subject
    end
    it 'gives the journey an exit station' do
      subject.finish(final_station)
      expect(subject.exit_station).to eq final_station
    end
  end

  describe '#complete?' do 
    it 'returns false if there is no exit station' do
      expect(subject).not_to be_complete
    end
    it 'returns true if there is an exit station' do
      subject.finish(final_station)
      expect(subject).to be_complete
    end
  end

  describe '#fare' do
    it 'returns the penalty fare if there is an exit station but no entry station provided' do
      journey = Journey.new
      journey.finish(final_station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
    it 'returns the penalty fare if there is an entry station but no exit station' do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
    it 'returns the minimum amount if journey is complete' do
      subject.finish(final_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_AMOUNT
    end
  end
end
