require 'json'
require 'net/http'

class HTTPDataSource
  GITHUB_ROOT_ENDPOINT = 'https://api.github.com'
  GITHUB_ORGS_ENDPOINT = GITHUB_ROOT_ENDPOINT + '/orgs'
  GITHUB_REPOS_ENDPOINT = GITHUB_ROOT_ENDPOINT + '/repos'

  public

  def get_org_languages(organization, username = nil, password = nil)
    result = []
    org_repos = http_get_org_repos(organization, username, password)
    filter_repos(org_repos).each do |repo|
      repo_laguages = http_get_repo_languages(repo, username, password)
      result.push(repo_laguages)
    end
    merge_repos_languages(result)
  end

  private

  def http_get_org_repos(organization, username = nil, password = nil)
    org_repos_endpoint = GITHUB_ORGS_ENDPOINT + '/' + organization + '/repos'
    uri = URI(org_repos_endpoint)
    send_http_get(uri, username, password)
  end

  def http_get_repo_languages(repo, username = nil, password = nil)
    uri = URI(repo["languages_url"])
    send_http_get(uri, username, password)
  end

  def filter_repos(repos)
    repos.select do |repo|
      !repo["private"] && !repo["fork"]
    end
  end

  def merge_repos_languages(langs_hashes_array)
    merged_result = {}
    langs_hashes_array.each do |repo_languages|
      merged_result.merge!(repo_languages) {|key, oldval, newval| newval + oldval}
    end
    merged_result
  end

  def send_http_get(uri, username = nil, password = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    if username
      request.basic_auth(username, password)
    end
    response = http.request(request)
    begin
      response.value #raises exception if status code is not 2xx
      JSON.parse(response.body)
    rescue Net::HTTPExceptions => e
      raise e.exception("error communicating with server: " + e.message)
    end
  end
end
