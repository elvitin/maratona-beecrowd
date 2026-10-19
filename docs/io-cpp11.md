# I/O de C++11: equivalências com scanf/printf e limitações

Este guia mostra como expressar formatos da biblioteca C (`scanf`/`printf`) com **`std::cin`**, **`std::cout`** e os manipuladores de **C++11**. Também explica **o que não tem correspondência direta** nos streams de C++11.

**Resposta curta:** `iostream` **não é inferior ao I/O de C para a maioria dos problemas de maratona**. Oferece extração/inserção tipadas, `std::string`, streams de arquivo e formatação configurável. Porém não é uma substituição sintática completa da minilinguagem de formatos `%...` de `scanf`/`printf`. Alguns formatos são menos concisos, e certas regras de varredura exigem código adicional. **C++11 não tem `std::format` nem `std::print`.**

Veja também: [I/O com a biblioteca C em programas C++11](io-c.md).

## 1. Início recomendado para problemas com I/O de C++

```cpp
#include <iostream>
using namespace std;

int main()
{
    ios::sync_with_stdio(false); // Desativa sincronização com stdio de C.
    cin.tie(nullptr);            // Evita flush de cout antes de cin.

    int primeiroNumero, segundoNumero;
    while (cin >> primeiroNumero >> segundoNumero)
    {
        cout << primeiroNumero + segundoNumero << '\n';
    }

    return 0;
}
```

`while (cin >> a >> b)` corresponde à lógica de `while (scanf("%d %d", &a, &b) == 2)`: só entra no bloco se ambos foram extraídos com sucesso. O stream sinaliza falha/EOF em seu estado, em vez de retornar o número de atribuições.

Os dois comandos do início são **opcionais**, mas úteis em maratonas:

- `std::ios::sync_with_stdio(false)`: permite buffers de C e C++ independentes; isso pode acelerar `cin`/`cout`. **Não misture `cin`/`cout` com `scanf`/`printf` após desativar a sincronização**, pois a ordem e a leitura podem ser afetadas. Chame antes de qualquer I/O.
- `std::cin.tie(nullptr)`: não faz `cout` descarregar o buffer automaticamente antes de cada leitura. Em **problemas interativos**, dê `std::cout << std::flush` explicitamente antes de esperar a resposta do juiz.
- `'\n'` é apenas uma quebra de linha; `std::endl` também realiza `flush`. Prefira `'\n'` quando não precisar de flush imediato.

## 2. Equivalências de leitura: scanf → cin

Em geral, `operator>>` determina como ler com base no **tipo da variável**, sem especificadores `%d`, `%lf` etc.

| I/O de C | I/O de C++11 | Observação |
| --- | --- | --- |
| `scanf("%d", &inteiro)` | `cin >> inteiro` | `inteiro` do tipo `int`. |
| `scanf("%lld", &grande)` | `cin >> grande` | `grande` do tipo `long long`. |
| `scanf("%lf", &real)` | `cin >> real` | `real` do tipo `double`. |
| `scanf("%f", &real)` | `cin >> real` | `real` do tipo `float`. |
| `scanf("%d %d", &a, &b)` | `cin >> a >> b` | Espaços, tabs e quebras de linha separam valores. |
| `scanf("%s", palavra)` | `cin >> palavra` | `palavra` pode ser `std::string`, sem buffer fixo. |
| `scanf(" %c", &letra)` | `cin >> letra` | Ambos pulam espaços anteriores, por padrão. |
| `scanf("%c", &letra)` | `cin.get(letra)` | Lê inclusive espaço e quebra de linha. |
| `fgets(linha, N, stdin)` | `getline(cin, linha)` | `linha` é `std::string`; **descarta** o delimitador `'\n'`. |
| `getchar()` | `cin.get()` | Retorna tipo `int` com possibilidade de indicar EOF. |
| `scanf("%x", &valor)` | `cin >> hex >> valor` | Lê hexadecimal; a base do stream é persistente. |
| `scanf("%o", &valor)` | `cin >> oct >> valor` | Lê octal. |
| `scanf("%i", &valor)` | `cin >> setbase(0) >> valor` | Detecta base a partir do prefixo: decimal, `0` (octal) ou `0x` (hex); requer `<iomanip>`. |
| `sscanf(texto, "%d %lf", &a, &b)` | `istringstream(texto) >> a >> b` | Requer `<sstream>`. |

### Casos especiais na leitura

