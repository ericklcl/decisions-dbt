# Instalação do dbt-core com o Adapter do Snowflake

Este guia fornece instruções passo a passo para instalar o **dbt-core** e configurar o adapter do **Snowflake** para começar a transformar seus dados.

## Pré-requisitos

Antes de iniciar, certifique-se de que você possui:

1. **Python** instalado (versão 3.7 ou superior).
2. **Git** instalado e configurado.
3. Credenciais de acesso ao banco de dados **Snowflake**.
4. Um ambiente de terminal ou shell configurado.

## Etapas de Instalação

### 1. Configurar um Ambiente Virtual
Para evitar conflitos de dependências, crie e ative um ambiente virtual Python:

```bash
# Criar o ambiente virtual
python3 -m venv venv

# Ativar o ambiente virtual
# Para Linux/MacOS
source venv/bin/activate

# Para Windows
venv\Scripts\activate
```

### 2. Instalar o dbt-core e o Adapter do Snowflake
Instale o pacote principal do dbt e o adapter para Snowflake usando `pip`:

```bash
pip install dbt-core dbt-snowflake
```

### 3. Verificar a Instalação
Após a instalação, verifique se o dbt foi instalado corretamente:

```bash
dbt --version
```

O comando deve exibir a versão do dbt-core e do adapter do Snowflake.

### 4. Configurar o dbt Project

#### 4.1 Criar um Novo Projeto dbt
Navegue até o diretório onde deseja criar o projeto e execute o seguinte comando:

```bash
dbt init meu_projeto_dbt(ou qualquer outro nome)
```

#### 4.2 Configurar o `profiles.yml`
O dbt utiliza o arquivo `profiles.yml` para armazenar informações de conexão com o banco de dados. Por padrão, este arquivo está localizado no diretório `~/.dbt/`.

Edite o arquivo `profiles.yml` e adicione as configurações para o Snowflake:

```yaml
meu_projeto_dbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "<seu_conta>"
      user: "<seu_usuario>"
      password: "<sua_senha>"
      role: "<sua_role>" # Opcional
      database: "<seu_banco>"
      warehouse: "<seu_warehouse>"
      schema: "<seu_esquema>"
      threads: 4
      client_session_keep_alive: False
```

Substitua os campos `<...>` pelas informações específicas do seu ambiente Snowflake.

### 5. Testar a Conexão
Verifique se o dbt consegue se conectar ao Snowflake:

```bash
dbt debug
```

Se tudo estiver configurado corretamente, você verá uma mensagem indicando que a conexão foi bem-sucedida.

## dbt Materializations

No DBT, há vários tipos de materializações que permitem um controle sobre a performance e como os dados são persistidos.

### 1. **Table**
A materialização `table` cria uma tabela física no banco de dados. Sempre que o modelo é executado, ele cria uma nova tabela substituindo a anterior.

- **Uso recomendado**: Ideal para dados que não mudam frequentemente ou quando você precisa garantir que a tabela final seja recriada a cada execução.
- **Exemplo de uso**:
    ```sql
    {{ config(
      materialized='table'
    ) }}
    ```

### 2. **View**
A materialização `view` cria uma view no banco de dados. Ao contrário das tabelas, as views não armazenam fisicamente os dados, mas apenas armazenam a consulta SQL. Elas são sempre recalculadas quando consultadas.

- **Uso recomendado**: Ideal para modelos que não exigem armazenamento físico dos dados e onde a consulta pode ser recalculada de forma eficiente.
- **Exemplo de uso**:
    ```sql
    {{ config(
      materialized='view'
    ) }}
    ```

### 3. **Ephemeral**
A materialização `ephemeral` cria modelos temporários que não são persistidos no banco de dados. Esses modelos são apenas usados durante a execução de outros modelos e são descartados depois.

- **Uso recomendado**: Ideal para modelos auxiliares que não precisam ser armazenados no banco, como transformações intermediárias.
- **Exemplo de uso**:
    ```sql
    {{ config(
      materialized='ephemeral'
    ) }}
    ```

### 4. **Incremental**
A materialização `incremental` permite adicionar novos dados a uma tabela existente, com base em uma condição de incremento (por exemplo, a data da última atualização). A ideia é evitar a recriação da tabela inteira a cada execução, economizando tempo e recursos computacionais.

