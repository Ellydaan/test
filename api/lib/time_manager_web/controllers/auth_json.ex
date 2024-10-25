defmodule TimeManagerWeb.AuthJSON do

  def render("auth.json", %{jwt: jwt}) do
    %{
      jwt: jwt,
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: format_errors(changeset)}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end