**Linha completa após `cin >>`:** a operação `>>` deixa a quebra de linha pendente. Se quiser a **próxima linha**, descarte o restante da linha atual:

```cpp
#include <iostream>
#include <string>
#include <limits>

int main()
{
    int codigo;
    if (!(std::cin >> codigo)) return 0;

    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    std::string descricao;
    std::getline(std::cin, descricao); // Pode ser vazia; preserva espaços iniciais.
    std::cout << descricao << '\n';
}
```

Alternativa para capturar a próxima linha **não vazia em termos de espaços iniciais**: `getline(cin >> ws, descricao)`. Atenção: `std::ws` remove **todos** os espaços/quebras de linha iniciais e, portanto, não é equivalente quando linhas vazias são dados válidos.

**Ler cada caractere, incluindo espaços:**

```cpp
char caractere;
while (std::cin.get(caractere))
{
    std::cout.put(caractere);
}
```

**Conversão em memória:**

```cpp
#include <sstream>
#include <string>
#include <iostream>

int main()
{
    std::istringstream entrada("123 4.50");
    int codigo;
    double preco;
    if (entrada >> codigo >> preco)
    {
        std::ostringstream saida;
        saida << codigo << ": " << preco;
        std::cout << saida.str() << '\n';
    }
}
```

## 3. Equivalências de saída: printf → cout

Inclua `<iostream>` e `<iomanip>` para os manipuladores de formatação.

| `printf` (C) | `cout` (C++11) | Resultado / cuidado |
| --- | --- | --- |
| `printf("%d", numero)` | `cout << numero` | Inteiro decimal, supondo base decimal ativa. |
| `printf("%lld", grande)` | `cout << grande` | `long long` sem especificador especial. |
| `printf("%.2f", real)` | `cout << fixed << setprecision(2) << real` | Duas casas **depois da vírgula decimal**. |
| `printf("%.6g", real)` | `cout << defaultfloat << setprecision(6) << real` | Até 6 algarismos significativos (forma geral). |
| `printf("%.3e", real)` | `cout << scientific << setprecision(3) << real` | Notação científica com 3 casas fracionárias. |
| `printf("%8d", numero)` | `cout << setw(8) << numero` | Largura **mínima** 8; alinhamento padrão à direita. |
| `printf("%-8d", numero)` | `cout << left << setw(8) << numero` | Alinha à esquerda; `left` persiste. |
| `printf("%08d", numero)` | `cout << setfill('0') << setw(8) << numero` | Zero à esquerda, com ressalvas para números negativos. |
| `printf("%+d", numero)` | `cout << showpos << numero` | Exibe sinal `+`; `showpos` persiste. |
| `printf("%x", numero)` | `cout << hex << numero` | Hexadecimal minúsculo (tipicamente inteiro sem sinal). |
| `printf("%X", numero)` | `cout << uppercase << hex << numero` | Hexadecimal maiúsculo. |
| `printf("%#x", numero)` | `cout << showbase << hex << numero` | Prefere prefixo `0x` para valores não zero. |
| `printf("%o", numero)` | `cout << oct << numero` | Octal. |
| `printf("%s", texto)` | `cout << texto` | Aceita `std::string` e strings C. |
| `printf("%.4s", texto)` | `cout << texto.substr(0, 4)` | Requer `std::string`; opera em bytes/unidades de `char`, não em caracteres Unicode. |
| `printf("50%%")` | `cout << "50%"` | Não é preciso escapar o `%` em streams. |
| `fprintf(stderr, "erro")` | `cerr << "erro"` | Saída de erro; nunca dependa dela para resposta do juiz. |

**Não são equivalências byte a byte em todos os cenários.** Alguns detalhes variam por arredondamento, locale, apresentação de valores especiais (`NaN`, infinitos), sinal/zero e regras das implementações. Compare com a saída exigida pelo enunciado.

### Por que fixed importa?

`std::setprecision` sozinho define a **precisão significativa** em formato geral, e não a quantidade de casas decimais:

```cpp
#include <iostream>
#include <iomanip>

int main()
{
    double valor = 3.14159265;

    std::cout << std::setprecision(2) << valor << '\n';               // 3.1
    std::cout << std::fixed << std::setprecision(2) << valor << '\n'; // 3.14
}
```

Portanto, o equivalente usual de `printf("%.2f", valor)` **inclui `std::fixed`**.

### Exemplo completo de formatação