#### Funcionamento Interno

Quando um modelo está configurado como `incremental`, o dbt:

1. Na **primeira execução**, cria a tabela com todos os dados da consulta.
2. Nas **execuções seguintes**, executa apenas uma parte da consulta com base em uma condição, usando `is_incremental()` para incluir somente os dados novos ou atualizados.

#### Exemplo:
```sql
{{ config(
    materialized='incremental',
    unique_key='id_venda'
) }}

SELECT *
FROM {{ source('raw_data', 'vendas') }}
{% if is_incremental() %}
WHERE data_venda > (SELECT MAX(data_venda) FROM {{ this }})
{% endif %}
```

#### Estratégias Suportadas

- **Append-only** (padrão): insere apenas os dados novos.
- **Merge**: atualiza registros existentes e insere novos.
  ```sql
  {{ config(
      materialized='incremental',
      unique_key='id_venda',
      incremental_strategy='merge',
      on_schema_change='sync_all_columns'
  ) }}
  ```

#### Requisitos
- Uma coluna incremental como `data_venda` ou um campo `updated_at`.
- Chave única (`unique_key`) se for usar `merge`.

#### Benefícios
- Reduz o custo de execução.
- Otimiza performance.
- Permite pipelines de dados frequentes e eficientes.

#### Quando Usar
- Grandes volumes de dados atualizados periodicamente.
- Dados de logs, transações, eventos, etc.

## Sources

No dbt, **sources** são tabelas ou views existentes no banco de dados que representam as fontes de dados presentes no Data Warehouse. O uso de sources permite rastrear a linhagem dos dados e melhorar a governança dos modelos.

### 1. Definição de um Source
Os sources são definidos no arquivo `source.yml` dentro do diretório do projeto dbt.

Exemplo:

```yaml
version: 2

sources:
  - name: raw_data
    description: "Tabelas brutas ingeridas no Snowflake."
    database: meu_banco
    schema: raw
    tables:
      - name: clientes
        description: "Tabela contendo informações dos clientes."
        columns:
          - name: id
            description: "Identificador único do cliente."
            
```

### 2. Utilizando Sources nos Modelos dbt
Após definir os sources, eles podem ser referenciados nos modelos dbt usando a função `source()`.

Exemplo:

```sql
SELECT *
FROM {{ source('raw_data', 'clientes') }}
```

### Source Freshness

O dbt permite verificar o quão atualizados estão os dados nos **sources**, garantindo que os dados estejam sendo atualizados conforme esperado.

#### 1. Configuração da Verificação de Freshness
A verificação de freshness pode ser configurada no `source.yml`:

```yaml
version: 2

sources:
  - name: raw_data
    tables:
      - name: clientes
        freshness:
          warn_after: {count: 24, period: hour}
          error_after: {count: 48, period: hour}
        loaded_at_field: <column_name_or_expression>
```

#### 2. Executando a Verificação de Freshness
O freshness pode ser verificado com:

```bash
dbt source freshness
```

Se os dados estiverem desatualizados, o dbt retornará um aviso ou erro com base nas configurações definidas.

### Seeds

Os **seeds** no dbt permitem carregar pequenos conjuntos de dados a partir de arquivos CSV para o banco de dados, facilitando o uso de dados de referência.

#### 1. Criando um Seed
Os arquivos seed devem ser colocados no diretório `seeds/` dentro do projeto dbt. Exemplo de arquivo `categorias.csv`:

```csv
id,nome
1,Eletrodomésticos
2,Eletrônicos
3,Móveis
```

#### 2. Carregando Seeds
Para carregar os seeds para o banco de dados, execute:

```bash
dbt seed
```

```bash
dbt seed --select <seed_name>
```
#### 3. Referenciando um Seed em um Modelo dbt
Depois de carregado, um seed pode ser referenciado como uma tabela normal:

```sql
SELECT * FROM {{ ref('categorias') }}
```

Isso permite que os seeds sejam utilizados como tabelas de lookup ou listas de valores fixos dentro do dbt.


### Snapshots

Os **snapshots** no dbt permitem rastrear as mudanças nos dados ao longo do tempo, armazenando versões históricas de registros.

#### Estratégias de Snapshot
O dbt suporta duas estratégias de snapshot:

