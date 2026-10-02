$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$raw = [Console]::In.ReadToEnd()
$cwd = (Get-Location).Path
if ($raw) { try { $j = $raw | ConvertFrom-Json; if ($j.cwd) { $cwd = $j.cwd } } catch {} }
$cwd = $cwd.TrimEnd('\')

# Pastas que não são projeto
$ignorar = @($env:USERPROFILE, "$env:USERPROFILE\.claude", 'C:', 'D:', 'C:\Windows')
$prefixos = @('D:\reference-libs', 'C:\reference-libs', "$env:USERPROFILE\Documents\libs-referencia", "$env:USERPROFILE\.claude")
if ($ignorar -contains $cwd) { exit 0 }
foreach ($p in $prefixos) { if ($cwd -like "$p*") { exit 0 } }

# Impressão digital: nomes de skills, plugins, MCPs e repos (sem versões)
$cl = Join-Path $env:USERPROFILE '.claude'
$itens = @()
$itens += Get-ChildItem "$cl\skills" -Directory | ForEach-Object { "skill:$($_.Name)" }
$itens += Get-ChildItem (Join-Path $cwd '.claude\skills') -Directory | ForEach-Object { "pskill:$($_.Name)" }
$ip = "$cl\plugins\installed_plugins.json"
if (Test-Path $ip) { [regex]::Matches((Get-Content $ip -Raw), '"([A-Za-z0-9_.-]+@[A-Za-z0-9_.-]+)"') | ForEach-Object { $itens += "plugin:$($_.Groups[1].Value)" } }
foreach ($f in @("$env:USERPROFILE\.claude.json", (Join-Path $cwd '.mcp.json'))) {
  if (Test-Path $f) { try { (Get-Content $f -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Name | ForEach-Object { $itens += "mcp:$_" } } catch {} }
}
$ref = if (Test-Path 'C:\reference-libs') { 'C:\reference-libs' } else { 'D:\reference-libs' }
$refOk = Test-Path $ref
if ($refOk) { $itens += Get-ChildItem $ref -Directory | ForEach-Object { "ref:$($_.Name)" } }
$txt = ($itens | Sort-Object -Unique) -join '|'
$sha = [Security.Cryptography.SHA256]::Create()
$fp  = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($txt))) -replace '-','').Substring(0,16)

$done = Join-Path $cwd '.claude\kickoff.done'
if (-not (Test-Path $done) -and (Test-Path (Join-Path $cwd '.claude\KICKOFF.md'))) { Set-Content $done $fp; exit 0 }
if (Test-Path $done) {
  if (-not $refOk) { exit 0 }                                   # D: fora: não gera alarme falso
  if ((Get-Content $done -Raw).Trim() -eq $fp) { exit 0 }       # nada mudou
  Write-Output "ARSENAL ATUALIZADO: há skills/MCPs/repos novos desde o último kickoff deste projeto."
  Write-Output "Rode o subagente 'kickoff-projeto' em PRIMEIRO PLANO, em MODO ATUALIZAÇÃO. Impressão digital: $fp"
  exit 0
}

$refs = if ($refOk) { (Get-ChildItem $ref -Directory | Select-Object -Expand Name) -join ', ' } else { "INDISPONÍVEL ($ref não respondeu)" }
Write-Output "NOVO PROJETO detectado em: $cwd"
Write-Output "Antes de escrever qualquer código, rode o subagente 'kickoff-projeto' em PRIMEIRO PLANO (não em background). Impressão digital: $fp"
Write-Output "Repos em ${ref}: $refs"