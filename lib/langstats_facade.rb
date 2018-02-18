require_relative "http_data_source"

class LangstatsFacade
  public

  def initialize(data_source)
    @data_source = data_source
  end

  def get_lang_stats(organization, username = nil, password = nil)
    org_languages = @data_source.get_org_languages(organization, username, password)
    calculate_percentages(org_languages)
  end

  private

  def calculate_percentages(languages_hash)
    lines_sum = 0
    languages_hash.each do |key, value|
      lines_sum += value
    end
    languages_hash.each do |key, value|
      languages_hash[key] = (value / lines_sum.to_f) * 100
    end
  end
end