1. **Timestamp**: Utiliza um campo de data/hora (`updated_at`) para verificar mudanças nos registros.
   ```sql
   {{ config(
       unique_key='id',
       strategy='timestamp',
       updated_at='updated_at'
   ) }}
   ```

2. **Check**: Compara os valores de colunas específicas para identificar mudanças.
   ```sql
   {{ config(
       unique_key='id',
       strategy='check',
       check_cols=['nome', 'email']
   ) }}
   ```

Essas estratégias ajudam a manter um histórico das alterações dos dados ao longo do tempo.

### Jinja

O dbt utiliza a linguagem **Jinja** para tornar seus modelos dinâmicos e reutilizáveis. Jinja permite o uso de lógica de programação dentro das queries SQL.

#### 1. Variáveis e Expressões
```sql
{% set nome_tabela = 'clientes' %}
SELECT * FROM {{ nome_tabela }}
```

#### 2. Estruturas de Controle
##### If-Else
```sql
{% if var('modo') == 'detalhado' %}
SELECT * FROM vendas_detalhado
{% else %}
SELECT * FROM vendas_resumido
{% endif %}
```

##### Loops
```sql
{% for ano in range(2020, 2023) %}
SELECT '{{ ano }}' AS ano UNION ALL
{% endfor %}
SELECT '2023' AS ano
```

#### 3. Filters
Os **filters** permitem manipular dados dentro das expressões Jinja. Exemplos:

```sql
SELECT {{ 'exemplo' | upper }} -- Retorna 'EXEMPLO'
SELECT {{ '  texto com espaços  ' | trim }} -- Retorna 'texto com espaços'
SELECT {{ 42 | string }} -- Converte número para string
```

Jinja torna os modelos mais flexíveis, facilitando a parametrização e a reutilização de código.

### Adapter no dbt

Os **adapters** no dbt são responsáveis por conectar o dbt a diferentes bancos de dados, executando comandos SQL e manipulando relações.

#### Utilizando Adapter no Jinja
No dbt, podemos utilizar o adapter de diferentes maneiras para acessar funcionalidades específicas do banco de dados.

##### 1. Usando Adapter com `adapter`
Podemos utilizar `adapter` diretamente dentro de um modelo dbt para obter informações sobre o banco de dados:

```sql
SELECT {{ adapter.dispatch('current_timestamp')() }} AS data_atual
```

Neste caso, o `adapter.dispatch()` permite que o dbt utilize a implementação correta do `current_timestamp` de acordo com o banco de dados configurado.

##### 2. Usando Adapter com `do adapter`
Ao utilizar `do adapter`, podemos executar operações diretamente sem retorno de valor.

Exemplo de uso para logar informações durante a execução:

```sql
{% do adapter.log('Iniciando processamento no banco de dados') %}
```

Isso pode ser útil para debug ou monitoramento dentro dos modelos.

#### Exemplo Completo de Uso do Adapter
Podemos usar o adapter para obter metadados sobre tabelas e esquemas:

```sql
{% set tables = adapter.list_relations(schema='public') %}

SELECT '{{ tables | map(attribute='identifier') | join(", ") }}' AS tabelas_disponiveis
```

Esse código lista todas as tabelas no esquema `public` e as retorna como uma string formatada.

O uso de `adapter` no dbt é uma forma poderosa de acessar informações específicas do banco e personalizar o comportamento dos modelos.

### Relation no dbt

A classe **Relation** representa um objeto no banco de dados, como uma tabela ou view. Podemos usar Jinja para gerar referências a esses objetos.

#### 1. Criando uma Relation
Podemos definir uma relation dinamicamente usando Jinja:

```sql
{% set minha_tabela = adapter.get_relation(database='meu_banco', schema='public', identifier='clientes') %}

SELECT * FROM {{ minha_tabela }}
```

Esse código gera dinamicamente uma referência à tabela `clientes` dentro do banco de dados.

### Column no dbt

A classe **Column** representa as colunas dentro de uma tabela ou view. Podemos extrair informações sobre colunas de uma relação.

#### 1. Obtendo Metadados das Colunas
Podemos listar as colunas de uma tabela dinamicamente:

