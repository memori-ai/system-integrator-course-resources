# Demo 8 Controller: MCP Skills
#
# Shows what an MCP Skill actually is: a markdown file that standardizes how
# the agent handles one specific kind of interaction, loaded on demand rather
# than baked into the system prompt. The demo is a before/after: the same
# customer message, asked once with no skill loaded and once with the skill
# in place, so the class sees the standardization happen instead of being
# told about it.
#
# Like Demo 1-3, the agent runs embedded on this page (no reason for it not
# to: a skill is static instructions, not a session- or identity-bound
# capability like Demo 4's Scheduler or Demo 7's Outlook mailbox).

class Demo8Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  # The skill lives in ../agents/*.md, one directory above the Rails app,
  # mounted read-only into the container (see docker-compose.yml), same as
  # the Demo 5 and Demo 7 prompts. The file wraps its payload in a fenced
  # block: we serve just that block, so the demo has a single source of
  # truth and the attendee gets something that pastes straight into AIsuru.
  SKILL_FILES = {
    "refund-response" => { file: "skill-refund-response.md", download: "refund-response-skill.txt" }
  }.freeze

  def index
    # Configuration values (use params or defaults)
    @memori_id = params[:memori_id]
    @owner_user_id = params[:owner_user_id]
    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    @show_agent = @memori_id.present? && @owner_user_id.present?
  end

  def configure
    # Redirect with params to show the configured agent
    redirect_to demo8_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  def skill
    entry = SKILL_FILES[params[:kind]]
    return head :not_found if entry.nil?

    path = Rails.root.join("agents", entry[:file])
    return head :not_found unless File.exist?(path)

    body = extract_fenced_block(File.read(path))
    return head :not_found if body.blank?

    send_data body, filename: entry[:download], type: "text/plain; charset=utf-8"
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
