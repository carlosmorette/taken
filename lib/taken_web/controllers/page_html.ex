defmodule TakenWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use TakenWeb, :html

  embed_templates "page_html/*"
end
