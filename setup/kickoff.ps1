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

# Catálogo libs-referencia: puxa a versão mais nova do GitHub (sem travar a sessão)
$cat = Join-Path $env:USERPROFILE 'Documents\libs-referencia'
if (Test-Path (Join-Path $cat '.git')) {
  $env:GIT_TERMINAL_PROMPT = '0'
  $job = Start-Job { param($d) git -C $d pull --ff-only -q 2>$null } -ArgumentList $cat
  Wait-Job $job -Timeout 8 | Out-Null; Remove-Job $job -Force
}
$catReadme = Join-Path $cat 'README.md'
$catHash = if (Test-Path $catReadme) { (Get-FileHash $catReadme -Algorithm SHA256).Hash.Substring(0,16) } else { '' }
$catPath = $cat -replace '\\','/'
$lembrete = "PROJETO EM ANDAMENTO: siga .claude/KICKOFF.md. Antes de adicionar qualquer lib/ferramenta/serviço novo nesta sessão, consulte o catálogo $catPath/README.md (e as pastas por área) e prefira o que já está lá; se usar algo fora do catálogo, diga por quê. SEMPRE use os subagentes do catálogo instalados em ~/.claude/agents (origem $catPath/ai-agents) quando a tarefa combinar: delegue a eles (ex.: Reality Checker antes de dar algo por pronto, Code Reviewer e AI-Generated Code Security Auditor antes de subir, PPC/Tracking/Search Query para campanhas, SEO/AI Citation para sites, Multi-Agent Systems Architect para enxames)."

# Agentes do catálogo: instala/atualiza sozinho as pastas de ai-agents marcadas com .auto-instalar
$agDest = Join-Path $env:USERPROFILE '.claude\agents'
$manif = Join-Path $agDest '.libs-referencia.json'
$pastasAg = Get-ChildItem (Join-Path $cat 'ai-agents') -Directory | Where-Object { Test-Path (Join-Path $_.FullName '.auto-instalar') }
if ($pastasAg) {
  New-Item -ItemType Directory -Force $agDest | Out-Null
  $m = @{}
  if (Test-Path $manif) { try { (Get-Content $manif -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $m[$_.Name] = $_.Value } } catch {} }
  $novosAg = @(); $atualAg = 0
  foreach ($pa in $pastasAg) {
    foreach ($f in (Get-ChildItem $pa.FullName -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' })) {
      $alvo = Join-Path $agDest $f.Name
      $h = (Get-FileHash $f.FullName).Hash
      if (-not (Test-Path $alvo)) { Copy-Item $f.FullName $alvo; $m[$f.Name] = $h; $novosAg += $f.BaseName; continue }
      $hAlvo = (Get-FileHash $alvo).Hash
      if ($hAlvo -eq $h) { $m[$f.Name] = $h; continue }
      # atualiza só se o arquivo instalado ainda é o que o catálogo instalou (não sobrescreve edição sua)
      if ($m.ContainsKey($f.Name) -and $m[$f.Name] -eq $hAlvo) { Copy-Item $f.FullName $alvo -Force; $m[$f.Name] = $h; $atualAg++ }
    }
  }
  ($m | ConvertTo-Json) | Set-Content $manif -Encoding UTF8
  if ($novosAg.Count -gt 0) {
    $lista = ($novosAg | Select-Object -First 12) -join ', '; if ($novosAg.Count -gt 12) { $lista += ', ...' }
    Write-Output "AGENTES: $($novosAg.Count) subagente(s) novo(s) do libs-referencia instalado(s) em ~/.claude/agents ($lista). Ficam disponíveis a partir da próxima sessão (ou /agents)."
  }
  if ($atualAg -gt 0) { Write-Output "AGENTES: $atualAg subagente(s) do libs-referencia atualizado(s)." }
}

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
$catDone = Join-Path $cwd '.claude\kickoff.cat'
if (-not (Test-Path $done) -and (Test-Path (Join-Path $cwd '.claude\KICKOFF.md'))) {
  Set-Content $done $fp; if ($catHash) { Set-Content $catDone $catHash }
  Write-Output $lembrete; exit 0
}
if (Test-Path $done) {
  $mudouArsenal = $refOk -and ((Get-Content $done -Raw).Trim() -ne $fp)      # D: fora não gera alarme falso
  $mudouCat = $catHash -and (-not (Test-Path $catDone) -or (Get-Content $catDone -Raw).Trim() -ne $catHash)
  if ($mudouArsenal -or $mudouCat) {
    $oque = @(); if ($mudouCat) { $oque += 'itens novos no catálogo libs-referencia' }; if ($mudouArsenal) { $oque += 'skills/MCPs/repos novos' }
    Write-Output "ARSENAL ATUALIZADO: $($oque -join ' e ') desde o último kickoff deste projeto."
    Write-Output "Rode o subagente 'kickoff-projeto' em PRIMEIRO PLANO, em MODO ATUALIZAÇÃO. Impressão digital: $fp"
    if ($catHash) { Set-Content $catDone $catHash }
  }
  Write-Output $lembrete
  exit 0
}
if ($catHash) { New-Item -ItemType Directory -Force (Join-Path $cwd '.claude') | Out-Null; Set-Content $catDone $catHash }

$refs = if ($refOk) { (Get-ChildItem $ref -Directory | Select-Object -Expand Name) -join ', ' } else { "INDISPONÍVEL ($ref não respondeu)" }
Write-Output "NOVO PROJETO detectado em: $cwd"
Write-Output "Antes de escrever qualquer código, rode o subagente 'kickoff-projeto' em PRIMEIRO PLANO (não em background). Impressão digital: $fp"
Write-Output "Repos em ${ref}: $refs"