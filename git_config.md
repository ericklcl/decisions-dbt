# Configuração do Repositório GitHub com Linux

Este guia explica como configurar a integração entre um repositório GitHub e um laptop com Linux.

## Passo 1: Instalar o Git

Primeiro, verifique se o Git está instalado no seu sistema. Se não estiver, use o seguinte comando para instalá-lo:

```bash
sudo apt update
sudo apt install git
```

## Passo 2: Configurar o Git

Após instalar o Git, configure seu nome de usuário e e-mail globalmente:

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seuemail@dominio.com"
```

## Passo 3: Gerar uma Chave SSH (Opcional, mas Recomendado)

Para gerar uma chave SSH, execute o seguinte comando:

```bash
ssh-keygen -t ed25519 -C "seuemail@dominio.com" -f ~/.ssh/nome_personalizado_da_chave
```

Após a geração da chave SSH, adicione-a ao GitHub.

Para encontrar sua chave pública, utilize:

```bash
cat ~/.ssh/nome_personalizado_da_chave.pub
```

Copie o conteúdo exibido e siga os passos abaixo para adicioná-lo ao GitHub:

1. Acesse [GitHub](https://github.com) e faça login.
2. No canto superior direito, clique na sua foto de perfil e selecione **"Settings"**.
3. Na barra lateral esquerda, vá até **"SSH and GPG keys"**.
4. Clique em **"New SSH key"**, cole a chave copiada e dê um título a ela.
5. Clique em **"Add SSH key"**.

Com isso, sua chave SSH estará vinculada à sua conta do GitHub, permitindo acessar os repositórios sem precisar digitar sua senha toda vez.

## Passo 4: Testar a Chave SSH

Para testar se a chave SSH foi adicionada corretamente ao GitHub, execute o seguinte comando:

```bash
ssh -T git@github.com
```

Se a configuração estiver correta, a saída deverá ser semelhante a:

```bash
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

Caso apareça um erro, verifique se a chave SSH foi adicionada corretamente ao GitHub e se o agente SSH está em execução:

```bash
ssh-agent bash
ssh-add ~/.ssh/nome_personalizado_da_chave
```

Se o erro **"Could not open a connection to your authentication agent"** persistir, tente iniciar o agente manualmente com:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/nome_personalizado_da_chave
```

Se ao testar a chave SSH aparecer a mensagem **"The authenticity of host 'github.com (...) can't be established."**, siga estes passos:

1. Digite `yes` e pressione **Enter** para confirmar a conexão.
2. A chave do GitHub será armazenada localmente em `~/.ssh/known_hosts`, evitando que essa mensagem apareça novamente no futuro.

## Passo 5: Clonar Repositórios Privados e Operações com Git

Com essa configuração, você poderá realizar as seguintes operações em repositórios privados sem precisar digitar usuário e senha:

- **Clonar repositórios privados:**
  ```bash
  git clone git@github.com:usuario/repositorio-privado.git
  ```

- **Adicionar arquivos ao repositório:**
  ```bash
  git add .
  ```

- **Fazer commits das alterações:**
  ```bash
  git commit -m "Mensagem do commit"
  ```

- **Enviar (push) as alterações para o repositório remoto:**
  ```bash
  git push origin main  # ou a branch desejada
  ```

- **Baixar (pull) as atualizações do repositório remoto:**
  ```bash
  git pull origin main  # ou a branch desejada
  ```

Se a chave SSH foi adicionada corretamente e está funcionando, todas essas operações poderão ser realizadas sem a necessidade de autenticação manual.