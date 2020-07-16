require 'journeylog.rb'
describe JourneyLog do

  let(:station) {double :station}
  let(:journey) {double :journey}
  let(:journey_class) {double :journey_class, new: journey}
  subject {described_class.new(journey_class: journey_class)}

  describe '#start' do
    it 'starts a journey' do
      expect(journey_class).to receive(:new).with(station)
      subject.start(station)
    end
  end
  
  describe '#finish' do
    it 'adds exit_station to the journey' do
      journey1 = Journey.new
      subject.current_journey = journey1
      subject.finish("exit")
      expect(journey1.exit_station).to eq "exit"
    end
    it 'pushes the journey to the journeys array' do
      journey1 = Journey.new
      subject.current_journey = journey1
      subject.finish("exit")
      expect(subject.journeys).to include journey1
    end
  end
end