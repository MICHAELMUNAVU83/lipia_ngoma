defmodule LipiaNgoma.Mixtapes.Mixtape do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mixtapes" do
    field :status, :string
    belongs_to :dj, LipiaNgoma.Users.User
    belongs_to :client, LipiaNgoma.Users.User

    timestamps()
  end

  @doc false
  def changeset(mixtape, attrs) do
    mixtape
    |> cast(attrs, [:status, :dj_id, :client_id])
    |> validate_required([:status, :dj_id, :client_id])
  end
end