```sql
{% set colunas = adapter.get_columns_in_relation(relation=minha_tabela) %}

SELECT {% for coluna in colunas %} {{ coluna.name }} {% if not loop.last %}, {% endif %} {% endfor %} FROM {{ minha_tabela }}
```

Esse código gera dinamicamente uma query que seleciona todas as colunas da tabela `clientes`.

## Data Tests no dbt

Os **Data Tests** (testes de dados) no dbt servem para validar a integridade, consistência e qualidade dos dados. Eles ajudam a garantir que as premissas sobre os dados estejam sendo respeitadas.

### Tipos de Data Tests

Existem dois principais tipos de data tests:

1. **Generic Tests (Testes Genéricos)**
2. **Singular Tests (Testes Personalizados)**

### 1. Generic Tests (Testes Genéricos)

Testes genéricos são validados com base em condições comuns aplicadas às colunas das tabelas. O dbt já fornece uma série de testes prontos que podem ser reutilizados facilmente.

#### Exemplos de testes genéricos:

```yaml
version: 2

models:
  - name: clientes
    columns:
      - name: id
        tests:
          - not_null
          - unique
      - name: status
        tests:
          - accepted_values:
              values: ['ativo', 'inativo']
```

#### Testes genéricos disponíveis:

* `not_null`: garante que nenhum valor na coluna seja nulo.
* `unique`: garante que os valores da coluna sejam únicos.
* `accepted_values`: define um conjunto de valores permitidos para uma coluna.
* `relationships`: garante a integridade referencial entre duas tabelas.

#### Exemplo com `relationships`:

```yaml
columns:
  - name: cliente_id
    tests:
      - relationships:
          to: ref('clientes')
          field: id
```

### 2. Singular Tests (Testes Personalizados)

Singular tests permitem criar regras personalizadas que são expressas como queries SQL que devem retornar **zero linhas** quando o teste passa.

#### Exemplo:

Crie um arquivo em `tests/test_clientes_sem_email.sql`:

```sql
SELECT *
FROM {{ ref('clientes') }}
WHERE email IS NULL
```

Se a query retornar alguma linha, o teste falha. Isso permite escrever qualquer lógica complexa de validação usando SQL puro.

### Executando os Testes

Para executar todos os testes:

```bash
dbt test
```

Executar testes de um modelo específico:

```bash
dbt test --select nome_do_modelo
```

Executar testes de um source específico:

```bash
dbt test --select source:raw_data.clientes
```

Executar apenas um teste personalizado (singular):

```bash
dbt test --select test_clientes_sem_email
```

### Boas Práticas com Data Tests

* Escreva testes genéricos para todas as colunas críticas.
* Use testes personalizados para validações específicas de negócio.
* Automatize a execução dos testes em pipelines CI/CD.
* Documente os testes no `schema.yml` para manter a rastreabilidade.

Data Tests são essenciais para garantir a confiabilidade dos dados e prevenir erros silenciosos em pipelines analíticos.

## Macros no dbt

Macros no dbt são funções reutilizáveis escritas em Jinja que permitem adicionar lógica e automação ao seu projeto. Elas são úteis para:

- Abstrair trechos de código SQL
- Tornar modelos mais genéricos
- Evitar repetição de código

---

### Criando uma Macro

As macros devem ser criadas em arquivos `.sql` dentro do diretório `macros/` no seu projeto dbt.

#### Exemplo básico

```sql
-- macros/minha_macro.sql
{% macro gerar_seletor(coluna) %}
    SELECT {{ coluna }} FROM minha_tabela
{% endmacro %}
```

---

### Utilizando uma Macro

Macros podem ser usadas em modelos, testes, snapshots ou seeds:

```sql
{{ gerar_seletor('id') }}
```

---

### Parâmetros e Lógica Condicional

Macros podem aceitar argumentos e utilizar estruturas de controle:

```sql
{% macro filtrar_por_status(status='ativo') %}
    WHERE status = '{{ status }}'
{% endmacro %}
```

---

### `run_query` — Executando SQL dentro da Macro

O `run_query` permite executar instruções SQL dentro de uma macro e usar o resultado como entrada para decisões lógicas.

#### Exemplo:

