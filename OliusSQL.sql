-- ==========================================
-- DROP TABLES
-- ==========================================

DROP TABLE IF EXISTS "USUARIO" CASCADE;

DROP TABLE IF EXISTS "SOLICITACAO_COLETA" CASCADE;

DROP TABLE IF EXISTS "PEV" CASCADE;

DROP TABLE IF EXISTS "MOVIMENTACAO_PONTOS" CASCADE;

DROP TABLE IF EXISTS "MOTORISTA" CASCADE;

DROP TABLE IF EXISTS "ENTREGA_PEV" CASCADE;

DROP TABLE IF EXISTS "ENDERECO" CASCADE;

DROP TABLE IF EXISTS "COLETA" CASCADE;

DROP TABLE IF EXISTS "CERTIFICADO" CASCADE;

DROP TABLE IF EXISTS "CARTEIRA" CASCADE;

DROP TABLE IF EXISTS "B2C" CASCADE;

DROP TABLE IF EXISTS "B2B" CASCADE;

DROP TABLE IF EXISTS "ATUALIZACAO" CASCADE;

DROP TABLE IF EXISTS "ADM" CASCADE;

-- ==========================================
-- DROP TYPES IF EXISTS
-- ==========================================

DROP TYPE IF EXISTS public.estados CASCADE;

DROP TYPE IF EXISTS public.plano CASCADE;

DROP TYPE IF EXISTS public.status_motorista CASCADE;

DROP TYPE IF EXISTS public.status_pev CASCADE;

DROP TYPE IF EXISTS public.status_solicitacao CASCADE;

DROP TYPE IF EXISTS public.tipo_usuario CASCADE;

-- ==========================================
-- CREATE ENUMS
-- ==========================================

CREATE TYPE public.estados AS ENUM (
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
    );

CREATE TYPE public.plano AS ENUM (
    'Empresa',
    'Basico',
    'Profissional'
    );

CREATE TYPE public.status_motorista AS ENUM (
    'Disponivel',
    'Ocupado'
    );

CREATE TYPE public.status_pev AS ENUM (
    'Aprovada',
    'Negado',
    'Pendente'
    );

CREATE TYPE public.status_solicitacao AS ENUM (
    'Realizada',
    'Pendente',
    'Cancelada'
    );

CREATE TYPE public.tipo_usuario AS ENUM (
    'B2B',
    'B2C',
    'PEV'
    );

-- ==========================================
-- CREATE TABLES
-- ==========================================