```cpp
#include <iostream>
#include <iomanip>

int main()
{
    int numero = 42;
    double valor = 3.14159265;

    std::cout << std::setw(6) << numero << '\n';                  // "    42"
    std::cout << std::setfill('0') << std::setw(6) << numero
              << '\n';                                            // "000042"

    // internal garante que o sinal seja impresso antes do preenchimento.
    std::cout << std::internal << std::setw(6) << -numero
              << '\n';                                            // "-00042"

    // Restaura preenchimento e alinhamento para o restante do programa.
    std::cout << std::setfill(' ') << std::right;
    std::cout << std::fixed << std::setprecision(2) << valor
              << '\n';                                            // "3.14"

    std::cout << std::hex << std::uppercase << numero << '\n';     // "2A"

    // Restaurar configurações persistentes.
    std::cout << std::dec << std::nouppercase << std::defaultfloat;
}
```

### Manipuladores: persistentes ou pontuais?

| Manipulador | Efeito | Duração |
| --- | --- | --- |
| `setw(N)` | Largura mínima para o próximo campo | **Somente a próxima formatação aplicável** |
| `setprecision(N)` | Precisão de ponto flutuante | **Persistente** |
| `setfill('0')` | Caractere de preenchimento | **Persistente** |
| `fixed`, `scientific`, `defaultfloat` | Modo de ponto flutuante | **Persistente** |
| `hex`, `oct`, `dec` | Base de inteiros | **Persistente** |
| `left`, `right`, `internal` | Alinhamento | **Persistente** |
| `showpos`, `noshowpos` | Sinal positivo | **Persistente** |
| `showbase`, `noshowbase` | Prefixo numérico | **Persistente** |
| `uppercase`, `nouppercase` | Letras maiúsculas em formatos numéricos | **Persistente** |
| `boolalpha`, `noboolalpha` | `true/false` vs. `1/0` | **Persistente** |

Dica: encapsule formatações pontuais em `std::ostringstream` ou restaure os manipuladores para impedir que uma saída altere a seguinte.

## 4. Limitações e diferenças reais do iostream em C++11

### 4.1 Não existe o mesmo formato compacto de printf

Em C:

```cpp
std::printf("Codigo: %04d | Preco: %8.2f\n", codigo, preco);
```

Em C++11:

```cpp
std::cout << "Codigo: " << std::setfill('0') << std::setw(4) << codigo
          << std::setfill(' ') << " | Preco: "
          << std::fixed << std::setprecision(2) << std::setw(8) << preco
          << '\n';
```

Ambos funcionam. No segundo, o controle é feito por estado e manipuladores, o que pode exigir mais código e restauração de opções.

- `std::format("...")` só existe a partir de **C++20**.
- `std::print("...")` e `std::println("...")` só existem a partir de **C++23**.
- `std::quoted` é **C++14**; não o utilize em C++11.

### 4.2 scanf tem padrões especiais sem operador idêntico de cin

| Recurso de `scanf` | C++11 |
| --- | --- |
| `%3d` (limitar caracteres consumidos de um inteiro) | **Não há substituição direta usando `cin >> int`**. Implemente a leitura de um prefixo com `get()`/buffer e converta com `std::istringstream` ou use `scanf` se a regra exata for exigida. `setw(3)` em `cin >> int` **não é equivalente**. |
| `%*d` (ler e descartar inteiro) | `int ignorado; cin >> ignorado;` |
| `%[a-z]` (conjunto de caracteres) | Ler caracteres e testar a faixa manualmente ou usar uma expressão regular (`<regex>`, C++11). Não existe um scanset nativo em `operator>>`. |
| `%[^\n]` (até a quebra de linha) | `getline(cin, linha)`, observando o tratamento diferente da quebra de linha e de linhas vazias. |
| `%n` (contagem de caracteres consumidos) | Não há equivalente geral para `stdin`. `tellg()` serve para posições em streams que suportem posicionamento, não como substituto universal. |
| `%i` (base automática) | `cin >> setbase(0) >> numero`; restaure com `dec` depois. |
| `%5s` (largura da palavra) | `std::setw(5) >> std::string` pode limitar a quantidade extraída, mas a semântica e a segurança diferem de um `char[]` fixo do C. |

**Ponto essencial:** C++11 não oferece um interpretador universal de formatos do tipo `scanf` para streams padrão. Isso é uma diferença de **ergonomia e semântica**, não uma incapacidade de ler os dados.

### 4.3 Diferentes comportamentos de espaços e delimitadores

