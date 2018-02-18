require 'rspec'
require_relative 'constants'
require_relative '../lib/langstats_facade'

describe LangstatsFacade do

  describe '#calculate_percentages' do
    context 'given a hash with numeric values' do
      it 'accepts the hash and returns a new hash with the percentages of the values over their sum' do
        facade = LangstatsFacade.new double HTTPDataSource
        expect(facade.send(:calculate_percentages, MERGED_LANGUAGES)).to eq(PERCENTAGES)
      end
    end
  end

  describe '#get_lang_stats' do
    context 'given an organization name' do
      it 'returns a hash containing the line code percentages for each language used' do
        mock_data_source = double HTTPDataSource
        allow(mock_data_source).to receive(:get_org_languages).with(ORGANIZATION, nil, nil).and_return(MERGED_LANGUAGES)
        facade = LangstatsFacade.new mock_data_source
        expect(facade.get_lang_stats(ORGANIZATION)).to eq(PERCENTAGES)
      end
    end
  end

end
