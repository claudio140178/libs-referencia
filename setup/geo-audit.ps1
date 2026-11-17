$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
# =====================================================================
#  Hook SessionStart: auditoria GEO automática (geo-optimizer-skill)
#  - Acha a URL do site do projeto (ou lê .claude/site-url)
#  - Roda "geo audit" em segundo plano no máximo 1x a cada 24h
#  - Mostra ao Claude a nota da última auditoria
#  Resultado: .claude/kickoff.geo.txt (já coberto pelo .gitignore ".claude/kickoff.*")
# =====================================================================
$raw = [Console]::In.ReadToEnd()
$cwd = (Get-Location).Path
if ($raw) { try { $j = $raw | ConvertFrom-Json; if ($j.cwd) { $cwd = $j.cwd } } catch {} }
$cwd = $cwd.TrimEnd('\').TrimEnd('/')

$home0 = $env:USERPROFILE
$ignorar = @($home0, "$home0\.claude", 'C:', 'D:', 'C:\Windows')
$prefixos = @('D:\reference-libs', 'C:\reference-libs', "$home0\Documents\libs-referencia", "$home0\.claude")
if ($ignorar -contains $cwd) { exit 0 }
foreach ($p in $prefixos) { if ($cwd -like "$p*") { exit 0 } }

function Ler($rel) { $f = Join-Path $cwd $rel; if (Test-Path $f -PathType Leaf) { Get-Content $f -Raw } else { $null } }
function UrlOk($u) { $u -and $u -match '^https?://' -and $u -notmatch 'localhost|127\.0\.0\.1|0\.0\.0\.0|example\.(com|org)|\$\{' }

# ---------- 1) Descobrir a URL do site ----------
$url = $null
$manual = Ler '.claude\site-url'
if ($manual) { $url = ($manual -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -First 1).Trim() }
if ($url -eq 'nenhum') { exit 0 }                                   # projeto marcado como "não é site"

if (-not (UrlOk $url)) {
  $url = $null
  $cname = Ler 'CNAME'; if (-not $cname) { $cname = Ler 'public\CNAME' }
  if ($cname) { $url = 'https://' + ($cname.Trim() -split "`r?`n")[0].Trim() }
}
if (-not (UrlOk $url)) {
  $url = $null
  $padroes = @(
    @('astro.config.mjs', 'site\s*:\s*[''"](https?://[^''"]+)'),
    @('astro.config.ts',  'site\s*:\s*[''"](https?://[^''"]+)'),
    @('next-sitemap.config.js', 'siteUrl\s*:\s*[''"](https?://[^''"]+)'),
    @('next-sitemap.config.cjs', 'siteUrl\s*:\s*[''"](https?://[^''"]+)'),
    @('.env.production', '(?m)^(?:NEXT_PUBLIC_|PUBLIC_|VITE_)?SITE_URL\s*=\s*"?(https?://[^"\s]+)'),
    @('.env', '(?m)^(?:NEXT_PUBLIC_|PUBLIC_|VITE_)?SITE_URL\s*=\s*"?(https?://[^"\s]+)'),
    @('package.json', '"homepage"\s*:\s*"(https?://[^"]+)"'),
    @('public\robots.txt', '(?m)^Sitemap:\s*(https?://[^/\s]+)'),
    @('robots.txt', '(?m)^Sitemap:\s*(https?://[^/\s]+)'),
    @('public\sitemap.xml', '<loc>\s*(https?://[^/<\s]+)'),
    @('sitemap.xml', '<loc>\s*(https?://[^/<\s]+)')
  )
  foreach ($p in $padroes) {
    $txt = Ler $p[0]
    if ($txt -and $txt -match $p[1]) { $cand = $Matches[1].TrimEnd('/'); if (UrlOk $cand) { $url = $cand; break } }
  }
}

if (-not (UrlOk $url)) {
  # Parece site? Então avisa como ativar; se não parece, fica quieto.
  $site = @('index.html','astro.config.mjs','astro.config.ts','next.config.js','next.config.mjs','next.config.ts','public\index.html','src\pages','app\layout.tsx','src\app\layout.tsx') |
          Where-Object { Test-Path (Join-Path $cwd $_) }
  if ($site) {
    Write-Output "GEO: este projeto parece um site, mas não achei a URL publicada. Para ativar a auditoria GEO automática, grave o domínio em .claude/site-url (ex.: https://meusite.com.br). Se NÃO for um site público, grave a palavra: nenhum"
  }
  exit 0
}
$url = $url.TrimEnd('/')

# ---------- 2) Rodar a auditoria em segundo plano (máx. 1x/24h) ----------
$dir  = Join-Path $cwd '.claude'
New-Item -ItemType Directory -Force $dir | Out-Null
$out  = Join-Path $dir 'kickoff.geo.txt'
$lock = Join-Path $dir 'kickoff.geo.lock'
$uvx  = (Get-Command uvx -ErrorAction SilentlyContinue).Source
if (-not $uvx) { $cand = Join-Path $home0 '.local\bin\uvx.exe'; if (Test-Path $cand) { $uvx = $cand } }

$velho   = -not (Test-Path $out) -or ((Get-Date) - (Get-Item $out).LastWriteTime).TotalHours -ge 24
$rodando = (Test-Path $lock) -and (((Get-Date) - (Get-Item $lock).LastWriteTime).TotalMinutes -lt 15)
$disparou = $false
if ($velho -and -not $rodando -and $uvx) {
  Set-Content $lock (Get-Date -Format o)
  $tmp = "$out.tmp"
  $cmd = "& '$uvx' --from geo-optimizer-skill geo audit --url '$url' --format text --save-history --output '$tmp' *> `$null; " +
         "if ((Test-Path '$tmp') -and (Get-Item '$tmp').Length -gt 0) { Move-Item -Force '$tmp' '$out' } else { Remove-Item -Force '$tmp' -EA SilentlyContinue }; " +
         "Remove-Item -Force '$lock' -EA SilentlyContinue"
  $enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
  $exe = if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') { 'powershell' } else { 'pwsh' }
  $args0 = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc)
  if ($exe -eq 'powershell') { Start-Process $exe -ArgumentList $args0 -WindowStyle Hidden | Out-Null }
  else { Start-Process $exe -ArgumentList $args0 | Out-Null }
  $disparou = $true
}

