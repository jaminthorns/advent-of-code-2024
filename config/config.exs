import Config

config :advent_of_code, year: 2024

if File.exists?("config/secret.exs") do
  Code.eval_file("config/secret.exs")
end
