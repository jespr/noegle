defmodule Mix.Tasks.Noegle.Generate.Boilerplate do
  use Mix.Task
  import Mix.Generator

  @shortdoc """
  Generates boilerplate as a starting ground for your project
  """

  @moduledoc """
  Boilerplate files will be generated as a foundation for you to build upon:

  Controllers:

  * `web/controllers/noegle/session_controller.ex`
  * `web/controllers/noegle/registration_controller.ex`

  Templates:

  * `web/templates/noegle/session/new.html.eex`
  * `web/templates/noegle/registration/new.html.eex`
  * `web/templates/noegle/registration/form.html.eex`

  Views:

  * `web/views/noegle/session_view.ex`
  * `web/views/noegle/registration_view.ex`

  These are meant to be modified as you see fit.

  Example on how to run:

    `mix noegle.generate.boilerplate`

  Options:

  * `--module` this is if the programmatical way of guessing your application module-name doesn't work.
  """

  # Controllers
  embed_text :session_controller, from_file: "./web/controllers/session_controller.ex"
  embed_text :registration_controller, from_file: "./web/controllers/registration_controller.ex"

  # Templates
  embed_text :session_new, from_file: "./web/templates/session/new.html.eex"
  embed_text :registration_new, from_file: "./web/templates/registration/new.html.eex"
  embed_text :registration_form, from_file: "./web/templates/registration/form.html.eex"

  # Views
  embed_text :session_view, from_file: "./web/views/session_view.ex"
  embed_text :registration_view, from_file: "./web/views/registration_view.ex"

  @switches [
    module: :string
  ]

  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: @switches)
    base_app = opts[:module] || guess_application_name()

    controller_path = Path.join(~w(. web controllers noegle))
    template_path = Path.join(~w(. web templates noegle))
    view_path = Path.join(~w(. web views noegle))

    # Controllers
    create_file controller_path |> Path.join("session_controller.ex"), session_controller_text |> String.replace("BaseApp", base_app)
    create_file controller_path |> Path.join("registration_controller.ex"), registration_controller_text |> String.replace("BaseApp", base_app)

    # Templates
    create_file template_path |> Path.join("session/new.html.eex"), session_new_text
    create_file template_path |> Path.join("registration/new.html.eex"), registration_new_text
    create_file template_path |> Path.join("registration/form.html.eex"), registration_form_text

    # Views
    create_file view_path |> Path.join("session_view.ex"), session_view_text |> String.replace("BaseApp", base_app)
    create_file view_path |> Path.join("registration_view.ex"), registration_view_text |> String.replace("BaseApp", base_app)

    Mix.shell.info "Done creating boilerplate files!"

    Mix.shell.info("")

    Mix.shell.info """
    Add the following to web/router.ex:

      resources "/registrations", Noegle.RegistrationController, only: [:new, :create]
      resources "/sessions", Noegle.SessionController, only: [:new, :create, :delete]
    """
  end

  defp guess_application_name do
    Mix.Project.config()[:app] |> Atom.to_string |> Macro.camelize
  end
end
