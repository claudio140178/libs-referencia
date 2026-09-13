# reference-libs

CatÃ¡logo pessoal de bibliotecas e ferramentas de referÃªncia para uso futuro nos meus projetos (Cuidar Perto, PlantÃ£o Certo, Ciclope, campanha-ads-swarm, NexusHive, etc).

Cada categoria tem um `requirements.txt` (ou `deps.md` para libs nÃ£o-Python) com as libs anotadas. Quando for comeÃ§ar um projeto novo ou precisar de algo especÃ­fico, copio o arquivo relevante direto pra cÃ¡.

## Categorias

| Pasta | ConteÃºdo |
|---|---|
| [`scraping/`](./scraping) | Web scraping, extraÃ§Ã£o de dados, crawling |
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
2. Adicione a linha no `requirements.txt` da categoria (ou entrada no `deps.md` se nÃ£o for pip)
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
