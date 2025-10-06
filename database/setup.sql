-- Tabela principal com dados consolidados do formulário
CREATE TABLE IF NOT EXISTS cadastro_completo (
  id SERIAL PRIMARY KEY,
  data_hora_sistema     TEXT,
  tempo_preenchimento   REAL,
  data_hora_informada   TEXT,
  unidade               TEXT,
  profissional          TEXT,
  polo_visitado         TEXT,
  nome_social           TEXT,
  nome_completo         TEXT,
  cpf                   TEXT,
  telefone              TEXT,
  data_nascimento       TEXT,
  naturalidade          TEXT,
  uf                    TEXT,
  quantos_filhos        INTEGER,
  gestante              TEXT,
  raca_cor              TEXT,
  escolaridade          TEXT,
  atividade_laboral     TEXT,
  estado_civil          TEXT,
  deficiencia           TEXT,
  orientacao_sexual     TEXT,
  identidade_genero     TEXT,
  municipio_residencia  TEXT,
  bairro                TEXT,
  logradouro            TEXT,
  numero                TEXT,
  quadra                TEXT,
  lote                  TEXT,
  complemento           TEXT,
  zona_residencia       TEXT,
  condicao_moradia      TEXT,
  ubs_referencia        TEXT,
  renda_media           TEXT,
  beneficio_social      TEXT,
  valor_beneficio       TEXT,
  valor_renda_propria   TEXT,
  valor_renda_pensao    TEXT
);

-- Tabela de composição familiar vinculada ao cadastro principal
CREATE TABLE IF NOT EXISTS composicao_familiar (
  id SERIAL PRIMARY KEY,
  id_cadastro           INTEGER,
  cpf_principal         TEXT,
  nome                  TEXT,
  sexo                  TEXT,
  parentesco            TEXT,
  idade                 INTEGER,
  escolaridade          TEXT,
  frequenta_escola      TEXT,
  reside_com            TEXT,
  FOREIGN KEY (id_cadastro) REFERENCES cadastro_completo(id)
);

CREATE INDEX IF NOT EXISTS idx_cpf_principal ON composicao_familiar(cpf_principal);

-- Tabela de usuários do sistema
-- DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
  cpf TEXT PRIMARY KEY,
  usuario TEXT,
  senha_hash TEXT,
  nome TEXT,
  email_institucional TEXT,
  unidade TEXT,
  funcao TEXT,
  ativo INTEGER,
  data_contratacao TEXT,
  perfil TEXT
);

-- Tabela complementar com dados editáveis dos usuários
CREATE TABLE IF NOT EXISTS usuarios_detalhes (
  cpf TEXT PRIMARY KEY,
  email_pessoal TEXT,
  telefone TEXT,
  foto TEXT,
  endereco TEXT,
  data_nascimento TEXT,
  idade INTEGER,
  tempo_servico TEXT
);