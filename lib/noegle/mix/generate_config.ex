defmodule Mix.Tasks.Noegle.Generate.Config do
  use Mix.Task
  import Mix.Generator

  @moduledoc """
  Mix task to generate the required configuration section in config/config.exs
  """

  @doc """
  `mix noegle.generate.config` will insert the default config section in to `config/config.exs`
  if it doesn't already exist
  """
  def run(_) do
    config_path = "./config/config.exs"

    base_module = guess_application_name
    user = "#{base_module}.User"
    repo = "#{base_module}.Repo"
    login_path = "/sessions/new"

    config = default_config(user, repo, login_path)

    if noegle_config_exists?(config_path) do
      Mix.shell.error("Noegle configuration section already exists! Please remove and try again..")
      Mix.shell.info("..or insert this manually:")
      Mix.shell.info("")
      Mix.shell.info(config)
    else

      Mix.shell.info "Adding configuration to #{config_path}"
      Mix.shell.info("")
      Mix.shell.info "Config:"
      Mix.shell.info config

      add_config(config_path, config)
    end
  end

  defp noegle_config_exists?(config_path) do
    {data} = with {:ok, file} <- File.open(config_path, [:read, :write, :utf8]),
      data <- IO.read(file, :all),
      :ok <- File.close(file),
    do: {data}

    String.contains?(data, "config :noegle")
  end

  defp guess_application_name do
    Mix.Project.config()[:app] |> Atom.to_string |> Macro.camelize
  end

  defp add_config(config_path, config) do
    {:ok, file} = File.open(config_path, [:read, :write, :utf8])

    IO.read(file, :all)
    IO.write(file, config)
    :ok = File.close(file)
  end

  defp default_config(user, repo, login_path) do
    """

    config :noegle,
      repo: #{repo},
      user: #{user},
      login_path: "#{login_path}",
    """
  end

end
