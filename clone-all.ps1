# Clona/atualiza as libs de referencia em D:\reference-libs (rodar uma vez).
# Para se o D: nao existir ou se ficar com menos de 15 GB livres.
# Fora da lista (muito grandes): chatwoot, netdata, PaddleOCR, gumroad, react-native-reanimated, awslabs/mcp.
if (-not (Get-PSDrive D -EA 0)) { Write-Host "D: nao encontrado - conecte o disco e rode de novo" -ForegroundColor Red; return }
git config --global core.longpaths true
New-Item -ItemType Directory -Force D:\reference-libs | Out-Null
Set-Location D:\reference-libs
$env:GIT_TERMINAL_PROMPT = "0"
$repos = @(
"shadcn/improve","NVIDIA/SkillSpector","deepseek-ai/deepseek-harness","omacom/omarchy",
"stablyai/orca","chaseai-yt/claudex-loop","petergyang/no-ai-slop","firecrawl/anydoc",
"tt-a1i/archify","calesthio/OpenMontage","browser-use/video-use","obra/superpowers",
"WorldFlowAI/everything-claude-code","ruvnet/ruflo","nexu-io/open-design","Caliko06/spidi-crawler",
"Ryze-AI-Adgent/open-seo-mcp-skills","nowork-studio/notfair-plugin","morluto/rea",
"Jude-Nwachukwu/gtm-attribution-insight-tag","hypit-ai/hypit","ognjengt/founder-skills",
"docling-project/docling","Jakeschincariol/linkedin-agent-skill","niagalves/guia-basico-LGPD",
"debpalash/VoiceStudio","vercel-labs/agent-desktop","sergebulaev/instagram-skills",
"google-research/timesfm","anthropics/claude-code","f/prompts.chat","engenheirodevideo/get-brolls",
"Motionsites-AI/claude-skill","patch-gg/pixelfx","heydamir/unslop","mksglu/context-mode","rtk-ai/rtk",
"tirth8205/code-review-graph","anthropics/knowledge-work-plugins","wshobson/agents","anthropics/skills",
"ChromeDevTools/chrome-devtools-mcp","github/github-mcp-server","vercel-labs/agent-browser",
"browser-use/browser-use","heygen-com/hyperframes"
)
$ok = @(); $fail = @()
foreach ($r in $repos) {
  if ((Get-PSDrive D).Free/1GB -lt 15) { Write-Host "PAROU: menos de 15 GB livres no D:" -ForegroundColor Red; break }
  $name = ($r -split '/')[-1]
  Write-Host "Processando: $name"
  if (Test-Path $name) { $out = git -C $name pull 2>&1 } else { $out = git clone --depth 1 "https://github.com/$r.git" 2>&1 }
  if ($LASTEXITCODE -eq 0) { $ok += $name } else { $fail += "$name -> $($out | Select -Last 1)" }
}
Write-Host "`n=== OK ($($ok.Count)) ===" -ForegroundColor Green; $ok
Write-Host "`n=== FALHOU ($($fail.Count)) ===" -ForegroundColor Red; $fail
Get-PSDrive D | Select @{n='LivreGB';e={[math]::Round($_.Free/1GB,1)}}
