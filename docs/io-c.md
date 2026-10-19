# Entrada e saída com a biblioteca C em programas C++11

Este guia cobre o uso de `scanf`, `printf`, `getchar`, `putchar`, `fgets` e operações auxiliares em soluções de maratona compiladas como **C++11**.

**Resumo:** é permitido utilizar I/O da biblioteca C em um programa C++. Inclua `<cstdio>` (e, quando necessário, `<cstring>`, `<cctype>` ou `<cstdlib>`). Isso **não impede** usar estruturas de dados e algoritmos da STL, como `std::vector`, `std::sort`, `std::queue` e `std::map`.

Veja também: [equivalências e limitações no I/O de C++11](io-cpp11.md).

## 1. Exemplo executável: entrada até EOF

Equivalente ao teste de soma em `../main.cpp`:

```cpp
#include <cstdio>

int main()
{
    int primeiroNumero, segundoNumero;

    while (std::scanf("%d %d", &primeiroNumero, &segundoNumero) == 2)
    {
        std::printf("%d\n", primeiroNumero + segundoNumero);
    }

    return 0;
}
```

Entrada (`stdin`):

```text
1 2
10 20
-8 3
```

Saída (`stdout`):

```text
3
30
-5
```

Não utilize `freopen("stdin", ...)` nem `freopen("stdout", ...)` no código submetido. O Makefile faz o redirecionamento durante a execução local; o juiz fornece os streams padrão.

## 2. Especificadores de formato mais utilizados

| Tipo em C++11 | Em `scanf` | Em `printf` | Atenção |
| --- | --- | --- | --- |
| `int` | `%d` | `%d` | Inteiro decimal com sinal. |
| `unsigned int` | `%u` | `%u` | Sem sinal. |
| `long` | `%ld` | `%ld` | Tamanho depende da plataforma. |
| `long long` | `%lld` | `%lld` | Inteiros grandes. |
| `unsigned long long` | `%llu` | `%llu` | Inteiros grandes sem sinal. |
| `std::size_t` | `%zu` | `%zu` | Contagens e índices; `#include <cstddef>`. |
| `float` | `%f` | `%f` | `float` é promovido a `double` em `printf`. |
| `double` | `%lf` | `%f` | **Não confundir:** leitura e escrita são diferentes. |
| `long double` | `%Lf` | `%Lf` | `L` maiúsculo. |
| `char` | `%c` | `%c` | `%c` não ignora espaços na entrada. |
| `char[]` (palavra) | `%Ns` | `%s` | `N` precisa respeitar o espaço disponível para `'\0'`. |
| Inteiro em hexadecimal | `%x` | `%x` / `%X` | Preferir um tipo inteiro sem sinal no destino de `%x`. |
| Inteiro em octal | `%o` | `%o` | Representação octal. |
| Percentual literal | `%%` | `%%` | Imprime/consome o caractere `%`. |

Para o especificador `%x` de `scanf`, utilize uma variável `unsigned int`; `%llx` requer `unsigned long long`. Use sempre o especificador correspondente ao tipo real.

### Endereços e tipos

As conversões de `scanf` precisam do **endereço** de variáveis numéricas:

```cpp
int numero = 0;
double preco = 0.0;

std::scanf("%d %lf", &numero, &preco);
std::printf("%d %.2f\n", numero, preco);
```

Usar `std::scanf("%d", numero)` sem `&` é **comportamento indefinido**. Em contrapartida, para arrays de caracteres usa-se o nome do array (conversão automática para ponteiro):

```cpp
char palavra[100];
std::scanf("%99s", palavra); // Até 99 caracteres + terminador '\0'
```

Especificadores incorretos podem provocar comportamento indefinido, especialmente porque estas funções recebem argumentos variádicos sem a verificação de tipos oferecida por `cin`/`cout`. No caso de `printf`, tipos menores sofrem promoções usuais; por exemplo, `float` vira `double`.

## 3. Verifique o retorno de `scanf`

O retorno é o **número de atribuições realizadas com sucesso**. `EOF` indica falha de entrada antes da primeira conversão ou atribuição.

```cpp
int a, b;

// Dois inteiros necessários: compare com 2.
while (std::scanf("%d %d", &a, &b) == 2)
{
    std::printf("%d\n", a + b);
}
```

Evite `while (scanf("%d %d", &a, &b) != EOF)`. Se houver um caractere inválido no começo do próximo campo, `scanf` pode retornar `0` sem consumi-lo, fazendo a repetição continuar indefinidamente.

Outros protocolos de problemas:

```cpp
int casos;
if (std::scanf("%d", &casos) != 1) return 0;
// Em seguida, processe exatamente 'casos' instâncias.
```

Em problemas com sentinela, verifique o valor exigido pelo enunciado **depois** da leitura bem-sucedida.

## 4. Formatação de `printf`

| Formato C | Exemplo | Significado |
| --- | --- | --- |
| `%d` | `printf("%d", 42)` | Inteiro decimal. |
| `%08d` | `printf("%08d", 42)` | Largura mínima 8, completa com zeros à esquerda. |
| `%-8d` | `printf("%-8d", 42)` | Largura mínima 8, alinhado à esquerda. |
| `%+d` | `printf("%+d", 42)` | Exibe sinal `+` para positivo. |
| `%.2f` | `printf("%.2f", 3.14159)` | Duas casas decimais, formato fixo. |
| `%8.2f` | `printf("%8.2f", 3.14159)` | Duas casas decimais, largura mínima 8. |
| `%.3e` | `printf("%.3e", 123.0)` | Notação científica. |
| `%.6g` | `printf("%.6g", 123.0)` | Até 6 algarismos significativos (forma geral). |
| `%x` / `%X` | `printf("%X", 255u)` | Hexadecimal minúsculo/maiúsculo. |
| `%#x` | `printf("%#x", 255u)` | Hexadecimal com prefixo `0x`. |
| `%.4s` | `printf("%.4s", "abcdef")` | Imprime no máximo quatro caracteres. |
| `%%` | `printf("50%%")` | Imprime `50%`. |

