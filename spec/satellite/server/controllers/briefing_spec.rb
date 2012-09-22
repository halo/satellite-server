require 'gamesocket/event'
require 'satellite/server/controllers/briefing'
require 'satellite/server/controllers/lobby'
require 'satellite/server/models/candidate'

describe Satellite::Server::Controllers::Briefing do

  before do
    @it = Satellite::Server::Controllers::Briefing.new creator_id: 'creator1'
    @creator = Satellite::Server::Models::Candidate.create id: 'creator1', gamertag: 'Creator'
    @joe = Satellite::Server::Models::Candidate.create id: 'joe12345', gamertag: 'Joe'
  end

  after do
    Satellite::Server::Models::Candidate.destroy_all
  end

  describe '#on_event' do
    context ':start_game' do
      it 'does not switch if not all candidates are ready' do
        @it.should_receive(:all_ready?).and_return false
        @it.should_not_receive(:switch)
        @it.on_event GameSocket::Event.new kind: :start_game, sender_id: @creator.id
      end

      it 'does not switch if not the creator requested to start the game' do
        @it.should_receive(:all_ready?).and_return true
        @it.should_not_receive(:switch)
        @it.on_event GameSocket::Event.new kind: :start_game, sender_id: @joe.id
      end

      it 'switches to briefing when new game was requested by the creator' do
        @it.should_receive(:all_ready?).and_return true
        @it.should_receive(:switch) do |new_controller|
          new_controller.should be_instance_of Satellite::Server::Controllers::Loading
        end
        @it.on_event GameSocket::Event.new kind: :start_game, sender_id: @creator.id
      end
    end

    context ':ready' do
      it 'sets a candidate into ready state' do
        @joe.should_receive(:update_attribute).once.with(:ready, true)
        @it.on_event GameSocket::Event.new kind: :ready, sender_id: @joe.id
      end
    end
  end

  describe '#candidates_export_for_receiver' do
    it '' do
      result = @it.candidates_export_for_receiver(@creator)
      result.size.should == 2
      result.first['gamertag'].should == 'Creator'
      result.first['you'].should == true
      result.first['created_game'].should == true
      result.last['gamertag'].should == 'Joe'
      result.last['you'].should == false
      result.last['created_game'].should == false
    end
  end

end