- `cin >> numero`, `cin >> palavra` e `cin >> letra` ignoram espaços iniciais por padrão (`skipws`).
- `cin.get(letra)` **não** ignora espaços; semelhante a `scanf("%c")`.
- `getline(cin, linha)` preserva espaços internos/iniciais e descarta o delimitador `'\n'` (enquanto `fgets` o retém quando couber).
- `cin >> noskipws` altera o comportamento de extração; restabeleça `skipws` para voltá-lo ao padrão.
- Não suponha que `cin >> numero` seguido de `getline` irá ignorar automaticamente o restante da linha.

### 4.4 Precisão, arredondamento e locale

`printf("%.2f", valor)` e `cout << fixed << setprecision(2) << valor` costumam produzir o mesmo texto para valores comuns, mas não trate isso como identidade para todas as combinações de valores, locales e implementações.

- `double` possui representação binária aproximada: `0.1` geralmente não é exato internamente.
- `printf` e streams usam as configurações de locale aplicáveis a cada família.
- Se a prova exige ponto decimal e separadores previsíveis, mantenha o locale apropriado (os ambientes de juiz normalmente utilizam o locale C).
- Nem a sintaxe C nem a C++ resolve automaticamente problemas de precisão monetária.

### 4.5 Desempenho: compare no seu cenário

Não há regra universal de que `scanf` seja sempre mais rápido. `cin` com sincronização desligada frequentemente é competitivo. O resultado depende de implementação, dados, volume de entrada, operações de conversão e buffering.

```cpp
std::ios::sync_with_stdio(false);
std::cin.tie(nullptr);
```

Essas instruções são para **I/O C++**. Não melhoram o desempenho do `scanf`/`printf`.

### 4.6 Segurança e extensibilidade

- **Ponto forte de C++:** tipos determinam como extrair e inserir; não há risco de esquecer `%lld` para um `long long`.
- **Ponto forte de C++:** `std::string` cresce conforme necessário; evita os overflow comuns em `scanf("%s", array)` sem largura.
- **Ponto forte de C++:** `operator<<` e `operator>>` podem ser sobrecarregados para tipos próprios.
- **Cuidado em C++:** o stream guarda flags de erro. Após `fail()`, não basta repetir a leitura: pode ser necessário `clear()` e descartar a entrada inválida.
- **Cuidado em C++:** `cout << unsigned char` e `cout << char` podem imprimir caracteres, não códigos numéricos. Faça `static_cast<int>(caractere)` se deseja o valor numérico.

## 5. O que usar em maratonas?

| Cenário | Melhor escolha usual |
| --- | --- |
| Números, palavras, pares, matrizes | `cin` / `cout` |
| Leitura até EOF | `while (cin >> ...)` |
| Ler linhas com espaços | `getline` com `std::string` |
| Imprimir `n` casas decimais | `fixed << setprecision(n)` |
| Alinhamento em colunas | `setw`, `left`, `right`, `setfill` |
| Números em base hexadecimal | `hex` e depois `dec` |
| Construir uma saída como texto | `ostringstream` |
| Analisar vários campos de uma string | `istringstream` |
| Protocolo de entrada dependente de scanset/width de C | `scanf` ou parser específico |
| Interação com juiz que exige resposta imediata | `cout << flush` |
| Formato `printf` muito complexo em C++11 | `printf` continua sendo válido em C++11 |

**Recomendação:** prefira `cin`/`cout` para novos problemas C++11, com `sync_with_stdio(false)` e `cin.tie(nullptr)` nas entradas tradicionais. Aprenda os formatos C para poder ler soluções existentes e lidar com protocolos específicos, mas mantenha cada programa consistente na família de I/O utilizada.

## 6. Referências

- [cppreference — Input/output library](https://en.cppreference.com/w/cpp/io)
- [cppreference — Input/output manipulators](https://en.cppreference.com/w/cpp/io/manip)
- [cppreference — `std::fixed`, `std::scientific`, `std::hexfloat`, `std::defaultfloat`](https://en.cppreference.com/w/cpp/io/manip/fixed)
- [cppreference — `std::ios_base::sync_with_stdio`](https://en.cppreference.com/w/cpp/io/ios_base/sync_with_stdio)
- [cppreference — `std::format` (C++20)](https://en.cppreference.com/w/cpp/utility/format/format)
- [cppreference — `std::print` (C++23)](https://en.cppreference.com/w/cpp/io/print)
