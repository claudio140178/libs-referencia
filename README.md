# reference-libs

Catálogo pessoal de bibliotecas e ferramentas de referência para uso futuro nos meus projetos (Cuidar Perto, Plantão Certo, Ciclope, campanha-ads-swarm, NexusHive, etc).

Cada categoria tem um `requirements.txt` (ou `deps.md` para libs não-Python) com as libs anotadas. Quando for começar um projeto novo ou precisar de algo específico, copio o arquivo relevante direto pra cá.

## Categorias

| Pasta | Conteúdo |
|---|---|
| [`scraping/`](./scraping) | Web scraping, extração de dados, crawling |
| [`ai-agents/`](./ai-agents) | Frameworks de agentes, LLM orchestration, RAG |
| [`backend/`](./backend) | APIs, frameworks web, ORMs, filas |
| [`frontend/`](./frontend) | UI, componentes, efeitos visuais (ex: react-bits) |
| [`security/`](./security) | Criptografia, pentest, OSINT, hardening |
| [`devops/`](./devops) | Deploy, CI/CD, infra |

## Como usar

Quando for iniciar/atualizar um projeto:

```bash
cat reference-libs/scraping/requirements.txt >> meu-projeto/requirements.txt
```

Ou copie manualmente as linhas relevantes.

## Como adicionar uma nova lib

1. Escolha a categoria (ou crie uma nova pasta)
2. Adicione a linha no `requirements.txt` da categoria (ou entrada no `deps.md` se não for pip)
3. Adicione uma linha na tabela `NOTES.md` da categoria com uma frase de contexto (pra que serve, por que anotei)
4. Commit e push

```bash
git add .
git commit -m "docs: adiciona <nome-da-lib> em <categoria>"
git push
```

## Automaton (Conway-Research)
Repo: https://github.com/Conway-Research/automaton
Runtime de agente de IA autonomo (TypeScript/Node) que paga pelo proprio compute via cripto (x402/USDC na rede Base), roda em loop ReAct continuo, pode se auto-modificar e se replicar (spawnar filhos), e e restrito por uma 'constituicao' (constitution.md) hardcoded. Tem tiers de sobrevivencia por saldo de creditos (full -> degradado -> minimo -> zero/morte). MIT license.
Uso: referencia de arquitetura para agentes autonomos com orcamento/sobrevivencia proprios; skills em Conway-Research/skills (SKILL.md) sao um bom padrao pra expor APIs proprias (ex: NexusHive, Ciclope) como tools chamaveis.
Cuidado: auditoria propria (set/2026) encontrou bugs reais (regra de reserva minima morta, validacao de pacote npm vulneravel a owner/repo do GitHub, wallet sem criptografia, bypass de leitura de arquivo sensivel via copia renomeada, tokenizer com blowup em texto repetitivo) - corrigidos em fork local, nao no upstream.


