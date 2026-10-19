# Maratona beecrowd — C++11

Ambiente local para praticar maratonas de programação usando C++11.

## Execução

1. Edite `main.cpp` com a solução.
2. Crie um arquivo `stdin` com as entradas do problema.
3. Execute `make` para compilar e rodar o código.
4. Confira a saída gerada no arquivo `stdout`.

Comandos úteis:

```bash
make             # Compila (se necessário) e executa
make build       # Apenas compila
make run         # Compila (se necessário) e executa
make clean       # Remove binário e saída
make CXX=g++-16  # Usa o GCC do Homebrew quando recompilar
```

O Makefile redireciona automaticamente `stdin` para a entrada padrão e a saída padrão para `stdout`. Os arquivos `stdin`, `stdout` e o diretório `build` são locais e não entram no Git.

## Submissão

Envie o arquivo `main.cpp` para o beecrowd ou BOCA, selecionando C++11. Não utilize `freopen` no código; o juiz fornece a entrada padrão e captura a saída padrão diretamente.

`version.cpp` é um exemplo independente e não é compilado pelo Makefile principal.
