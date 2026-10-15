# Demo 4 Controller: MCP Scheduler + MCP Persistence
#
# Shows how an AIsuru agent can use two platform-level MCP capabilities
# together: scheduling tasks to run at a later time, and persisting data
# across turns/sessions. Like Demo 1-3, nothing runs locally: both MCP
# servers are provided directly by the AIsuru platform, so there is no
# database, no ngrok tunnel and no self-hosted MCP server behind this page.
#
# Unlike Demo 1-3, this page embeds no <memori-client> and asks for no agent
# IDs. A scheduled task needs to reach a conversation, and its result needs
# to persist, across a gap that can be minutes or hours -- that requires the
# stable identity of the agent's own chat on AIsuru, not the disposable
# session of a web component embedded on a public page. The run-through
# therefore happens inside AIsuru, and this page is only the setup guide
# (same reasoning as Demo 7).
#
# That leaves the controller with no state at all: `index` renders a static
# page.
class Demo4Controller < ApplicationController
  def index
  end
end
