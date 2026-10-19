# Maratona beecrowd — C++11

Ambiente para praticar maratonas de programação com C++11, usando GNU Make e o compilador `g++`.

## Uso local

1. Escreva a solução em `main.cpp`.
2. Preencha o arquivo `stdin` com as entradas do problema.
3. Rode `make` (ou `make run`).
4. Consulte `stdout` para ver a saída produzida.

| Comando | Ação |
| --- | --- |
| `make help` | Lista os comandos disponíveis. |
| `make` ou `make run` | Compila `main.cpp` se necessário, lê `stdin` e escreve `stdout`. |
| `make build` | Compila apenas `main.cpp` em `build/main`. |
| `make version` | Compila e executa `version.cpp`, mostrando no terminal o padrão C++ utilizado. |
| `make build-version` | Compila `version.cpp` em `build/version`, sem executar. |
| `make clean` | Remove somente `build/`; preserva os exemplos `stdin` e `stdout`. |
| `make run INPUT=outro.in OUTPUT=outro.out` | Lê e escreve outros arquivos. |
| `make clean && make CXX=g++-16` | Recompila com o GCC do Homebrew, se instalado. |

A compilação usa `-std=c++11 -O2 -Wall -Wextra -pedantic`. Se trocar de compilador ou de flags, execute `make clean` para forçar a recompilação.

### Exemplos versionados de entrada e saída

Os arquivos `stdin` e `stdout` estão **versionados** como um exemplo didático para o problema da soma de dois números por linha, até o fim da entrada:

```text
# stdin (sem a linha de comentário)
1 2
10 20
-8 3
```

```text
# stdout (sem a linha de comentário)
3
30
-5
```

Uma solução C++11 correspondente seria:

```cpp
#include <iostream>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int a, b;
    while (cin >> a >> b) {
        cout << a + b << '\n';
    }
}
```

**Importante:** `main.cpp` é um esqueleto independente desse exemplo; atualmente ele lê um número, cria um vetor e não imprime resultados. Portanto, `make run` com o `main.cpp` atual sobrescreverá `stdout` com um arquivo vazio. Para restaurar o exemplo versionado, execute `git restore stdout`. Ao usar o projeto para outros exercícios, substitua o conteúdo de `stdin` e confira a nova saída.

## Entrada/saída: desempenho e cuidados

Use o seguinte início de `main` na maioria dos problemas:

```cpp
int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    // ...
}
```

- `ios::sync_with_stdio(false)` desativa a sincronização automática entre os streams de C++ (`cin`, `cout`) e os de C (`scanf`, `printf`). Isso pode acelerar a entrada e saída.
- **Não misture** `cin`/`cout` com `scanf`/`printf` depois dessa configuração: os buffers deixam de ser sincronizados e a ordem de leitura/escrita pode ser inesperada. Escolha uma família de I/O por programa.
- `cin.tie(nullptr)` elimina o `flush` automático de `cout` antes de cada leitura em `cin`, reduzindo custo adicional. Em problemas **interativos**, use `cout << flush` quando o juiz precisar receber imediatamente a resposta.
- Prefira `'\n'` a `endl` nas saídas comuns: `endl` também força `flush`.
- A leitura `while (cin >> a >> b)` termina no EOF. `getline(cin, texto)` lê uma linha inteira; ao alternar leitura formatada e `getline`, descarte a quebra de linha pendente quando necessário.
- Não use `freopen("stdin", ...)` nem `freopen("stdout", ...)` na solução: o Makefile faz o redirecionamento **apenas localmente**.

## Includes (bibliotecas) em C++11

`#include` traz declarações dos cabeçalhos necessários. Para obter **portabilidade C++11**, inclua apenas os cabeçalhos usados:

| Cabeçalho | Principais recursos |
| --- | --- |
| `<iostream>` | `cin`, `cout` |
| `<iomanip>` | `fixed`, `setprecision` |
| `<vector>`, `<array>`, `<deque>` | Coleções sequenciais |
| `<string>`, `<sstream>` | Strings e conversões |
| `<algorithm>` | `sort`, `reverse`, `find`, `lower_bound`, `upper_bound` |
| `<numeric>` | `accumulate`, `iota`, `partial_sum` |
| `<queue>`, `<stack>` | `queue`, `priority_queue`, `stack` |
| `<set>`, `<map>` | `set`, `multiset`, `map` |
| `<unordered_set>`, `<unordered_map>` | Coleções baseadas em hash |
| `<utility>`, `<tuple>` | `pair`, `tuple` |
| `<functional>` | `greater`, comparadores |
| `<cmath>`, `<climits>`, `<limits>` | Funções e limites numéricos |
| `<bitset>`, `<cctype>` | Bits e classificação de caracteres |

Exemplo:

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    vector<int> valores = {3, 1, 2};
    sort(valores.begin(), valores.end());

    for (int valor : valores) {
        cout << valor << '\n';
    }
}
```

### Alternativa para GCC

```cpp
#include <bits/stdc++.h>
using namespace std;
```

`bits/stdc++.h` é um **cabeçalho específico de GCC/libstdc++**, não faz parte do padrão ISO C++11. Pode economizar tempo na prova, mas não é portável para todos os compiladores. Ele foi testado com `-std=c++11` no GCC 11.4.0 da imagem `boca-jail` de `joaofazolo/boca-docker`; o compilador efetivo do torneio pode variar. No beecrowd, confira o compilador/language selecionado.

**Atenção à versão:** `std::gcd`, `std::lcm` e structured bindings (`auto [a, b]`) são C++17, e não estão disponíveis no C++11 padrão.

## Envio para BOCA e beecrowd

Envie somente o código-fonte da solução (normalmente `main.cpp`) e selecione a linguagem C++11 ou o equivalente disponível. O juiz já fornece compilador e biblioteca padrão, realiza a compilação e passa a entrada por `stdin` e a saída por `stdout` reais. O `Makefile`, o diretório `build/` e os arquivos de exemplo locais não são necessários na submissão.
