require 'rspec'
require 'net/http'
require_relative 'constants'
require_relative '../lib/http_data_source'

describe HTTPDataSource do

  describe '#filter_repos' do
    context 'given an array of non-empty hashes' do
      it 'filters out private and forked repo hashes' do
        data_source = HTTPDataSource.new
        expect(data_source.send(:filter_repos, UNFILTERED_REPO_LIST)).to eq(FILTERED_REPO_LIST)
      end
    end
  end

  describe '#merge_repos_languages' do
    context 'given an array of non-empty hashes' do
      it 'accepts the array of hashes and returns a merged hash ' do
        data_source = HTTPDataSource.new
        expect(data_source.send(:merge_repos_languages, UNMERGED_LANGUAGES)).to eq(MERGED_LANGUAGES)
      end
    end

    context 'given an array of both empty and non-empty hashes' do
      it 'accepts the array of hashes and returns a merged hash' do
        data_source = HTTPDataSource.new
        languages_hash = []
        languages_hash.replace(UNMERGED_LANGUAGES)
        languages_hash.push({})
        expect(data_source.send(:merge_repos_languages, UNMERGED_LANGUAGES)).to eq(MERGED_LANGUAGES)
      end
    end
  end

  describe '#send_http_get' do
    context 'when a server error occurs' do
      it 'propagates the exception instead of supressing it' do
        data_source = HTTPDataSource.new
        bad_response = Net::HTTPServerError.new("1.1", "301", "Error")
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(bad_response)
        expect {data_source.send(:send_http_get, ROOT_ENDPOINT_URI)}.to raise_error(Net::HTTPExceptions)
      end
    end

    context 'when communication with server is successful' do
      it 'the JSON body of the response is parsed and returned correctly' do
        data_source = HTTPDataSource.new
        successful_response = Net::HTTPSuccess.new("1.1", "200", "")
        allow(successful_response).to receive(:body).and_return("{\"some_key\": \"some_value\"}")
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(successful_response)
        expect(data_source.send(:send_http_get, ROOT_ENDPOINT_URI)).to eq({"some_key" => "some_value"})
      end
    end
  end

end
