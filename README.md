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


- [improve](https://github.com/shadcn/improve) � usa o modelo mais capaz pra auditar o codebase e escrever planos de execu��o para modelos mais baratos (skill Claude Code, comando /improve)
