# Demo 5 Controller: an AIsuru agent exposed as an MCP server
#
# Two agents are shown side by side:
#   - the Expert    (agent A) is exposed as an MCP server
#   - the Assistant (agent B) consumes that MCP server as a tool
#
# Unlike Demo 1-3, nothing runs locally for this demo: no database, no ngrok
# tunnel, no self-hosted MCP server. Both ends live inside AIsuru, and this
# page is only a shell that shows the two chats side by side.
#
# This controller holds no state of its own: everything the page needs travels
# in the querystring, so the page can be reloaded or shared as a URL. No MCP
# token ever reaches this app - tokens are pasted inside AIsuru only.

class Demo5Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  def index
    @expert_memori_id = params[:expert_memori_id]
    @expert_owner_user_id = params[:expert_owner_user_id]
    @assistant_memori_id = params[:assistant_memori_id]
    @assistant_owner_user_id = params[:assistant_owner_user_id]

    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    # Both agents are needed: the whole point of the demo is comparing them.
    @show_agents = [
      @expert_memori_id,
      @expert_owner_user_id,
      @assistant_memori_id,
      @assistant_owner_user_id
    ].all?(&:present?)
  end

  # The two agent prompts live in ../agents/*.md, one directory above the Rails
  # app, and are mounted read-only into the container (see docker-compose.yml).
  # Each file wraps its prompt in a fenced block: we serve just that block, so
  # the figures the demo depends on have a single source of truth and the
  # attendee gets something they can paste straight into AIsuru.
  PROMPT_FILES = {
    "expert" => { file: "esperto-policy-acme.md", download: "expert-acme-policy-prompt.txt" },
    "assistant" => { file: "assistente-onboarding.md", download: "assistant-onboarding-prompt.txt" }
  }.freeze

  def prompt
    entry = PROMPT_FILES[params[:agent]]
    return head :not_found if entry.nil?

    path = Rails.root.join("agents", entry[:file])
    return head :not_found unless File.exist?(path)

    body = extract_fenced_block(File.read(path))
    return head :not_found if body.blank?

    send_data body, filename: entry[:download], type: "text/plain; charset=utf-8"
  end

  def configure
    redirect_to demo5_path(
      expert_memori_id: params[:expert_memori_id],
      expert_owner_user_id: params[:expert_owner_user_id],
      assistant_memori_id: params[:assistant_memori_id],
      assistant_owner_user_id: params[:assistant_owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  private

  # Returns the contents of the first ```-fenced block in the markdown file.
  def extract_fenced_block(markdown)
    inside = false
    lines = []

    markdown.each_line do |line|
      if line.start_with?("```")
        break if inside
        inside = true
        next
      end
      lines << line if inside
    end

    lines.join.strip
  end
end