# ---------- 3) Contar ao Claude o resultado da última auditoria ----------
if (Test-Path $out) {
  $res  = Get-Content $out -Raw
  $nota = if ($res -match '\[[^\]]*\]\s+(\d{1,3})/100') { [int]$Matches[1] } else { $null }
  $quando = (Get-Item $out).LastWriteTime.ToString('dd/MM/yyyy HH:mm')
  $faixa = if ($null -eq $nota) { 'nota não identificada' } elseif ($nota -ge 86) { 'Excelente' } elseif ($nota -ge 68) { 'Bom' } elseif ($nota -ge 36) { 'Base incompleta' } else { 'Crítico' }
  $linhaNota = if ($null -ne $nota) { "$nota/100 ($faixa)" } else { $faixa }
  Write-Output "GEO ($url, auditado em $quando): $linhaNota. Relatório completo em .claude/kickoff.geo.txt."
  if ($null -ne $nota -and $nota -lt 68) {
    Write-Output "Nota abaixo de 68: se a tarefa desta sessão mexer no site, leia o relatório e proponha as correções prioritárias (pode usar 'geo fix --url $url' só em modo prévia; nunca --apply sem o usuário pedir)."
  }
} elseif ($disparou -or $rodando) {
  Write-Output "GEO: primeira auditoria de $url rodando em segundo plano; o resultado sai em .claude/kickoff.geo.txt e aparece na próxima sessão."
} elseif (-not $uvx) {
  Write-Output "GEO: auditoria automática desativada porque o 'uv' não está instalado. Rode de novo o setup\instalar-kickoff.ps1 do libs-referencia."
}
if ($disparou -and (Test-Path $out)) { Write-Output "(Auditoria nova de $url rodando em segundo plano; atualiza o relatório em alguns segundos.)" }
exit 0
