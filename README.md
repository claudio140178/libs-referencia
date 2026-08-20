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
