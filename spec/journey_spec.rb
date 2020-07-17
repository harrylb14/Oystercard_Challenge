require 'journey'
describe Journey do
  
  let(:entry_station) { double :station, name: "Marylebone", zone: 1 }
  let(:final_station) { double :station, zone: 1 }
  let(:subject) {described_class.new(entry_station) }
  it 'gives the journey an entry station if provided' do
    expect(subject.entry_station.name).to eq "Marylebone" 
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

  describe '#fare' do
    it 'returns the penalty fare if there is an exit station but no entry station provided' do
      journey = Journey.new
      journey.finish(final_station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
    it 'returns the penalty fare if there is an entry station but no exit station' do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
    it 'returns the minimum amount if journey is between the same zone and complete' do
      subject.finish(final_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_AMOUNT
    end
    it 'returns the minimum amount plus 1 if journey crosses one zone' do
      update_zones(2,1)
      subject.finish(final_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_AMOUNT + 1
    end
    it 'returns the minimum amount plus 2 if journey crosses 2 zones' do
      update_zones(3,5)
      subject.finish(final_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_AMOUNT + 2
    end
  end

  def update_zones(entry_zone, exit_zone)
    allow(entry_station).to receive(:zone).and_return(entry_zone)
    allow(final_station).to receive(:zone).and_return(exit_zone)
  end
end
