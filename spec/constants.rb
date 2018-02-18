require 'net/http'

ORGANIZATION = 'dummy'
ROOT_ENDPOINT_URI = URI('https://example.com')
UNFILTERED_REPO_LIST = [{"id" => 1, "private" => false, "fork" => false},
                        {"id" => 2, "private" => false, "fork" => true},
                        {"id" => 3, "private" => true, "fork" => false},
                        {"id" => 4, "private" => true, "fork" => true}]
FILTERED_REPO_LIST = [{"id" => 1, "private" => false, "fork" => false}]
UNMERGED_LANGUAGES = [{"Java": 2, "Haskell": 4}, {"Ruby": 6}, {"Java": 8}]
MERGED_LANGUAGES = {"Java": 10, "Haskell": 4, "Ruby": 6}
PERCENTAGES = {"Java": 50.0, "Haskell": 20.0, "Ruby": 30.0}
