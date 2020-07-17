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
      subject.current_journey = journey
      expect(journey).to receive(:exit_station=)
      subject.finish(station)
     end
    it 'pushes the journey to the journeys array' do
      allow(journey).to receive(:exit_station=).with(station)
      subject.current_journey = journey
      subject.finish(station)
      expect(subject.journeys).to include journey
    end
    it 'clears the current journey' do
      allow(journey).to receive(:exit_station=).with(station)
      subject.current_journey = journey
      subject.finish(station)
      expect(subject.current_journey).to eq nil
    end
  end
end