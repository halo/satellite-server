require 'satellite/server/controllers/managers/broker'

describe Satellite::Server::Controllers::Managers::Broker do

  before do
    @it = Satellite::Server::Controllers::Managers::Broker.new
    @it.add_consumer @consumer1 = mock(:consumer1)
    @it.add_consumer @consumer2 = mock(:consumer2)
  end

  after do
    @it.reset!
  end

  describe 'add_consumer' do
    it 'adds a consumer' do
      @it.consumers.should == [@consumer1, @consumer2]
    end
  end

  describe 'dispatch' do

    before do
      @letter   = Satellite::Server::Controllers::Managers::Broker::Message.new(kind: :letter, data: 'Love')
      @postcard = Satellite::Server::Controllers::Managers::Broker::Message.new(kind: :postcard, data: { nice: :picture })
      @it << @letter
      @it << @postcard
    end

    it 'dispatches all messages on queue' do
      @consumer1.should_receive(:on_message).with(@letter)
      @consumer2.should_receive(:on_message).with(@letter)
      @consumer1.should_receive(:on_message).with(@postcard)
      @consumer2.should_receive(:on_message).with(@postcard)
      @it.dispatch
    end

    it 'dipatches intermittent messages on the next run' do
      telegram = Satellite::Server::Controllers::Managers::Broker::Message.new(kind: :telegram, data: :speedy)
      email = Satellite::Server::Controllers::Managers::Broker::Message.new(kind: :email)
      @consumer1.should_receive(:on_message).with(@letter).and_return(telegram)
      @consumer2.should_receive(:on_message).with(@letter).and_return([email, email])
      @consumer1.should_receive(:on_message).with(@postcard)
      @consumer2.should_receive(:on_message).with(@postcard)
      @it.dispatch
      @consumer1.should_receive(:on_message).with(telegram)
      @consumer1.should_receive(:on_message).with(email).twice
      @consumer2.should_receive(:on_message).with(telegram)
      @consumer2.should_receive(:on_message).with(email).twice
      @it.dispatch
    end

  end

end