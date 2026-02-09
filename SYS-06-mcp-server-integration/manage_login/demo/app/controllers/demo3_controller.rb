# Demo 3 Controller: Filesystem MCP Server
#
# This demo shows how to connect an AIsuru agent to a custom MCP filesystem
# server running in a separate Docker container.  The agent can read, write,
# and create files inside a shared workspace directory (/test).

class Demo3Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  def index
    # Configuration values (use params or defaults)
    @memori_id = params[:memori_id]
    @owner_user_id = params[:owner_user_id]
    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    @show_agent = @memori_id.present? && @owner_user_id.present?

    # Read the current contents of the shared test/ directory so the view
    # can display them to the user (proves the agent is modifying real files).
    @workspace_files = list_workspace_files
  end

  # AJAX endpoint: restituisce solo l'HTML del tree dei file
  def workspace_files
    @workspace_files = list_workspace_files
    render partial: "demo3/explorer_tree"
  end

  def configure
    # Redirect with params to show the configured agent
    redirect_to demo3_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  private

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------

  # Return a sorted array that mirrors the directory tree under test/.
  # Each entry is a hash:
  #   { name: String, type: "dir"|"file", content: String|nil, children: Array|nil }
  # Directories come first (alphabetically), then files.
  def list_workspace_files
    workspace = Rails.root.join("test")
    return [] unless workspace.directory?

    scan_directory(workspace)
  end

  # Recursively scan *dir* and return the nested array structure.
  def scan_directory(dir)
    dir.children
       .sort_by { |p| [p.directory? ? 0 : 1, p.basename.to_s.downcase] }
       .map do |path|
         if path.directory?
           { name: path.basename.to_s, type: "dir", children: scan_directory(path) }
         else
           { name: path.basename.to_s, type: "file", content: path.read }
         end
       rescue StandardError => e
         { name: path.basename.to_s, type: "file", content: "(error: #{e.message})" }
       end
  end
end
