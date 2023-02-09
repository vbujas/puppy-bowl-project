json.array!(@teams) do |team|
  json.extract! team, :id, :TEAM_NAME, :TEAM_DESCRIPTION, :USER_ID
  json.url team_url(team, format: :json)
end
