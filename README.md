# Olius_Banco_primeiro

Repositório de banco de dados do projeto Olius, desenvolvido durante o primeiro ano do Ensino Médio Técnico.

## Sobre o projeto

O Olius é uma plataforma digital criada para facilitar o descarte correto do óleo de cozinha usado, conectando cidadãos, empresas, pontos de coleta e coletores parceiros.

Este repositório reúne os arquivos relacionados ao desenvolvimento do banco de dados da aplicação, responsável por armazenar, organizar e gerenciar as informações utilizadas pelo sistema.

## Objetivo do repositório

O objetivo é estruturar o banco de dados do Olius, garantindo a organização das informações e o relacionamento entre as diferentes entidades da plataforma.

## Tecnologia utilizada

- **PostgreSQL:** Sistema de gerenciamento de banco de dados relacional.
- **SQL:** Linguagem utilizada para criação, manipulação e consulta dos dados.

## Estrutura do banco de dados

O banco de dados é composto pelas seguintes tabelas:

| Tabela | Descrição |
|---|---|
| ADM | Armazena os dados dos administradores. |
| ATUALIZACAO | Registra alterações e suas autorizações. |
| USUARIO | Armazena os dados dos usuários cadastrados. |
| B2B | Gerencia informações das empresas. |
| B2C | Armazena informações dos usuários cidadãos. |
| ENDERECO | Armazena os endereços cadastrados. |
| PEV | Gerencia os pontos de entrega voluntária. |
| MOTORISTA | Armazena os dados dos motoristas. |
| SOLICITACAO_COLETA | Registra as solicitações de coleta. |
| COLETA | Armazena os registros das coletas realizadas. |
| ENTREGA_PEV | Registra as entregas de óleo nos pontos de coleta. |
| CERTIFICADO | Armazena informações dos certificados emitidos. |
| CARTEIRA | Gerencia os pontos e níveis dos usuários. |
| MOVIMENTACAO_PONTOS | Registra a movimentação de pontos das carteiras. |

## Organização dos arquivos

O repositório contém scripts SQL responsáveis pela estruturação e alimentação do banco de dados.

O script principal contempla:

- Remoção de tabelas e tipos existentes.
- Criação de tipos personalizados (ENUM).
- Criação das tabelas.
- Inserção de dados para testes.
- Definição de chaves primárias e restrições UNIQUE.
- Criação de índices.
- Definição de chaves estrangeiras e relacionamentos entre as tabelas.

## Desenvolvimento

O banco de dados foi desenvolvido como parte do projeto interdisciplinar Olius, integrando conhecimentos de modelagem de dados, SQL e gerenciamento de bancos de dados relacionais.

**Projeto:** Olius  
**Área:** Banco de Dados  
**Instituição:** Escola Germinare  
**Etapa:** Primeiro ano do Ensino Médio Técnico

---

**O futuro em cada gota.**