- [improve](https://github.com/shadcn/improve) — usa o modelo mais capaz pra auditar o codebase e escrever planos de execução para modelos mais baratos (skill Claude Code, comando /improve)

- [SkillSpector](https://github.com/NVIDIA/SkillSpector) — scanner de segurança para skills de agentes de IA (Claude Code, Codex, MCP); detecta prompt injection, exfiltração de dados, escalada de privilégio e outros riscos antes de instalar uma skill

- [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) — agent harness open-source da DeepSeek AI (arquitetura everything-is-a-plugin sobre o meta-framework Cordis); compõe modelos, ferramentas, sessões, sandboxes e orquestração como plugins. Developer preview, MIT license

- [Omarchy](https://github.com/omacom/omarchy) — distro Linux baseada em Arch, opinativa e voltada para workflow com agentes de IA, criada por DHH (Hyprland, instalador guiado, sistema de plugins)

- [Orca](https://github.com/stablyai/orca) — ADE para rodar uma frota de agentes de código em paralelo (Claude Code, Codex, Cursor, Copilot e outros), cada um em git worktree isolado, com sua própria assinatura; desktop, mobile e runtime remoto

- [Claudex Loop](https://github.com/chaseai-yt/claudex-loop) — skill do Claude Code para endurecer um plano antes de codar: 4 fases (recon, interrogatório, revisão adversarial cross-model via Codex, build/inspeção cruzada); evita que o mesmo modelo avalie o próprio plano

- [No AI Slop](https://github.com/petergyang/no-ai-slop) — skill (Claude Code/Codex/ChatGPT) que remove 20+ padrões de 'AI slop' de textos gerados por IA (contrastes binários, aberturas de enrolação, finais pseudo-profundos), preservando a voz pessoal do autor

- [anydoc](https://github.com/firecrawl/anydoc) — lib em Rust (bindings Node.js/Python) que converte Word, PowerPoint, Excel, OpenDocument, RTF, EPUB, CSV e PDF em Markdown limpo em poucos ms; vem com Agent Skill pronta; MIT

- [Archify](https://github.com/tt-a1i/archify) — Agent Skill (Cursor, Claude Code, Codex CLI, OpenCode, DeepSeek Harness) que gera diagramas de arquitetura/workflow/sequência/data-flow a partir de JSON IR tipado; saída HTML autocontida com animação e export PNG/SVG/WebM; MIT

- [OpenMontage](https://github.com/calesthio/OpenMontage) — sistema agêntico open-source de produção de vídeo: 12 pipelines, 100+ ferramentas, 700+ skills de produção; transforma um AI coding assistant (Claude Code, Cursor, Codex) em estúdio de vídeo completo (pesquisa, roteiro, assets, edição, timeline, render); AGPL-3.0

- [video-use](https://github.com/browser-use/video-use) — edita vídeo via conversa com coding agents (Claude Code, Codex etc): corta silêncios/vícios de fala, color grading, legendas, overlays de animação (HyperFrames/Remotion/Manim/PIL) em sub-agentes paralelos, self-eval em cada corte; usa transcrição + visuais sob demanda em vez de frame a frame

- [Superpowers](https://github.com/obra/superpowers) — framework/metodologia de desenvolvimento de software para coding agents: skills componiveis para TDD (red/green), debugging sistemático em 4 fases, revisão de código, brainstorming e planos de execução. JÁ INSTALADO como plugin no meu ambiente Claude Code

- [Everything Claude Code](https://github.com/WorldFlowAI/everything-claude-code) — toolkit completo pro Claude Code (agents, skills, hooks, comandos, rules), de vencedor de hackathon Anthropic; cobre otimização de tokens, persistência de memória entre sessões, aprendizado contínuo, loops de verificação e paralelização com git worktrees

- [RuFlo](https://github.com/ruvnet/ruflo) — harness de agentes (ex-Claude Flow) para orquestrar swarms multi-agente coordenados sobre Claude Code/Codex/Hermes: memória adaptativa self-learning, federação entre máquinas, RAG vetorial, +100 agentes especializados. MIT, +40k stars

- [Open Design](https://github.com/nexu-io/open-design) — alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Open Design](https://github.com/nexu-io/open-design) � alternativa open-source local-first/BYOK ao Claude Design; transforma o coding agent (Claude Code, Codex, Cursor, DeepSeek Harness) em motor de design: prototipos, landing pages, dashboards, slides, imagens e video com export HTML/PDF/PPTX/MP4; centenas de skills e design systems brand-grade

- [Chatwoot](https://github.com/chatwoot/chatwoot)  plataforma open-source de atendimento ao cliente self-hosted (live-chat, email, omnichannel), alternativa ao Intercom/Zendesk/Salesforce; Ruby on Rails + Vue, MIT, +37k stars

- [Open SEO MCP Skills](https://github.com/Ryze-AI-Adgent/open-seo-mcp-skills)  MCP server gratuito de SEO + skills open-source para Claude: keyword research, rank tracking, audits, backlinks, AI visibility/GEO, usando dados reais de GSC/GA4/Ads

- [NotFair Plugin](https://github.com/nowork-studio/notfair-plugin)  48 skills open-source de SEO, GEO, midia paga (Google/Meta Ads), analytics, WordPress e CRM para Claude Code/Cursor/Codex; conecta via MCP hospedado (OAuth) a dados reais de GSC/GA4/Ads

- [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR)  toolkit de OCR e parsing de documentos; converte PDF/imagem em dados estruturados (JSON/Markdown) prontos para LLM, suporta 100+ idiomas, inclui modelo visao-linguagem PaddleOCR-VL; Apache, +50k stars

- [Netdata](https://github.com/netdata/netdata)  observabilidade full-stack em tempo real: metricas por segundo, logs, traces, deteccao de anomalias ML, troubleshooting com IA; 850+ integracoes, roda em Linux/Docker/K8s; open-source (Agent GPLv3+), +80k stars

- [GTM Attribution Insight Tag](https://github.com/Jude-Nwachukwu/gtm-attribution-insight-tag)  template custom para Google Tag Manager (aprovado pelo Google): captura UTMs e click IDs (gclid/fbclid/msclkid), infere dados do referrer, classifica trafego de AI Overview/Featured Snippets, suporta first-click attribution; grava em cookie/localStorage/dataLayer

- [Hypit](https://github.com/hypit-ai/hypit)  linguagem/sistema para agentes de IA (Claude Code, Codex) clonarem video viral como workflow completo: troca de rosto, texto, B-roll, legendas por palavra, 100 variantes em um comando; TypeScript, open-source, #1 trending

- [Founder Skills](https://github.com/ognjengt/founder-skills)  20+ Claude skills para founders/marketers: PRD generator, go-to-market plan, competitor intel, CRO optimization, pricing strategy, outreach; MIT

- [Docling](https://github.com/docling-project/docling)  toolkit da IBM Research para preparar documentos para GenAI/RAG: parsing avancado de PDF (layout, tabelas, formulas), DOCX/PPTX/XLSX/HTML/audio, exporta Markdown/HTML/JSON, pipeline VLM (GraniteDocling) e OCR; MIT

- [REA](https://github.com/morluto/rea)  orquestra agentes de IA (Claude Code, Copilot) para engenharia reversa licita: decompila binarios nativos e apps JS via Hopper, retorna manifests/classes/metodos com evidencias, roda local; MIT, MCP server

- [Replica Skill](https://github.com/Jakeschincariol/replica-skill)  11 skills Claude Code que investigam um app concorrente (recon/features) e ajudam a construir sua propria versao: arquitetura, design, backend, build, diff visual, QA, lancamento; MIT

- [My ChatGPT Prompts](https://github.com/p12s/my-chat-gpt-promts)  colecao pessoal de prompts prontos para ChatGPT/GigaChat: resumo de livros e textos, exemplos de design patterns com codigo, resolver LeetCode em Go, refatorar/explicar codigo, pratica de idioma estrangeiro

- [Harvey](https://github.com/darunbeece/harvey)  agente de vendas autonomo que roda na assinatura do Claude Code (ou Codex), sem custo de API: descobre empresas (OpenStreetMap), le os sites, pontua pelo ICP, escreve cold email personalizado, le respostas e conduz ate a reuniao; dashboard local com aprovacao manual de cada envio; Python, Docker, MIT (versao antiga; o projeto virou Sellbird, ver abaixo)

- [Caveman](https://github.com/JuliusBrussee/caveman)  reduz gasto de tokens de agentes de IA (Claude Code, Codex, 30+ agentes): respostas curtas estilo "caveman", leitura enxuta de arquivos (~33% menos tokens de entrada), modo Auto e Blocks; skills, hooks, MCP e CLI; Apache-2.0, #1 GitHub Trending

- [ECC (Everything Claude Code)](https://github.com/affaan-m/ECC)  "sistema operacional" de harness para agentes, do vencedor do hackathon da Anthropic: colecao completa de agents, skills, hooks, rules, comandos e configs MCP prontos para producao; memoria, aprendizado continuo, scan de seguranca (AgentShield); funciona em Claude Code, Codex, Cursor, OpenCode, Gemini; MIT, +140k stars

- [TogetherJS](https://github.com/jsfiddle/togetherjs)  colaboracao em tempo real embutida em qualquer site: duas pessoas veem cursores, edicoes e navegam juntas na mesma pagina (co-browsing para suporte/vendas); originalmente da Mozilla, mantido pelo JSFiddle; hub proprio via Cloudflare Workers + Durable Objects (plano gratis); MPL-2.0

- [Claude Ads](https://github.com/AgriciDaniel/claude-ads)  skill/plugin gratis para Claude Code que audita contas de anuncio em 12 plataformas (Google, Meta, TikTok, YouTube, LinkedIn, Microsoft, Amazon, Pinterest, Reddit, X, Snapchat, Apple): /ads audit, plan, create, monitor, optimize --draft, experiment; le exports/prints e aponta o que corrigir primeiro, sem alterar contas sozinho; 30+ sub-skills (budget, attribution, server-side tracking, landing, creative); MIT

- [Lago](https://github.com/getlago/lago)  infraestrutura open-source de billing/monetizacao por uso (alternativa ao Stripe Billing/Chargebee): mede tokens, compute, chamadas de API ou qualquer evento e transforma em precos, creditos, entitlements, faturas e pagamentos; assinaturas + uso hibrido; API, CLI e MCP; self-hosted via Docker; usado por Mistral AI, Groq, PayPal; AGPLv3

- [Saasfly](https://github.com/nextify-limited/saasfly)  boilerplate open-source de SaaS nivel enterprise em Next.js (App Router): auth com Clerk/NextAuth, pagamentos Stripe, Postgres com Kysely + Prisma, tRPC, e-mail com Resend + React Email, i18n, SEO, shadcn/ui + Tailwind + Framer Motion; monorepo Turborepo com Bun; deploy em 1 clique na Vercel; MIT

- [Marketing Skills](https://github.com/coreyhaines31/marketingskills)  53 skills de marketing para agentes (Claude Code, Codex, Cursor) de Corey Haines: SEO/AI SEO, programmatic SEO, CRO (signup, onboarding, popups, paywalls), copywriting, cold email, ads e ad creative, A/B test, analytics e conversion tracking, pricing, launch, lead magnets, referrals, churn; skill base product-marketing lida por todas; MIT

- [Papermark](https://github.com/papermark/papermark)  alternativa open-source ao DocSend: compartilha PDFs/decks por link seguro com analytics de visualizacao (quem abriu, tempo por pagina), dominio e marca proprios, data rooms; Next.js + Prisma/Postgres + NextAuth + Tinybird + Resend + Stripe, self-hosted na Vercel; AGPLv3 (pasta ee/ com licenca comercial)

- [Frappe Docker](https://github.com/frappe/frappe_docker)  setup oficial em containers para apps Frappe: sobe ERPNext (ERP open-source: financeiro, estoque, vendas, compras, RH), Frappe CRM, Helpdesk e outros via Docker Compose; demo descartavel com um arquivo (pwd.yml), imagens prontas para producao, build de imagem com apps customizados, devcontainer VS Code; MIT

- [Google Maps Scraper](https://github.com/gosom/google-maps-scraper)  extrai leads de negocios do Google Maps: nome, telefone, site, e-mail, avaliacoes, nota, coordenadas; CLI (CSV/JSON), Web UI, REST API e edicao SaaS self-hosted; skill para agentes (npx skills add gosom/google-maps-scraper) que planeja e roda o scrape por pedido em linguagem natural; Go + Docker, suporte a proxy; MIT

- [Foxpit](https://github.com/lordon1a/foxpit-releases)  app desktop (Windows/macOS/Linux) que roda Claude Code, Codex, OpenCode e Antigravity como um time: agente lider planeja e delega, cada vaga com agente/modelo diferente, memoria compartilhada em .foxpit/memory (markdown no repo), retoma sozinho apos limite de uso, terminais lado a lado + escritorio 3D; usa suas assinaturas. ATENCAO: codigo fechado (repo so tem releases), binario sem assinatura, exige conta Foxpit (trial sem cartao)

- [Sellbird](https://github.com/ethanplusai/sellbird)  ex-Harvey, plataforma open-source de prospeccao/outbound que roda no seu plano Claude ou ChatGPT (sem custo de API): acha empresas (OpenStreetMap gratis ou fonte paga com custo mostrado antes), le sinais de compra no site, acha o decisor, descobre e verifica o e-mail, escreve e envia sequencias pelo seu Gmail/M365/SMTP, le e responde replies, respeita opt-out; aprovacao manual por padrao; sellbird export gera CSV; Python, Docker; AGPL-3.0

- [BlueTeam-Tools](https://github.com/A-poc/BlueTeam-Tools)  lista curada de 70+ ferramentas e recursos de defesa (blue team): threat hunting, descoberta e mapeamento de rede, gestao de vulnerabilidades, monitoramento de seguranca, threat intelligence, plano de resposta a incidentes, deteccao e analise de malware, forense digital, recuperacao de dados, treinamento de conscientizacao; cada item com descricao e instalacao/uso
