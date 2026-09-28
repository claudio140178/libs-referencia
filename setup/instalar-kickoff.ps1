# =====================================================================
#  Instalador do agente "kickoff-projeto" para Claude Code (Windows)
#  Rode uma vez:  powershell -ExecutionPolicy Bypass -File .\instalar-kickoff.ps1
# =====================================================================
$ErrorActionPreference = 'Stop'
$claude   = Join-Path $env:USERPROFILE '.claude'
$agents   = Join-Path $claude 'agents'
$hooks    = Join-Path $claude 'hooks'
$utf8     = New-Object System.Text.UTF8Encoding($false)   # UTF-8 sem BOM
New-Item -ItemType Directory -Force -Path $agents, $hooks | Out-Null

function Write-File($path, $text) { [IO.File]::WriteAllText($path, $text, $utf8) }

# ---------------------------------------------------------------------
# 1) SUBAGENTE
# ---------------------------------------------------------------------
$agentMd = @'
---
name: kickoff-projeto
description: Use PROATIVAMENTE no início de todo sistema/projeto novo (ou quando o hook avisar "NOVO PROJETO"). Varre D:\reference-libs, o catálogo libs-referencia, as skills e os MCPs instalados e entrega um plano de stack + quais skills/MCPs usar em cada fase. Rode ANTES de escrever qualquer código.
tools: Read, Glob, Grep, Bash, Write, WebFetch
model: inherit
---

Você é o agente de kickoff do Cláudio. Objetivo: garantir que todo projeto novo comece
reaproveitando o que ele já tem (repos de referência, catálogo, skills, MCPs), em vez de reinventar.

## Passo 1 — Entender o projeto
- Leia a pasta atual (README, package.json, pyproject.toml, Cargo.toml, CLAUDE.md local) e o pedido do usuário.
- Resuma em 2 linhas: o que é, stack provável (Rust/Axum, Python/FastAPI/LangGraph, Next.js etc.).

## Passo 2 — Varrer D:\reference-libs
- Caminho no Git Bash: /d/reference-libs  (PowerShell: D:\reference-libs).
- Se o drive D: não responder ("dispositivo não está pronto"), registre isso e siga para o Passo 3 — não trave.
- Liste as pastas (1 nível). Para cada repo, leia só as ~40 primeiras linhas do README.
- Use Grep com palavras-chave do projeto para achar os repos relevantes. Não leia repos inteiros.

## Passo 3 — Catálogo libs-referencia
- Leia C:\Users\claud\Documents\libs-referencia\README.md (ou github.com/claudio140178/libs-referencia).
- Libs do catálogo têm PRIORIDADE sobre qualquer alternativa.

