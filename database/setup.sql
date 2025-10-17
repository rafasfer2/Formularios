-- Tabela principal com dados consolidados do formulário
CREATE TABLE cadastro_completo (
  id SERIAL PRIMARY KEY,
  data_hora_sistema TIMESTAMP,
  tempo_preenchimento NUMERIC,
  email_preenchedor TEXT,
  unidade TEXT,
  profissional TEXT,
  data_cadastro TIMESTAMP,
  nome_completo TEXT NOT NULL,
  cpf TEXT NOT NULL,
  telefone TEXT,
  rg TEXT,
  update_doc TEXT,
  tipo_demanda TEXT,
  unidade_origem TEXT,
  rede_intersetorial TEXT,
  obs_localidade TEXT,
  rede_semmu TEXT,
  nome_social TEXT,
  data_nascimento DATE NOT NULL,
  idade INTEGER,
  naturalidade TEXT,
  uf TEXT,
  gestante TEXT,
  raca_cor TEXT,
  escolaridade TEXT,
  atividade_laboral TEXT,
  estado_civil TEXT,
  deficiencia TEXT,
  orientacao_sexual TEXT,
  identidade_genero TEXT,
  municipio_residencia TEXT,
  bairro TEXT,
  logradouro TEXT,
  numero TEXT,
  quadra TEXT,
  lote TEXT,
  complemento TEXT,
  polo_visitado TEXT,
  zona TEXT,
  quantos_filhos INTEGER,
  condicao_moradia TEXT,
  ubs_referencia TEXT,
  renda_media NUMERIC,
  beneficio_social TEXT,
  valor_beneficio NUMERIC,
  valor_renda_propria NUMERIC,
  valor_renda_pensao NUMERIC
);


-- Tabela de composição familiar vinculada ao cadastro principal
CREATE TABLE IF NOT EXISTS composicao_familiar (
  id SERIAL PRIMARY KEY,
  id_cadastro INTEGER REFERENCES cadastro_completo(id),
  nome_completo TEXT NOT NULL,
  cpf TEXT NOT NULL,
  nome TEXT,
  sexo TEXT,
  parentesco TEXT,
  idade INTEGER,
  escolaridade TEXT,
  frequenta_escola TEXT,
  reside_com TEXT
);

CREATE INDEX IF NOT EXISTS idx_cpf_principal ON composicao_familiar(cpf_principal);

-- Tabela de usuários do sistema
CREATE TABLE IF NOT EXISTS usuarios (
  cpf TEXT PRIMARY KEY,
  usuario TEXT UNIQUE NOT NULL,
  senha_hash TEXT NOT NULL,
  nome TEXT NOT NULL,
  email_institucional TEXT,
  unidade TEXT,
  funcao TEXT,
  ativo INTEGER DEFAULT 1,
  data_contratacao DATE,
  perfil TEXT
);

-- Tabela complementar com dados editáveis dos usuários
CREATE TABLE IF NOT EXISTS usuarios_detalhes (
  cpf TEXT PRIMARY KEY REFERENCES usuarios(cpf),
  email_pessoal TEXT,
  telefone TEXT,
  foto TEXT,
  endereco TEXT,
  data_nascimento DATE,
  idade INTEGER,
  tempo_servico TEXT
);

-- Tabela de tokens de acesso temporário
CREATE TABLE IF NOT EXISTS tokens_acesso (
  token TEXT PRIMARY KEY,
  cpf TEXT REFERENCES usuarios(cpf),
  valido BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);