param([switch]$Force, [switch]$Remover)
$ErrorActionPreference = 'Stop'
# Instala no Claude Code a seleção de 39 agentes do The Agency (ai-agents\agency-selecao).
# Não sobrescreve agente existente (use -Force). -Remover tira só os agentes desta seleção.
$origem  = Join-Path $PSScriptRoot '..\ai-agents\agency-selecao'
$destino = Join-Path $env:USERPROFILE '.claude\agents'
if (-not (Test-Path $origem)) { Write-Host "Pasta da seleção não encontrada: $origem" -ForegroundColor Red; exit 1 }
New-Item -ItemType Directory -Force $destino | Out-Null

$arquivos = Get-ChildItem $origem -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' }
$novos = 0; $pulados = 0; $removidos = 0
foreach ($a in $arquivos) {
  $alvo = Join-Path $destino $a.Name
  if ($Remover) {
    # só remove se for igual ao arquivo da seleção (não apaga agente seu com o mesmo nome)
    if ((Test-Path $alvo) -and (Get-FileHash $alvo).Hash -eq (Get-FileHash $a.FullName).Hash) { Remove-Item $alvo -Force; $removidos++ }
    continue
  }
  if ((Test-Path $alvo) -and -not $Force) { $pulados++; continue }
  Copy-Item $a.FullName $alvo -Force; $novos++
}
if ($Remover) { Write-Host "OK - $removidos agentes da seleção removidos de $destino" -ForegroundColor Green }
else {
  Write-Host "OK - $novos agentes instalados em $destino ($pulados já existiam e foram mantidos; use -Force para atualizar)." -ForegroundColor Green
  Write-Host "Abra uma nova sessão do Claude Code e use /agents para ver a lista." -ForegroundColor Cyan
}
