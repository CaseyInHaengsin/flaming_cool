defmodule FlamingCoolWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use FlamingCoolWeb, :controller` and
  `use FlamingCoolWeb, :live_view`.
  """
  use FlamingCoolWeb, :html

  embed_templates "layouts/*"
end
