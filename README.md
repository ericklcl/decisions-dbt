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

- **Uso recomendado**: Ideal para grandes volumes de dados que são atualizados periodicamente, como tabelas de transações ou logs.


## dbt Sources

No dbt, **Sources** são tabelas ou arquivos externos que servem como ponto de entrada dos dados no projeto. Essas fontes geralmente representam dados brutos que foram carregados para um Data Warehouse a partir de sistemas transacionais, pipelines de ingestão ou outras fontes externas.

O uso de **sources** no dbt permite documentar e testar os dados desde sua origem, garantindo maior rastreabilidade e confiabilidade ao processo de transformação.

### Definição de Sources
Para definir um **source** no dbt, utilizamos arquivos YAML dentro da pasta `models/schema.yml` ou `models/sources.yml`.

#### Exemplo de definição de Source:
```yaml
version: 2

sources:
  - name: raw_data  # Nome da fonte de dados
    database: my_database  # Opcional, dependendo do warehouse
    schema: raw_schema  # Esquema onde as tabelas estão localizadas
    tables:
      - name: orders
        description: "Tabela contendo os pedidos realizados pelos clientes."
        columns:
          - name: order_id
            description: "Identificador único do pedido."
            tests:
              - unique
              - not_null
          - name: customer_id
            description: "Identificador do cliente que fez o pedido."
          - name: order_date
            description: "Data em que o pedido foi realizado."
            tests:
              - not_null
```

### Benefícios do uso de Sources
1. **Documentação**: Permite descrever a origem dos dados e suas tabelas, facilitando a governança.
2. **Testes de qualidade**: Aplicação de testes como `unique`, `not_null` e `relationships` diretamente nos dados de origem.
3. **Rastreabilidade**: Melhora a transparência do fluxo de dados ao permitir a visualização das dependências e da linhagem.
4. **Facilidade de Referência**: Em vez de hardcodear nomes de tabelas brutas nos modelos dbt, podemos referenciá-las de forma gerenciada com `source`.

### Como Referenciar um Source no dbt
Para referenciar um source dentro de um modelo dbt, utilizamos a função `source`.

#### Exemplo:
```sql
SELECT
    order_id,
    customer_id,
    order_date
FROM {{ source('raw_data', 'orders') }}
```
Isso garante que, caso o nome da tabela ou do esquema mude, basta atualizar o arquivo de definição de sources sem necessidade de alterar diretamente os modelos SQL.

### Boas práticas
- Utilize `dbt source freshness` para monitorar a atualização dos dados de origem.
- Organize seus sources dentro de arquivos YAML separados, especialmente em projetos grandes.


