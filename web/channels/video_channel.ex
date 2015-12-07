
defmodule Rumbl.VideoChannel do
  alias Rumbl.AnnotationView
  use Rumbl.Web, :channel

  def join("videos:" <> video_id, _params, socket) do
    video = Repo.get!(Rumbl.Video, video_id)
    annotations = Repo.all(from a in assoc(video, :annotations),
     order_by: [desc: a.at], limit: 200, preload: [:user])
    resp = %{annotations: Phoenix.View
    .render_many(annotations, AnnotationView, "annotation.json")}
    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in("new_annotation", params, socket) do
    user = socket.assigns.current_user
    changeset =
      user
      |> build(:annotations, video_id: elem(Integer.parse(socket.assigns.video_id),0))
      |> Rumbl.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          user: Rumbl.UserView.render("user.json", %{user: user}),
          body: params["body"],
          at: params["at"]
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