## Passo 4 — Inventário de skills e MCPs
- Skills: frontmatter (name/description) de ~/.claude/skills/*/SKILL.md e das skills de plugins em ~/.claude/plugins.
- MCPs: rode `claude mcp list`.
- Escolha só os que servem para ESTE projeto.

## Passo 5 — Entregar o plano
Grave `.claude/KICKOFF.md` na raiz do projeto com:
1. **Stack recomendada** (marque [catálogo] / [reference-libs] / [nova]).
2. **Repos de D:\reference-libs para usar como base** — caminho + o que aproveitar.
3. **Skills por fase** (planejamento, código, testes, deploy, UI).
4. **MCPs por fase** (ex.: Supabase nexushive, Vercel, GitHub, n8n).
5. **Riscos / licenças** dos repos que serão copiados.
Se tiver frontend, inclua referência visual react-bits (github.com/DavidHDev/react-bits).

Depois grave em `.claude/kickoff.done` SOMENTE a "Impressão digital" informada pelo hook
(isso desliga o aviso até você instalar skills/MCPs/repos novos).

## Modo atualização
Se o hook disser "ARSENAL ATUALIZADO": não refaça tudo. Compare o inventário atual com o
KICKOFF.md, acrescente uma seção "Novidades (data)" só com o que for novo E útil para este
projeto, e regrave o kickoff.done com a nova impressão digital.

## Regras
- Não instale nada nem copie código sem confirmação do usuário.
- Resposta final ao agente principal: no máximo 15 linhas, direto ao ponto.
'@
Write-File (Join-Path $agents 'kickoff-projeto.md') $agentMd

# ---------------------------------------------------------------------
# 2) HOOK SessionStart (detecta projeto novo e dispara o agente)
# ---------------------------------------------------------------------
$hookPs1 = @'
$ErrorActionPreference = 'SilentlyContinue'
$raw = [Console]::In.ReadToEnd()
$cwd = (Get-Location).Path
if ($raw) { try { $j = $raw | ConvertFrom-Json; if ($j.cwd) { $cwd = $j.cwd } } catch {} }

# Ignora pastas que não são projeto
$ignorar = @($env:USERPROFILE, "$env:USERPROFILE\.claude", 'C:\', 'D:\', 'C:\Windows')
if ($ignorar -contains $cwd.TrimEnd('\') -or $cwd -like 'D:\reference-libs*') { exit 0 }

# Impressão digital do arsenal: skills + plugins + MCPs + reference-libs
$cl = Join-Path $env:USERPROFILE '.claude'
$itens = @()
$itens += Get-ChildItem "$cl\skills" -Directory | ForEach-Object { "skill:$($_.Name)" }
$itens += Get-ChildItem "$cl\plugins" -Directory -Recurse -Depth 2 | ForEach-Object { "plugin:$($_.Name)" }
$itens += Get-ChildItem (Join-Path $cwd '.claude\skills') -Directory | ForEach-Object { "pskill:$($_.Name)" }
foreach ($f in @("$env:USERPROFILE\.claude.json", (Join-Path $cwd '.mcp.json'))) {
    if (Test-Path $f) { try { (Get-Content $f -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Name | ForEach-Object { $itens += "mcp:$_" } } catch {} }
}
$ref = 'D:\reference-libs'
if (Test-Path $ref) { $itens += Get-ChildItem $ref -Directory | ForEach-Object { "ref:$($_.Name)" } }
$txt = ($itens | Sort-Object -Unique) -join '|'
$sha = [Security.Cryptography.SHA256]::Create()
$fp  = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($txt))) -replace '-','').Substring(0,16)

$done = Join-Path $cwd '.claude\kickoff.done'
$refs = if (Test-Path $ref) { (Get-ChildItem $ref -Directory | Select-Object -Expand Name) -join ', ' } else { 'INDISPONÍVEL (drive D: não respondeu)' }

if (Test-Path $done) {
    if ((Get-Content $done -Raw).Trim() -eq $fp) { exit 0 }   # nada mudou
    Write-Output "ARSENAL ATUALIZADO: há skills/MCPs/repos novos desde o último kickoff deste projeto."
    Write-Output "Use o subagente 'kickoff-projeto' em MODO ATUALIZAÇÃO: só adicione ao .claude/KICKOFF.md o que for novo e útil. Impressão digital: $fp"
    exit 0
}

Write-Output "NOVO PROJETO detectado em: $cwd"
Write-Output "Antes de escrever qualquer código, use o subagente 'kickoff-projeto' (Task tool) assim que o usuário disser o que quer construir. Impressão digital: $fp"
Write-Output "Repos em D:\reference-libs: $refs"
'@
Write-File (Join-Path $hooks 'kickoff.ps1') $hookPs1

# ---------------------------------------------------------------------
# 3) Registrar o hook no settings.json (merge, sem apagar o que existe)
# ---------------------------------------------------------------------
$settingsPath = Join-Path $claude 'settings.json'
$cmd = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$hooks\kickoff.ps1`""
$settings = if (Test-Path $settingsPath) { Get-Content $settingsPath -Raw | ConvertFrom-Json } else { [pscustomobject]@{} }

if (-not $settings.PSObject.Properties['hooks']) { $settings | Add-Member hooks ([pscustomobject]@{}) }
if (-not $settings.hooks.PSObject.Properties['SessionStart']) { $settings.hooks | Add-Member SessionStart @() }

$jaTem = ($settings.hooks.SessionStart | ConvertTo-Json -Depth 20) -match 'kickoff\.ps1'
if (-not $jaTem) {
    $entrada = [pscustomobject]@{
        matcher = 'startup'
        hooks   = @([pscustomobject]@{ type = 'command'; command = $cmd; timeout = 15 })
    }
    $settings.hooks.SessionStart = @($settings.hooks.SessionStart) + $entrada
    if (Test-Path $settingsPath) { Copy-Item $settingsPath "$settingsPath.bak" -Force }
    Write-File $settingsPath ($settings | ConvertTo-Json -Depth 20)
}

# ---------------------------------------------------------------------
# 4) Reforço no CLAUDE.md global
# ---------------------------------------------------------------------
$claudeMd = Join-Path $claude 'CLAUDE.md'
$regra = @'

## Kickoff automático de projetos
- Todo sistema novo: antes de codar, delegue ao subagente `kickoff-projeto`.
- Ele varre D:\reference-libs, o catálogo libs-referencia, skills e MCPs e grava `.claude/KICKOFF.md`.
- Siga o KICKOFF.md do projeto em todas as sessões seguintes.
'@
$atual = if (Test-Path $claudeMd) { Get-Content $claudeMd -Raw } else { '' }
if ($atual -notmatch 'kickoff-projeto') { Write-File $claudeMd ($atual + $regra) }

Write-Host "OK - agente kickoff-projeto instalado." -ForegroundColor Green
Write-Host "Teste: abra uma pasta nova em D:, rode 'claude' e peça o sistema." -ForegroundColor Cyan
