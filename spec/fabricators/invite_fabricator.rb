Fabricator(:invite) do
  full_name { Faker::Name.name }
  email { "lmwinr@gmail.com" }
  message { Faker::Lorem.paragraph }
end
