require 'satellite/db/store'

describe Satellite::DB::Store do

  describe '.table' do
    it 'should provide us with an empty table' do
      Satellite::DB::Store.table(:animals).should == {}
    end

    it 'should permanently store data in a table' do
      table = Satellite::DB::Store.table(:planets)
      table[:earth] = 'blue'
      Satellite::DB::Store.table(:planets).should == { :earth => 'blue' }
    end
  end

end
