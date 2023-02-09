json.array!(@puppies) do |puppy|
  json.extract! puppy, :id, :TEAM_ID, :name, :breed, :sex, :age, :fun_fact, :score_touchdowns, :score_penalties, :score_takeaways, :score_tackles, :pic
  json.url puppy_url(puppy, format: :json)
end