A largura em `printf` é geralmente **mínima** (não trunca números longos); a precisão tem significado diferente para números de ponto flutuante e strings.

## 5. Leitura de palavras, linhas e caracteres

### Palavra sem espaços

```cpp
char nome[100];
if (std::scanf("%99s", nome) == 1)
{
    std::printf("%s\n", nome);
}
```

`%s` **não** lê espaços e, se não receber limite de largura, pode ultrapassar o array. Para strings de tamanho desconhecido, `std::string` com `std::cin` é frequentemente mais seguro.

### Linha inteira, incluindo espaços

```cpp
#include <cstdio>

int main()
{
    char linha[256];

    while (std::fgets(linha, sizeof(linha), stdin) != nullptr)
    {
        std::printf("%s", linha);
    }

    return 0;
}
```

`fgets` lê até uma quebra de linha ou até preencher o buffer (reservando o terminador `'\0'`). A quebra de linha é mantida quando couber. Uma linha maior que o buffer exige múltiplas leituras.

### `%c`, `getchar` e espaços

```cpp
char letra;
std::scanf("%c", &letra);   // Lê inclusive '\n', espaço e tabulação.
std::scanf(" %c", &letra);  // Ignora espaços anteriores.
```

`std::getchar()` retorna `int`, não `char`, para poder representar `EOF`:

```cpp
int caractere;
while ((caractere = std::getchar()) != EOF)
{
    std::putchar(caractere);
}
```

### `scanf` com largura e supressão

```cpp
int numero;
// %3d consome no máximo 3 caracteres deste campo numérico.
std::scanf("%3d", &numero);

// Descarta um inteiro e captura o próximo.
int importante;
std::scanf("%*d %d", &importante);

// Lê somente letras minúsculas de uma sequência; no máximo 9 caracteres.
char letras[10];
std::scanf("%9[a-z]", letras);
```

Conjuntos `%[...]` e supressão `%*` fazem parte da linguagem de formatos do `scanf`. Em `cin` não existe um operador idêntico para todos esses casos; veja o [comparativo detalhado](io-cpp11.md).

## 6. `sscanf` e `snprintf`: conversão em memória

```cpp
#include <cstdio>

int main()
{
    int codigo;
    double valor;
    if (std::sscanf("123 4.50", "%d %lf", &codigo, &valor) != 2)
    {
        return 1;
    }

    char destino[64];
    std::snprintf(destino, sizeof(destino), "%04d: %.2f", codigo, valor);
    std::printf("%s\n", destino); // 0123: 4.50
}
```

`snprintf` limita o número de bytes gravados no buffer e devolve a quantidade de caracteres que **seriam** escritos (sem contar o terminador), possibilitando detectar truncamento. Não há motivo para usar `sprintf` sem controle de tamanho quando `snprintf` está disponível.

## 7. Misturar I/O de C e C++

**Pode usar STL com `scanf`/`printf` sem restrição:**

```cpp
#include <cstdio>
#include <vector>
#include <algorithm>

int main()
{
    int quantidade;
    if (std::scanf("%d", &quantidade) != 1 || quantidade < 0)
    {
        return 0;
    }

    std::vector<int> valores(quantidade);
    for (int indice = 0; indice < quantidade; indice++)
    {
        if (std::scanf("%d", &valores[indice]) != 1)
        {
            return 0;
        }
    }

    std::sort(valores.begin(), valores.end());
    for (int valor : valores)
    {
        std::printf("%d\n", valor);
    }
}
```

O cuidado é **não misturar as famílias de streams** depois de desligar a sincronização:

```cpp
std::ios::sync_with_stdio(false);

// Evite combinar operações sobre stdin/stdout com
// std::cin/std::cout e std::scanf/std::printf na mesma execução.
```

- Por padrão, os streams padrão de C++ e C são sincronizados, de modo que podem ser misturados, com o custo correspondente.
- Com `std::ios::sync_with_stdio(false)`, eles podem usar buffers independentes, trazendo comportamento inesperado na ordem de leitura e escrita.
- Mesmo com sincronização ativa, misturar interfaces raramente traz vantagem. **Escolha uma família por programa**.
- Não chame `sync_with_stdio` depois de ter começado operações de I/O: o efeito é definido pela implementação.
- Se usar apenas I/O de C, **não precisa** de `ios::sync_with_stdio(false)` ou `cin.tie(nullptr)`.
- `printf` também é bufferizado; em problema **interativo**, use `std::fflush(stdout)` quando o juiz precisar receber uma mensagem antes da próxima leitura.

## 8. I/O de C ou C++ na maratona?

- **Escolha `cin`/`cout`** para leitura tipada, `std::string`, linhas inteiras e manipulação consistente com a STL.
- **Escolha `scanf`/`printf`** se preferir formatos `%...`, estiver confortável com ponteiros/especificadores ou precisar dessas regras específicas.
- Em qualquer caso, valide a entrada e teste os tempos com dados grandes quando desempenho for decisivo.
- Ambos funcionam em C++11 sem bibliotecas externas.

## Referências técnicas

- [cppreference — `scanf`, `fscanf`, `sscanf`](https://en.cppreference.com/w/cpp/io/c/scanf)
- [cppreference — `printf`, `fprintf`, `sprintf`](https://en.cppreference.com/w/cpp/io/c/printf)
- [cppreference — `std::ios_base::sync_with_stdio`](https://en.cppreference.com/w/cpp/io/ios_base/sync_with_stdio)