CREATE TABLE IF NOT EXISTS ADM (

                                     "ID_ADM" SERIAL NOT NULL,
                                     nome character varying(255) NOT NULL,
                                     senha character varying(255) NOT NULL,
                                     email character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ATUALIZACAO (

                                             "ID_atualizacao" SERIAL NOT NULL,
                                             motivo character varying(255) NOT NULL,
                                             autorizacao integer NOT NULL,
                                             mudanca character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS B2B (

                                     "ID_B2B" SERIAL NOT NULL,
                                     "CNPJ" character varying(14) NOT NULL,
                                     "ID_endereco" integer,
                                     nome_empresa character varying(255) NOT NULL,
                                     telefone character varying(30) NOT NULL,
                                     "Plano" public.plano,
                                     "ID_usuario" integer,
                                     CONSTRAINT "B2B_CNPJ_check" CHECK ((length(("CNPJ")::text) = 14))
);

CREATE TABLE IF NOT EXISTS B2C (

                                     "ID_B2C" SERIAL NOT NULL,
                                     "CPF" character varying(11) NOT NULL,
                                     "ID_usuario" integer NOT NULL,
                                     CONSTRAINT "B2C_CPF_check" CHECK ((length(("CPF")::text) = 11))
);

CREATE TABLE IF NOT EXISTS CARTEIRA (

                                          "ID_carteira" SERIAL NOT NULL,
                                          pontos_totais integer DEFAULT 0 NOT NULL,
                                          nivel integer DEFAULT 1 NOT NULL,
                                          "ID_B2C" integer,
                                          "ID_B2B" integer,
                                          CONSTRAINT "CARTEIRA_nivel_check" CHECK ((nivel >= 1)),
                                          CONSTRAINT "CARTEIRA_pontos_totais_check" CHECK ((pontos_totais >= 0)),
                                          CONSTRAINT chk_apenas_um_id_carteira CHECK ((num_nonnulls("ID_B2C", "ID_B2B") <= 1))
);

CREATE TABLE IF NOT EXISTS CERTIFICADO (

                                             "ID_certificado" SERIAL NOT NULL,
                                             volume_total numeric NOT NULL,
                                             "DT_emissao" date NOT NULL,
                                             "PDF" character varying(255) NOT NULL,
                                             "ID_B2B" integer,
                                             "ID_coleta" integer,
                                             CONSTRAINT "CERTIFICADO_volume_total_check" CHECK ((volume_total >= (0)::numeric))
);

CREATE TABLE IF NOT EXISTS COLETA (

                                        "ID_coleta" SERIAL NOT NULL,
                                        "DT_coleta" date NOT NULL,
                                        volume_coletado numeric NOT NULL,
                                        avaliacao_coleta integer NOT NULL,
                                        "ID_solicitacao" integer,
                                        "ID_motorista" integer,
                                        "ID_B2B" integer,
                                        CONSTRAINT "COLETA_avaliacao_coleta_check" CHECK (((avaliacao_coleta >= 1) AND (avaliacao_coleta <= 5))),
                                        CONSTRAINT "COLETA_volume_coletado_check" CHECK ((volume_coletado > (0)::numeric))
);

CREATE TABLE IF NOT EXISTS ENDERECO (

                                          "ID_endereco" SERIAL NOT NULL,
                                          rua character varying(255) NOT NULL,
                                          cidade character varying(255) NOT NULL,
                                          bairro character varying(255) NOT NULL,
                                          cep character varying(8) NOT NULL,
                                          numero character varying(10) NOT NULL,
                                          complemento character varying(255),
                                          estado public.estados,
                                          CONSTRAINT "ENDERECO_cep_check" CHECK ((length((cep)::text) = 8))
);

CREATE TABLE IF NOT EXISTS ENTREGA_PEV (

                                             "ID_entrega" SERIAL NOT NULL,
                                             "DT_entrega" date NOT NULL,
                                             volume_entrega numeric NOT NULL,
                                             "ID_PEV" integer,
                                             "ID_B2C" integer,
                                             CONSTRAINT "ENTREGA_PEV_volume_entrega_check" CHECK ((volume_entrega > (0)::numeric))
);

CREATE TABLE IF NOT EXISTS MOTORISTA (

                                           "ID_motorista" SERIAL NOT NULL,
                                           empresa_resp character varying(255) NOT NULL,
                                           telefone character varying(15) NOT NULL,
                                           nome character varying(255) NOT NULL,
                                           licenca character varying(50) NOT NULL,
                                           status public.status_motorista
);

CREATE TABLE IF NOT EXISTS MOVIMENTACAO_PONTOS (

                                                     "ID_movimentacao" SERIAL NOT NULL,
                                                     quantidade_pontos integer NOT NULL,
                                                     "ID_carteira" integer NOT NULL,
                                                     "ID_coleta" integer,
                                                     "ID_entrega" integer,
                                                     CONSTRAINT chk_apenas_um_id_origem CHECK ((num_nonnulls("ID_coleta", "ID_entrega") = 1))
);

CREATE TABLE IF NOT EXISTS PEV (

                                     "ID_PEV" SERIAL NOT NULL,
                                     "DT_aprovacao" date NOT NULL,
                                     "ID_usuario" integer,
                                     "ID_endereco" integer,
                                     status public.status_pev
);

CREATE TABLE IF NOT EXISTS SOLICITACAO_COLETA (

                                                    "ID_solicitacao" SERIAL NOT NULL,
                                                    volume_estimado numeric NOT NULL,
                                                    "DT_solicitacao" date NOT NULL,
                                                    "ID_B2B" integer,
                                                    status public.status_solicitacao,
                                                    CONSTRAINT "SOLICITACAO_COLETA_volume_estimado_check" CHECK ((volume_estimado > (0)::numeric))
);

CREATE TABLE IF NOT EXISTS USUARIO (

                                         "ID_usuario" SERIAL NOT NULL,
                                         email character varying(256) NOT NULL,
                                         telefone character varying(15) NOT NULL,
                                         nome character varying(255) NOT NULL,
                                         primeiro_registro date DEFAULT CURRENT_DATE NOT NULL,
                                         senha character varying(255) NOT NULL,
                                         "ID_endereco" integer,
                                         tipo_usuario public.tipo_usuario NOT NULL
);

-- ==========================================
-- DATA LOAD (INSERT INTO)
-- ==========================================

-- ADM

INSERT INTO ADM ("ID_ADM", nome, senha, email) VALUES

    ('1', 'Administrador Olius', 'senha_teste_123', 'admin@olius.local');

-- B2B

INSERT INTO B2B ("ID_B2B", "CNPJ", "ID_endereco", nome_empresa, telefone, "Plano", "ID_usuario") VALUES

       ('2', '11222333000181', '12', 'Supermercado Vida', '11987650002', 'Empresa', NULL),

       ('3', '23456789000195', '3', 'Restaurante Sabor Bom', '19987650003', 'Profissional', NULL);

-- B2C

INSERT INTO B2C ("ID_B2C", "CPF", "ID_usuario") VALUES

       ('1', '11122233344', '5'),

       ('2', '22233344455', '6'),

       ('3', '33344455566', '7'),

       ('4', '44455566677', '8'),

       ('5', '55566677788', '9'),

       ('6', '12345678909', '4');

-- CARTEIRA

INSERT INTO CARTEIRA ("ID_carteira", pontos_totais, nivel, "ID_B2C", "ID_B2B") VALUES
       ('1', '98', '1', '1', NULL),

       ('2', '35', '1', '2', NULL),

       ('3', '80', '2', '3', NULL),

       ('4', '22', '1', '4', NULL),

       ('5', '100', '2', '5', NULL),

       ('7', '150', '2', NULL, '2'),

       ('8', '78', '1', NULL, '3'),

       ('6', '493', '4', NULL, NULL),

       ('9', '0', '1', NULL, NULL);

-- CERTIFICADO

INSERT INTO CERTIFICADO ("ID_certificado", volume_total, "DT_emissao", "PDF", "ID_B2B", "ID_coleta") VALUES

    ('2', '150.5', '2025-10-05', 'certificados/cert_0002.pdf', '3', '2');

-- COLETA

INSERT INTO COLETA ("ID_coleta", "DT_coleta", volume_coletado, avaliacao_coleta, "ID_solicitacao", "ID_motorista", "ID_B2B") VALUES

       ('3', '2025-10-09', '78.00', '5', '3', '4', '3'),

       ('4', '2025-11-03', '298.00', '4', '6', '2', NULL),

       ('1', '2025-10-02', '195.00', '5', '1', NULL, NULL),

       ('2', '2025-10-04', '150.50', '4', '2', NULL, '2');

-- ENDERECO

INSERT INTO ENDERECO ("ID_endereco", rua, cidade, bairro, cep, numero, complemento, estado) VALUES

      ('1', 'Rua Augusta', 'Sao Paulo', 'Consolacao', '01304001', '1200', 'Sala 31', NULL),

      ('2', 'Avenida Paulista', 'Sao Paulo', 'Bela Vista', '01310100', '1578', NULL, NULL),

      ('5', 'Rua da Bahia', 'Belo Horizonte', 'Lourdes', '30160011', '300', 'Bloco B', NULL),

      ('6', 'Rua XV de Novembro', 'Curitiba', 'Centro', '80020310', '210', NULL, NULL),

      ('7', 'Avenida Beira Mar', 'Florianopolis', 'Centro', '88010400', '77', 'Casa 2', NULL),

      ('8', 'Rua Sete de Setembro', 'Porto Alegre', 'Centro Historico', '90010190', '150', NULL, NULL),

      ('9', 'Avenida Sete de Setembro', 'Salvador', 'Vitoria', '40080002', '480', 'Sala 5', NULL),

      ('10', 'Rua do Sol', 'Recife', 'Boa Viagem', '51021000', '62', NULL, NULL),

      ('11', 'ap', 'São Paulo', 'Cumbica', '02078010', '151', 'Galpao 4', 'SP'),

      ('4', 'Avenida Atlantica', 'Rio de Janeiro', 'Copacabana', '22010000', '900', 'Sala 52', 'RJ'),

      ('12', 'Avenida dos Autonomistas', 'Osasco', 'Centro', '06194000', '2500', 'Galpao 1', 'SP'),

      ('3', 'Rua das Flores', 'Campinas', 'Centro', '13010010', '45', 'Apto 12', 'SP'),

      ('14', 'ap', 'São Paulo', 'Copacabana', '02078010', '151', 'Loja 2', 'SP');

-- ENTREGA_PEV

INSERT INTO ENTREGA_PEV ("ID_entrega", "DT_entrega", volume_entrega, "ID_PEV", "ID_B2C") VALUES

       ('3', '2025-10-06', '8.00', NULL, '3'),

       ('4', '2025-10-09', '2.25', NULL, '4'),

       ('6', '2025-10-15', '4.75', NULL, '1'),

       ('1', '2025-10-02', '5.00', NULL, '1'),

       ('2', '2025-10-04', '3.50', NULL, '2'),

       ('5', '2025-10-11', '10.00', NULL, '5');

-- MOTORISTA

INSERT INTO MOTORISTA ("ID_motorista", empresa_resp, telefone, nome, licenca, status) VALUES

       ('2', 'TransVerde Logistica', '11999110002', 'Paulo Ricardo', 'CNH-AD-00123457', NULL),

       ('4', 'EcoFrota Transportes', '21999110004', 'Joao Batista', 'CNH-AD-00345678', NULL);

-- MOVIMENTACAO_PONTOS

INSERT INTO MOVIMENTACAO_PONTOS ("ID_movimentacao", quantidade_pontos, "ID_carteira", "ID_coleta", "ID_entrega") VALUES

       ('1', '50', '1', NULL, '1'),

       ('2', '35', '2', NULL, '2'),

       ('3', '80', '3', NULL, '3'),

       ('4', '22', '4', NULL, '4'),

       ('5', '100', '5', NULL, '5'),

       ('6', '48', '1', NULL, '6'),

       ('7', '195', '6', '1', NULL),

       ('8', '150', '7', '2', NULL),

       ('9', '78', '8', '3', NULL),

       ('10', '298', '6', '4', NULL);

-- SOLICITACAO_COLETA

INSERT INTO SOLICITACAO_COLETA ("ID_solicitacao", volume_estimado, "DT_solicitacao", "ID_B2B", status) VALUES

       ('3', '80.00', '2025-10-08', '3', 'Realizada'),

       ('2', '150.50', '2025-10-03', '2', 'Realizada'),

       ('1', '200.00', '2025-10-01', NULL, 'Realizada'),

       ('4', '120.00', '2025-10-20', NULL, NULL),

       ('6', '300', '2025-11-02', '2', 'Realizada');

-- USUARIO

INSERT INTO USUARIO ("ID_usuario", email, telefone, nome, primeiro_registro, senha, "ID_endereco", tipo_usuario) VALUES

       ('5', 'ana.souza@email.com', '11987650005', 'Ana Souza', '2025-05-11', 'hash_senha_005', '1', 'B2C'),

       ('6', 'bruno.lima@email.com', '11987650006', 'Bruno Lima', '2025-06-02', 'hash_senha_006', '2', 'B2C'),

       ('7', 'carla.dias@email.com', '31987650007', 'Carla Dias', '2025-06-18', 'hash_senha_007', '5', 'B2C'),

       ('8', 'diego.alves@email.com', '41987650008', 'Diego Alves', '2025-07-09', 'hash_senha_008', '6', 'B2C'),

       ('9', 'elisa.matos@email.com', '48987650009', 'Elisa Matos', '2025-08-01', 'hash_senha_009', '7', 'B2C'),

       ('4', 'oleo@lanchonetecentral.com', '21987650004', 'Lanchonete Central', '2025-04-20', 'lanchonete123.', '4', 'B2C');

-- ==========================================
-- PRIMARY KEYS E UNIQUE
-- ==========================================

ALTER TABLE "ADM" ADD CONSTRAINT "ADM_email_key" UNIQUE (email);

ALTER TABLE "ADM" ADD CONSTRAINT "ADM_pkey" PRIMARY KEY ("ID_ADM");

ALTER TABLE "ATUALIZACAO" ADD CONSTRAINT "ATUALIZACAO_pkey" PRIMARY KEY ("ID_atualizacao");

ALTER TABLE "B2B" ADD CONSTRAINT "B2B_ID_usuario_key" UNIQUE ("ID_usuario");

ALTER TABLE "B2B" ADD CONSTRAINT "B2B_pkey" PRIMARY KEY ("ID_B2B");

ALTER TABLE "B2C" ADD CONSTRAINT "B2C_ID_usuario_key" UNIQUE ("ID_usuario");

ALTER TABLE "B2C" ADD CONSTRAINT "B2C_pkey" PRIMARY KEY ("ID_B2C");

ALTER TABLE "CARTEIRA" ADD CONSTRAINT "CARTEIRA_pkey" PRIMARY KEY ("ID_carteira");

ALTER TABLE "CERTIFICADO" ADD CONSTRAINT "CERTIFICADO_pkey" PRIMARY KEY ("ID_certificado");

ALTER TABLE "COLETA" ADD CONSTRAINT "COLETA_pkey" PRIMARY KEY ("ID_coleta");

ALTER TABLE "ENDERECO" ADD CONSTRAINT "ENDERECO_pkey" PRIMARY KEY ("ID_endereco");

ALTER TABLE "ENTREGA_PEV" ADD CONSTRAINT "ENTREGA_PEV_pkey" PRIMARY KEY ("ID_entrega");

ALTER TABLE "MOTORISTA" ADD CONSTRAINT "MOTORISTA_pkey" PRIMARY KEY ("ID_motorista");

ALTER TABLE "MOVIMENTACAO_PONTOS" ADD CONSTRAINT "MOVIMENTACAO_PONTOS_pkey" PRIMARY KEY ("ID_movimentacao");

ALTER TABLE "PEV" ADD CONSTRAINT "PEV_pkey" PRIMARY KEY ("ID_PEV");

ALTER TABLE "SOLICITACAO_COLETA" ADD CONSTRAINT "SOLICITACAO_COLETA_pkey" PRIMARY KEY ("ID_solicitacao");

ALTER TABLE "USUARIO" ADD CONSTRAINT "USUARIO_email_key" UNIQUE (email);

ALTER TABLE "USUARIO" ADD CONSTRAINT "USUARIO_pkey" PRIMARY KEY ("ID_usuario");

-- ==========================================
-- INDEXES
-- ==========================================

CREATE UNIQUE INDEX usuario_email_acesso_unique ON "USUARIO" USING btree (lower((email)::text));

-- ==========================================
-- FOREIGN KEYS
-- ==========================================

ALTER TABLE "ATUALIZACAO" ADD CONSTRAINT "ATUALIZACAO_autorizacao_fkey" FOREIGN KEY (autorizacao) REFERENCES "ADM"("ID_ADM");

ALTER TABLE "B2B" ADD CONSTRAINT "B2B_ID_endereco_fkey" FOREIGN KEY ("ID_endereco") REFERENCES "ENDERECO"("ID_endereco");

ALTER TABLE "B2B" ADD CONSTRAINT "B2B_ID_usuario_fkey" FOREIGN KEY ("ID_usuario") REFERENCES "USUARIO"("ID_usuario") ON DELETE SET NULL;

ALTER TABLE "B2C" ADD CONSTRAINT "B2C_ID_usuario_fkey" FOREIGN KEY ("ID_usuario") REFERENCES "USUARIO"("ID_usuario");

ALTER TABLE "CARTEIRA" ADD CONSTRAINT "CARTEIRA_ID_B2B_fkey" FOREIGN KEY ("ID_B2B") REFERENCES "B2B"("ID_B2B") ON DELETE SET NULL;

ALTER TABLE "CARTEIRA" ADD CONSTRAINT "CARTEIRA_ID_B2C_fkey" FOREIGN KEY ("ID_B2C") REFERENCES "B2C"("ID_B2C") ON DELETE SET NULL;

ALTER TABLE "CERTIFICADO" ADD CONSTRAINT "CERTIFICADO_ID_B2B_fkey" FOREIGN KEY ("ID_B2B") REFERENCES "B2B"("ID_B2B") ON DELETE SET NULL;

ALTER TABLE "CERTIFICADO" ADD CONSTRAINT "CERTIFICADO_ID_coleta_fkey" FOREIGN KEY ("ID_coleta") REFERENCES "COLETA"("ID_coleta");

ALTER TABLE "COLETA" ADD CONSTRAINT "COLETA_ID_B2B_fkey" FOREIGN KEY ("ID_B2B") REFERENCES "B2B"("ID_B2B") ON DELETE SET NULL;

ALTER TABLE "COLETA" ADD CONSTRAINT "COLETA_ID_motorista_fkey" FOREIGN KEY ("ID_motorista") REFERENCES "MOTORISTA"("ID_motorista") ON DELETE SET NULL;

ALTER TABLE "COLETA" ADD CONSTRAINT "COLETA_ID_solicitacao_fkey" FOREIGN KEY ("ID_solicitacao") REFERENCES "SOLICITACAO_COLETA"("ID_solicitacao") ON DELETE SET NULL;

ALTER TABLE "ENTREGA_PEV" ADD CONSTRAINT "ENTREGA_PEV_ID_B2C_fkey" FOREIGN KEY ("ID_B2C") REFERENCES "B2C"("ID_B2C") ON DELETE SET NULL;

ALTER TABLE "ENTREGA_PEV" ADD CONSTRAINT "ENTREGA_PEV_ID_PEV_fkey" FOREIGN KEY ("ID_PEV") REFERENCES "PEV"("ID_PEV") ON DELETE SET NULL;

ALTER TABLE "MOVIMENTACAO_PONTOS" ADD CONSTRAINT "MOVIMENTACAO_PONTOS_ID_carteira_fkey" FOREIGN KEY ("ID_carteira") REFERENCES "CARTEIRA"("ID_carteira");

ALTER TABLE "MOVIMENTACAO_PONTOS" ADD CONSTRAINT "MOVIMENTACAO_PONTOS_ID_coleta_fkey" FOREIGN KEY ("ID_coleta") REFERENCES "COLETA"("ID_coleta");

ALTER TABLE "MOVIMENTACAO_PONTOS" ADD CONSTRAINT "MOVIMENTACAO_PONTOS_ID_entrega_fkey" FOREIGN KEY ("ID_entrega") REFERENCES "ENTREGA_PEV"("ID_entrega");

ALTER TABLE "PEV" ADD CONSTRAINT "PEV_ID_endereco_fkey" FOREIGN KEY ("ID_endereco") REFERENCES "ENDERECO"("ID_endereco");

ALTER TABLE "PEV" ADD CONSTRAINT "PEV_ID_usuario_fkey" FOREIGN KEY ("ID_usuario") REFERENCES "USUARIO"("ID_usuario");

ALTER TABLE "SOLICITACAO_COLETA" ADD CONSTRAINT "SOLICITACAO_COLETA_ID_B2B_fkey" FOREIGN KEY ("ID_B2B") REFERENCES "B2B"("ID_B2B") ON DELETE SET NULL;

ALTER TABLE "USUARIO" ADD CONSTRAINT "USUARIO_ID_endereco_fkey" FOREIGN KEY ("ID_endereco") REFERENCES "ENDERECO"("ID_endereco");
