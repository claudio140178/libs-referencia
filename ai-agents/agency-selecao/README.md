# Seleção de agentes — The Agency (agency-agents)

Filtro dos ~270 agentes de [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents)
(commit `8ae6164`, licença MIT, ver `LICENSE-agency-agents`) para os **39 que mais servem aos projetos do Cláudio**.
Ficaram de fora os agentes de mercado chinês, games, GIS, XR, Drupal/WordPress/Salesforce/ServiceNow, governo dos EUA,
RH/recrutamento, imobiliário, jurídico americano e os que só repetem outro já escolhido.

Instalar no Claude Code (Windows):

```powershell
cd $env:USERPROFILE\Documents\libs-referencia
git pull
powershell -ExecutionPolicy Bypass -File .\setup\instalar-agentes-agency.ps1
```

O script copia os 39 arquivos para `~/.claude/agents` e **não sobrescreve** agente que já exista com o mesmo arquivo
(use `-Force` para atualizar). Para remover: `-Remover`.

**Automático (kickoff v6):** depois de rodar uma vez o `setup/instalar-kickoff.ps1`, o hook de início de sessão instala
sozinho, em todo projeto, os agentes de qualquer pasta de `ai-agents/` que tenha o arquivo `.auto-instalar` (esta pasta tem).
Agente novo adicionado aqui entra no `~/.claude/agents` na próxima sessão; agente alterado no catálogo é atualizado,
exceto se você tiver editado a cópia instalada. A regra "Subagentes do catálogo (sempre)" no `CLAUDE.md` global faz o
Claude delegar a eles quando a tarefa combinar.

## Engenharia e IA (12)

| Agente | Por que entrou |
|---|---|
| `engineering-multi-agent-systems-architect` | Topologia, contratos e governança de enxames: base de LangGraph, SWARM SEAL, Colmeia, Enxame 24h |
| `engineering-backend-architect` | Arquitetura de API e banco para os SaaS (FastAPI, Axum, Supabase) |
| `engineering-frontend-developer` | Next.js/React dos painéis e sites |
| `engineering-database-optimizer` | Schema, índices e queries no Postgres/Supabase nexushive |
| `engineering-payments-billing-engineer` | Stripe, webhooks idempotentes, assinaturas (Plantão Certo, Estetica360) |
| `engineering-prompt-engineer` | Prompts dos agentes testados e versionados |
| `engineering-rag-pipeline-engineer` | Busca/RAG nos dados (Oceanus, Leis, base de conteúdo) |
| `engineering-rust-refactoring-specialist` | Implacável, Estetica360, Campanha UGC (Rust/Axum) |
| `engineering-code-reviewer` | Revisão objetiva antes de subir |
| `engineering-privacy-engineer` | LGPD no código: PII, minimização, consentimento (LeadScreen, Radar de Cuidado, saúde) |
| `specialized-mcp-builder` | Criar servidores MCP próprios (OpenWA, MCC Guardian, coletores) |
| `automation-governance-architect` | Avalia valor/risco antes de automatizar (n8n-first): filtro para não criar enxame à toa |

## Segurança (3)

| Agente | Por que entrou |
|---|---|
| `security-ai-generated-code-auditor` | Caça segredo exposto, RLS quebrado do Supabase e prompt injection em apps feitos com IA |
| `security-secrets-credential-engineer` | Chaves de API (Google Ads, Supabase, OpenRouter) fora do código e rotação |
| `security-appsec-engineer` | Threat model e revisão segura dos SaaS; apoio a Aegis Core, GASPER, Implacável |

## Qualidade (2)

| Agente | Por que entrou |
|---|---|
| `testing-reality-checker` | Só aprova com prova ("NEEDS WORK" por padrão): trava entregas que parecem prontas e não estão |
| `testing-test-automation-engineer` | Testes E2E com Playwright sem flakiness |

## Design (3)

| Agente | Por que entrou |
|---|---|
| `design-ui-designer` | Sistema visual e componentes dos SaaS e sites |
| `design-ui-finish-gate-reviewer` | Barra UI genérica "cara de IA" antes de publicar |
| `design-whimsy-injector` | Microinterações e animações com personalidade (linha React Bits) |

## Tráfego pago (6) — afiliados, CPC/COD, MCC Guardian

| Agente | Por que entrou |
|---|---|
| `paid-media-ppc-strategist` | Estrutura de campanhas Search/Shopping/PMax no Google Ads |
| `paid-media-auditor` | Auditoria de 200+ pontos em contas Google/Meta |
| `paid-media-tracking-specialist` | GTM, GA4, conversões offline/gclid, CAPI (Rastreio Gringa) |
| `paid-media-search-query-analyst` | Termos de busca e negativas: corta gasto inútil |
| `paid-media-creative-strategist` | Anúncios RSA e testes de criativo |
| `paid-media-paid-social-strategist` | Meta, TikTok Ads e outras redes pagas |

## Marketing orgânico e e-commerce (6)

| Agente | Por que entrou |
|---|---|
| `marketing-tiktok-strategist` | @officialbrand_sc, Ciclope-Divulgação, TikTok Sales Swarm |
| `marketing-carousel-growth-engine` | Carrosséis automáticos para TikTok/Instagram a partir de um site |
| `marketing-seo-specialist` | SEO técnico e de conteúdo (Lupa, Coelho, sites de clientes) |
| `marketing-ai-citation-strategist` | GEO/AEO: aparecer em ChatGPT, Gemini, Perplexity |
| `marketing-growth-hacker` | Experimentos rápidos de aquisição |
| `marketing-cross-border-ecommerce` | Shopee, TikTok Shop, Amazon (arbitragem de varejo, afiliados) |

## Vendas e negócio (4)

| Agente | Por que entrou |
|---|---|
| `sales-offer-lead-gen-strategist` | Ofertas e iscas que atraem comprador qualificado (Kit Cuidar em Casa, LeadScreen) |
| `sales-outbound-strategist` | ICP e sequências de prospecção B2B (LeadScreen, MIDAS) |
| `specialized-pricing-analyst` | Preço dos SaaS e produtos digitais |
| `product-trend-researcher` | Tendências e oportunidades (Oceanus, Radar de Demanda, FATIA) |

## Saúde e jurídico (3)

| Agente | Por que entrou |
|---|---|
| `healthcare-aging-parent-care-companion` | Cuidado de idoso em casa: base para Kit Cuidar em Casa, Radar de Cuidado, Plantão Enfermagem |
| `healthcare-clinical-evidence-agent` | Padrão de evidência clínica para conteúdo de saúde confiável |
| `support-legal-compliance-checker` | Checagem de conformidade de operações, dados e conteúdo |

> Os agentes são genéricos/internacionais: os de saúde e jurídico citam HIPAA/GDPR; peça para adaptar a LGPD,
> COFEN/COREN e CDC quando usar.