```sql
{% macro contar_registros(modelo) %}
    {% set resultado = run_query("SELECT COUNT(*) FROM " ~ modelo) %}
    {% if execute %}
        {% set quantidade = resultado.columns[0].values()[0] %}
        {{ log("Total de registros: " ~ quantidade, info=True) }}
    {% endif %}
{% endmacro %}
```

---

### `if execute` — Evitando Execução Durante Compilação

Use `{% if execute %}` para garantir que `run_query` e outras operações executem apenas durante a **execução real** do dbt (e não durante a compilação).

```sql
{% if execute %}
  {% set resultado = run_query("SELECT COUNT(*) FROM tabela") %}
{% endif %}
```

> Evita o erro: `run_query() is being called during compilation`

---

### Boas Práticas com Macros

- Nomeie macros com clareza e contexto
- Reutilize lógica repetida como joins e filtros
- Documente parâmetros e propósito
- Use `run_query` com parcimônia
- Sempre utilize `if execute` antes de executar queries

---

### `run-operation` — Executando Macros Manualmente

O comando `dbt run-operation` permite executar macros de forma isolada pelo terminal.

### Sintaxe:

```bash
dbt run-operation <nome_da_macro> --args '{"param": "valor"}'
```

#### Exemplo com criação de schema:

```sql
{% macro criar_schema(schema_name) %}
    {% if execute %}
        {% do run_query("CREATE SCHEMA IF NOT EXISTS " ~ target.database ~ "." ~ schema_name) %}
        {{ log("Schema " ~ schema_name ~ " criado com sucesso!", info=True) }}
    {% endif %}
{% endmacro %}
```

```bash
dbt run-operation criar_schema --args '{"schema_name": "staging"}'
```

#### Casos de uso:

- Criação de schemas e objetos auxiliares
- Verificações e validações operacionais
- Limpeza de dados temporários
- Ações de administração no warehouse


## Custom Generic Tests no dbt

Os **Generic Tests** no dbt são testes reutilizáveis que validam colunas de modelos ou fontes com regras como `not_null`, `unique`, entre outras. Além dos testes nativos, o dbt permite criar **Custom Generic Tests** para aplicar validações específicas e reutilizáveis de acordo com as regras de negócio.

---

### O que é um Custom Generic Test?

É um teste genérico definido pelo usuário no diretório `tests/` ou `macros/`, que pode ser aplicado diretamente nas colunas dos modelos através do arquivo `schema.yml`.

---

### Estrutura de um Custom Generic Test

```sql
-- tests/assert_positive_values.sql
{% test assert_positive_values(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} <= 0

{% endtest %}
```

Esse teste falha se encontrar valores menores ou iguais a zero na coluna testada.

---

### Como aplicar um Custom Generic Test

No `schema.yml` do modelo:

```yaml
version: 2

models:
  - name: pagamentos
    columns:
      - name: valor
        tests:
          - assert_positive_values
```

> O nome `assert_positive_values` deve coincidir com o nome da macro.

---

### Passando argumentos para o teste

Você pode adicionar lógica condicional no seu teste, utilizando argumentos opcionais:

```sql
-- tests/assert_min_length.sql
{% test assert_min_length(model, column_name, min_length=5) %}

SELECT *
FROM {{ model }}
WHERE LENGTH({{ column_name }}) < {{ min_length }}

{% endtest %}
```

Aplicação com parâmetro:

```yaml
tests:
  - assert_min_length:
      min_length: 8
```

---

### Reutilização com múltiplas colunas

É possível aplicar o mesmo teste customizado a várias colunas:

```yaml
columns:
  - name: email
    tests:
      - assert_min_length:
          min_length: 10
  - name: telefone
    tests:
      - assert_min_length:
          min_length: 9
```

---

### Boas práticas

- Nomeie os testes com clareza e contexto (ex: `assert_`, `validate_`, `check_`)
- Sempre retorne linhas que **violam a regra**
- Use `WHERE` direto, sem `SELECT COUNT(*)` — o dbt já valida se existem linhas
- Testes customizados devem ser armazenados em `tests/` ou `macros/`

---

### Executando os testes

Para executar os testes:

```bash
dbt test
```

Para um modelo específico:

```bash
dbt test --select pagamentos
```

---

Custom Generic Tests ajudam a manter a qualidade dos dados e padronizar validações em todo o projeto dbt.








