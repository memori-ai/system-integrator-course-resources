param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("filesystem", "mysql", "stop")]
    [string]$Target
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "Stopping all MCP servers..." -ForegroundColor Yellow
docker compose --profile mcp-filesystem stop
docker compose --profile mcp-mysql stop

switch ($Target) {
    "filesystem" {
        docker compose --profile mcp-filesystem up -d
        Write-Host "✅ MCP Filesystem server attivo" -ForegroundColor Green
    }
    "mysql" {
        docker compose --profile mcp-mysql up -d
        Write-Host "✅ MCP MySQL server attivo" -ForegroundColor Green
    }
    "stop" {
        Write-Host "✅ Tutti i tunnel ngrok fermati" -ForegroundColor Green
    }
}
