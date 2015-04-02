json.array!(@projects) do |project|
  json.extract! project, :id, :title, :organization, :contact, :description, :oncampus, :islegacy
  json.url project_url(project, format: :json)
end
