# Demo 7 Controller: Outlook + Vibe Coder + Persistence
#
# The closing demo of the module: three MCP servers on one agent, handing work
# to each other. Outlook brings a project request in from the outside, Vibe
# Coder turns it into a working HTML/JavaScript app, and Persistence keeps a
# library of everything that has been built.
#
# Like Demo 4 and Demo 5, nothing runs locally: all three MCP servers are
# provided by the AIsuru platform, so there is no database, no ngrok tunnel and
# no self-hosted MCP server behind this page.
#
# Unlike every other demo in this module, this page embeds no <memori-client>
# and asks for no agent IDs. The Outlook MCP Server enables
# IDENTITY_STRICT_MAILBOX by default, which restricts mailbox access to the
# AIsuru account that owns the agent; a visitor arriving through an embedded
# web component is a different identity, so the mailbox calls are refused. The
# run-through therefore happens inside AIsuru, and this page is the setup
# guide plus the two downloads it needs.
#
# That leaves the controller with no state at all: `index` renders a static
# page, and `asset` serves the downloads.

class Demo7Controller < ApplicationController
  # The two downloadable assets live in ../agents/*.md, one directory above the
  # Rails app, mounted read-only into the container (see docker-compose.yml).
  # Each file wraps its payload in a fenced block: we serve just that block, so
  # the demo has a single source of truth and the attendee gets something that
  # pastes straight into AIsuru or into an email client.
  ASSET_FILES = {
    "prompt" => { file: "vibe-project-builder.md", download: "vibe-project-builder-prompt.txt" },
    "email" => { file: "email-sales-dashboard.md", download: "demo-project-email.txt" }
  }.freeze

  def index
  end

  def asset
    entry = ASSET_FILES[params[:kind]]
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
