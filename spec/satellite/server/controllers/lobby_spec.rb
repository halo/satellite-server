require 'gamesocket/event'
require 'satellite/server/controllers/briefing'
require 'satellite/server/controllers/lobby'
require 'satellite/server/models/candidate'

describe Satellite::Server::Controllers::Lobby do

  before do
    @it = Satellite::Server::Controllers::Lobby.new
  end

  describe '#on_event' do
    it 'switches to briefing when new game was requested' do
      @it.should_receive(:switch) do |new_controller|
        new_controller.should be_instance_of Satellite::Server::Controllers::Briefing
        new_controller.creator_id.should == 'abcdabcd'
      end
      @it.on_event GameSocket::Event.new kind: :new_game, sender_id: 'abcdabcd'
    end
  end

  context 'no Candidates' do
    describe '#update' do
      it 'sends nothing' do
        @it.should_not_receive(:broadcast)
        @it.update
      end
    end
  end

  context 'some Candidates' do
    before do
      Satellite::Server::Models::Candidate.create gamertag: 'Bob'
      Satellite::Server::Models::Candidate.create gamertag: 'Joe'
    end

    after do
      Satellite::Server::Models::Candidate.destroy_all
    end

    describe '#update' do
      it 'sends nothing' do
        @it.should_receive(:broadcast) do |kind, data|
          kind.should == :candidates
          data.size.should == 2
          data.first['gamertag'].should == 'Bob'
          data.last['gamertag'].should == 'Joe'
        end
        @it.update
      end
    end
  end

end
