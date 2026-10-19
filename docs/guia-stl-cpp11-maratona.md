# Guia técnico de C++11 para maratonas: biblioteca padrão, memória e estruturas compostas

> Escopo: C++11 estrito (`-std=c++11`), preferencialmente GCC/libstdc++ e `#include <bits/stdc++.h>` com `using namespace std;`. Explica ferramentas reutilizáveis, **não resolve os exercícios dos cadernos**. A identificação de padrões está em [Mapa dos cadernos](mapa-cadernos-estruturas.md). Consulte o [glossário bilíngue PT-BR / inglês](glossario-algoritmos-ptbr-en.md) para pesquisar as técnicas pelos dois nomes.

## 1. O que significa "built-in" em C++?

Há três níveis diferentes que não devem ser confundidos:

1. **Recursos da linguagem (built-in)**: `int`, `long long`, `double`, `bool`, `char`, arrays nativos `T[N]`, ponteiros, referências, `struct`, `enum`, `const`, operadores, templates e lambdas.
2. **Biblioteca padrão do C++11 (STL e adjacentes)**: `vector`, `map`, `set`, `queue`, `priority_queue`, `string`, `bitset`, `array`, algoritmos de `<algorithm>`, utilitários de `<numeric>`, `<memory>`, `<random>` etc. Estão disponíveis com implementações conformes C++11.
3. **Extensões GNU, não padronizadas**: `<bits/stdc++.h>`, `__gnu_pbds::tree`, `__builtin_popcount`, `__int128`, arrays de tamanho variável na pilha (VLA). Algumas podem funcionar no GCC, mas **não devem ser presumidas** se a prova exige apenas C++11.

`bits/stdc++.h` agrega cabeçalhos padrão no libstdc++; não adiciona novos recursos de linguagem nem instala bibliotecas. `using namespace std;` apenas influencia a busca de nomes; não é um include.

Template de competição (somente se o compilador tiver `bits/stdc++.h`):

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    // Leia até EOF, por sentinela ou por T casos conforme o enunciado.
}
```

Quando portabilidade importa, use includes individuais. O BOCA é configurável: teste a versão **efetiva do juiz**, não apenas o GCC local. No `boca-docker` testado anteriormente, `bits/stdc++.h` compilou com GCC 11.4.0.

## 2. Inventário das estruturas prontas do C++11

Complexidades em função do número de elementos `n`. Quando indicado O(1) para hash, trata-se de **média esperada**, com pior caso O(n).

### 2.1. Containers sequenciais

| Estrutura | Modelo | Acesso | Inserir / remover | Quando pensar nela |
| --- | --- | --- | --- | --- |
| `T dados[N]` (array nativo) | Bloco fixo contíguo | Índice O(1) | Tamanho fixo | Grade pequena conhecida em compilação, interoperabilidade com C |
| `array<T,N>` | Array fixo, objeto da STL | Índice O(1) | Tamanho fixo | Estado de dimensão fixa, ordenação com iteradores |
| `vector<T>` | Array dinâmico contíguo | Índice O(1) | `push_back` O(1) amortizado; inserir no meio O(n) | **Padrão principal** para listas, grades, adjacência e programação dinâmica (Dynamic Programming — DP) |
| `deque<T>` | Sequência segmentada, duas pontas | Índice O(1) | Início/fim O(1) amortizado | Janela deslizante (Sliding Window), fila dupla monotônica (Monotonic Deque), busca em largura 0–1 (0–1 BFS) |
| `list<T>` | Lista duplamente encadeada | Percurso O(n) | Inserção/remoção com iterador O(1) | Mover nós via `splice`, iteradores estáveis |
| `forward_list<T>` | Lista simplesmente encadeada (C++11) | Percurso O(n) | `insert_after`/`erase_after` O(1) | Lista encadeada enxuta, quando realmente necessária |

**Cuidados:** `list` e `forward_list` não suportam `operator[]` nem `std::sort` (use seus métodos `.sort()`). No C++11, `forward_list` nem sequer possui `.size()`. `vector<bool>` é uma especialização compacta de bits, com referências proxy, não um `vector` normal de `bool`.

### 2.2. Containers associativos ordenados

| Estrutura | Ordem / duplicatas | Inserir, encontrar, remover | Operação especialmente útil |
| --- | --- | --- | --- |
| `set<T>` | Chaves únicas e ordenadas | O(log n) | `lower_bound` / `upper_bound` |
| `multiset<T>` | Chaves ordenadas com repetição | O(log n) | Manter muitos valores ordenados dinamicamente |
| `map<K,V>` | Pares de chave única, ordenados por chave | O(log n) | Associar chave a registro/contagem |
| `multimap<K,V>` | Pares ordenados, permite chaves repetidas | O(log n) | Várias ocorrências por chave |

`set` e as **chaves** de `map` são tratadas como imutáveis **enquanto armazenadas**: mudar chave quebraria a ordenação. Em `map<K,V>`, `it->first` é `const K`, porém `it->second` é mutável. `map[chave]` **insere** um valor padrão se a chave não existir; para só consultar, prefira `find`.

```cpp
set<int> valores = {5, 2, 5, 9};  // {2,5,9}
auto candidato = valores.lower_bound(4); // Aponta para 5.
map<string, int> frequencia;
++frequencia["azul"];             // Insere se necessário.
auto encontrado = frequencia.find("verde"); // Sem inserir.
```

Para `multiset`, `erase(valor)` elimina **todas** as ocorrências daquele valor; `erase(find(valor))` elimina **uma**, desde que a busca encontre o elemento.

### 2.3. Associativos por hash (novos no C++11)

| Estrutura | Duplicatas | Pesquisa/inserção média | Observação |
| --- | --- | --- | --- |
| `unordered_set<T>` | Não | O(1) | Sem ordem de iteração |
| `unordered_multiset<T>` | Sim | O(1) | Repetições agrupadas em buckets |
| `unordered_map<K,V>` | Chaves únicas | O(1) | Frequências, índices rápidos |
| `unordered_multimap<K,V>` | Chaves repetidas | O(1) | Multimap sem ordenação |

Pior caso O(n). `unordered_map` não suporta `lower_bound` e **não garante** ordem. `rehash` invalida iteradores, mas não referências aos elementos. Para chaves personalizadas e certas combinações (por exemplo `pair<int,int>`), implemente um hash; **não assuma** `std::hash<pair<...>>` no C++11.

### 2.4. Adaptadores: interfaces sobre outros containers

| Adaptador | Interface | Operações usuais |
| --- | --- | --- |
| `stack<T>` | Pilha LIFO | `push`, `pop`, `top`, `empty` |
| `queue<T>` | Fila FIFO | `push`, `pop`, `front`, `back` |
| `priority_queue<T>` | Montículo (Heap), maior no topo por padrão | `push` O(log n), `top` O(1), `pop` O(log n) |

**Cuidado:** `pop()` nesses adaptadores não retorna o elemento removido. Consulte `top()`/`front()` **antes** de remover. Para mínimo primeiro:

```cpp
priority_queue<int, vector<int>, greater<int>> menores;
menores.push(8);
menores.push(3);
cout << menores.top() << '\n'; // 3
```

### 2.5. Outros tipos e ferramentas predefinidos

- `string`: texto em sequência de `char`, `size`, `substr`, `find`, `replace`, `erase`, `insert`, concatenação; acesso O(1), busca de substring em geral não O(1).
- `bitset<N>`: conjunto de bits de **tamanho conhecido na compilação**; `set`, `reset`, `flip`, `test`, `count`; útil para máscaras e estados.
- `vector<bool>`: bits de comprimento dinâmico, mas a especialização possui semântica diferente de referências reais. Se precisar de ponteiros para elementos, use `vector<char>` ou `vector<uint8_t>`.
- `pair<A,B>`, `tuple<A,...>`: pequenos registros; ordenação/comparação lexicográfica disponível para tipos comparáveis.
- `struct` / `class`: registros com nomes expressivos e invariantes; úteis para `Ponto`, `Aresta`, `Intervalo`, `Estado`.
- `valarray<T>`: operações numéricas elemento a elemento; existe no padrão, porém é pouco usado em maratonas.
- `complex<T>`: complexos; pode ajudar em geometria e matemática.
- `reference_wrapper<T>`, `unique_ptr<T>`, `shared_ptr<T>`: referências armazenáveis em containers e gerenciamento de propriedade/memória.
- `function<Assinatura>`: armazena funções/lambdas com custo de abstração; para busca em profundidade (Depth-First Search — DFS) recursiva, compare com uma função nomeada.
- `chrono` e `random`: medição local e geradores de pseudoaleatoriedade (`mt19937`, `uniform_int_distribution`) — nunca basear correção de problemas determinísticos só em sorteio.

## 3. Como escolher rapidamente a estrutura

| Exigência | Primeira opção | Alternativa / observação |
| --- | --- | --- |
| Ler e percorrer N inteiros | `vector<int>` | `array` se N for constante de compilação |
| Guardar uma matriz de linhas/colunas | `vector<vector<int>>` | Um `vector<int>` linearizado reduz alocações |
| Manter valores distintos, **ordenados** | `set` | `vector + sort + unique` se dados forem estáticos |
| Testar presença rapidamente, sem ordem | `unordered_set` | `set` com O(log n) garantido |
| Contar frequências | `unordered_map<T,int>` | `vector<int>` quando as chaves têm domínio pequeno |
| Buscar próximo valor maior/menor ordenado | `set`, `multiset`, ou `lower_bound` em `vector` ordenado | `lower_bound` em vetor: O(log n); inserir: O(n) |
| Manter o menor valor disponível dinamicamente | `priority_queue<T,vector<T>,greater<T>>` | `multiset` quando precisar remover elementos arbitrários |
| Comandos desfazer/refazer | `stack` ou `vector` | `vector` permite percorrer elementos |
| Processar em ordem de chegada | `queue` | `deque` se precisar de duas pontas |
| Consultas repetidas de intervalo estático | Prefixos e `vector<long long>` | Tabela esparsa (Sparse Table) para mínimos/máximos idempotentes |
| Consultas de intervalo com atualizações | Árvore de Fenwick (Fenwick Tree) / árvore de segmentos (Segment Tree), não prontas | `vector` interno |
| Dependências e redes | Lista de adjacência | `vector<vector<int>>` |
| Palavras com prefixos | Árvore de prefixos (Trie), não pronta | Nós em `vector`, ou `map` por nó |
| Conectividade sob união | Conjuntos disjuntos (Disjoint Set Union — DSU), não pronta | `vector<int> parent, size` |

> **Regra de eficiência:** se você lê tudo e só depois consulta, um `vector` **ordenado uma vez** costuma ser preferível a alimentar `set` continuamente. Se há inserções/remoções entre consultas, associe o padrão de operações ao container.

## 4. Algoritmos já prontos (não são containers)

A maior parte dos utilitários seguintes está em `<algorithm>`; o atalho `bits/stdc++.h` permite utilizá-los sem cada include individual.

### Ordenação, seleção e busca

| Função | Característica | Complexidade típica / requisito |
| --- | --- | --- |
| `sort(first,last)` | Ordena crescente ou com comparador | O(n log n) em comparações; exige iterador de acesso aleatório |
| `stable_sort` | Preserva ordem relativa dos equivalentes | O(n log n) com memória auxiliar suficiente |
| `partial_sort(first,middle,last)` | Deixa menores K classificados no começo | O(n log K) |
| `nth_element(first,nth,last)` | Coloca o n-ésimo valor na posição de ordem | O(n) **médio** |
| `is_sorted` / `is_sorted_until` | Verifica ordem | O(n) |
| `reverse`, `rotate` | Inversão/rotação | O(n) |
| `min_element`, `max_element`, `minmax_element` | Extremos | O(n) |
| `lower_bound` / `upper_bound` | Primeiro `>= x` / primeiro `> x` | O(log n) comparações com intervalo ordenado; em iteradores sem acesso aleatório, deslocamento pode ser O(n) |
| `binary_search` / `equal_range` | Existência e faixa de equivalência | Intervalo ordenado |
| `next_permutation`, `prev_permutation` | Permutação lexicográfica | O(n) por transição |
| `make_heap`, `push_heap`, `pop_heap`, `sort_heap` | Montículo (Heap) em intervalo de `vector` | O(n), O(log n), O(log n), O(n log n) |
| `shuffle` | Permutação pseudoaleatória com gerador | C++11 (`<random>`) |

Para ordenar de forma decrescente:

```cpp
vector<int> numeros = {4, 8, 2};
sort(numeros.begin(), numeros.end(), greater<int>());
```

Para ordenar registros com dois critérios:

```cpp
struct Item { int prioridade; string nome; };
vector<Item> itens = {{3, "B"}, {5, "A"}, {3, "A"}};
sort(itens.begin(), itens.end(), [](const Item& a, const Item& b) {
    if (a.prioridade != b.prioridade)
        return a.prioridade > b.prioridade;
    return a.nome < b.nome;
});
```

Comparadores devem produzir **ordem estrita fraca**: não use `<=` em lugar de `<`.

### Remoção lógica, interseção e agregação

- `find`, `count`, `find_if`, `count_if`, `all_of`, `any_of`, `none_of` — filtros e predicados.
- `remove`, `remove_if`, `unique` — reorganizam o intervalo; em `vector`, use `erase` para remover de fato.
- `copy`, `copy_if`, `transform`, `fill`, `generate`, `replace`, `partition`, `stable_partition` — operações em intervalos.
- `merge`, `set_union`, `set_intersection`, `set_difference`, `set_symmetric_difference`, `includes` — **requerem entradas ordenadas**.
- `accumulate`, `partial_sum`, `adjacent_difference`, `inner_product`, `iota` — em `<numeric>`.

```cpp
vector<int> valores = {3, 1, 3, 2};
sort(valores.begin(), valores.end());
valores.erase(unique(valores.begin(), valores.end()), valores.end());

long long soma = accumulate(valores.begin(), valores.end(), 0LL);
// 0LL evita acumulação intermediária em int.
```

**Não confundir:** `std::remove` em `<algorithm>` **não** reduz o tamanho de um `vector`; já `list.remove` elimina nós diretamente. Nenhuma dessas funções deve ser usada sobre `set` como se fosse um vetor de elementos modificáveis.


## 5. Interoperabilidade entre containers e algoritmos

A STL usa **iteradores** para conectar containers a algoritmos:

- `begin()`, `end()` delimitam o intervalo semiaberto `[begin, end)`; `end()` não é um elemento válido para desreferenciar.
- `vector`, `array`, `deque`: acesso aleatório; `sort` e `nth_element` funcionam.
- `list`: iteradores bidirecionais, não têm `operator+`; use `.sort()`, `splice()`.
- `forward_list`: iteradores para frente, use `.sort()`, `splice_after()`.
- `set`/`map`: iteradores bidirecionais com chaves não mutáveis; `.lower_bound()` é preferível à versão algorítmica genérica.
- `unordered_*`: iteradores apenas para frente, sem ordenação; para ordenar, copie os elementos para `vector`.
- `stack`, `queue`, `priority_queue` não expõem iteradores; são interfaces intencionalmente restritas.

### 5.1. Conversões entre estruturas

```cpp
vector<int> valores = {3, 1, 3, 2};
set<int> unicos(valores.begin(), valores.end());
vector<int> ordenados(unicos.begin(), unicos.end()); // {1,2,3}

unordered_map<int, int> contagem;
for (int valor : valores) ++contagem[valor];

// Ordena contagens (frequência, valor), independentemente da ordem do hash.
vector<pair<int,int>> itens;
for (const auto& entrada : contagem)
    itens.push_back({entrada.second, entrada.first});
sort(itens.begin(), itens.end());
```

### 5.2. Interseção entre sequências e containers

```cpp
vector<int> a = {1, 2, 4};
vector<int> b = {2, 3, 4};
vector<int> intersecao;
set_intersection(a.begin(), a.end(), b.begin(), b.end(),
                 back_inserter(intersecao)); // {2,4}
```

`set_intersection` respeita **multiplicidades** de valores em sequências ordenadas. Se a semântica é "valores únicos", ordene/remova duplicações antes. O nome do algoritmo não obriga usar `std::set`.

### 5.3. Customização de hash em C++11

```cpp
struct ParHash {
    size_t operator()(const pair<int,int>& valor) const {
        size_t primeiro = hash<int>()(valor.first);
        size_t segundo = hash<int>()(valor.second);
        return primeiro ^ (segundo + 0x9e3779b9U + (primeiro << 6) + (primeiro >> 2));
    }
};

unordered_set<pair<int,int>, ParHash> coordenadas;
coordenadas.insert({10, 20});
```

A função de hash deve ser **consistente com igualdade**. O exemplo é apropriado para começar; o desempenho de hash e o risco de colisões dependem dos dados.

## 6. Leitura, saída e parsing em C++11

A escolha da estrutura depende do **protocolo da entrada**:

| Padrão de enunciado | Leitura C++11 |
| --- | --- |
| Inteiros até EOF | `while (cin >> x)` |
| Pares até EOF | `while (cin >> a >> b)` |
| Número de casos T | `int t; cin >> t; while (t--) {...}` |
| Sentinela `0 0` | `while (cin >> a >> b && (a != 0 || b != 0))` |
| Linha completa, inclusive espaços | `getline(cin, linha)` |
| Palavra até espaço | `cin >> palavra` |
| Ler tokens de uma linha | `istringstream fluxo(linha); while (fluxo >> x) {...}` |
| Caractere, inclusive espaços | `cin.get(c)` |
| Binário/hexadecimal em texto | `bitset<N>(texto)`, `stoi(texto, nullptr, base)` |
| Saída com duas casas | `cout << fixed << setprecision(2) << valor` |
| Inteiro com zeros à esquerda | `cout << setfill('0') << setw(4) << numero` |

Em soluções de maratona:

```cpp
ios::sync_with_stdio(false);
cin.tie(nullptr);
```

Não misture `cin`/`cout` com `scanf`/`printf` após desligar sincronização. Use `'\n'` no lugar de `endl` (que força flush). Para problemas **interativos** use `cout << flush` se necessário.

`getline` após `cin >>` exige cuidado com a quebra de linha pendente:

```cpp
int quantidade;
cin >> quantidade;
cin.ignore(numeric_limits<streamsize>::max(), '\n');
string descricao;
getline(cin, descricao);
```

Formatação feita por manipuladores é **estado persistente** (`fixed`, `setprecision`, `hex`, `setfill`) com exceções como `setw` (geralmente afeta a próxima operação). Restaure `dec`, `defaultfloat` etc. quando alterar o formato para valores posteriores.

A documentação aprofundada está em [I/O C++11](io-cpp11.md) e [I/O C](io-c.md).

## 7. Conversões, representações e matemática

| Necessidade | Ferramenta em C++11 | Cuidados |
| --- | --- | --- |
| `string` → `int` | `stoi(texto)` | Pode lançar `invalid_argument` / `out_of_range` |
| `string` → `long long` | `stoll(texto)` | Idem |
| `string` → `double` | `stod(texto)` | Localidade e precisão |
| `int` / `long long` → `string` | `to_string(valor)` | Conversão decimal |
| Binário textual → número | `stoll(texto, nullptr, 2)` | Estouro possível |
| Dígito ASCII `char` → inteiro | `digito - '0'` | Valide `'0' <= digito <= '9'` |
| Inteiro → dígito ASCII | `char('0' + valor)` | Somente `0..9` |
| Caixa de letras | `tolower`, `toupper` | Use `unsigned char` para valores negativos de `char` |
| Classificar caractere | `isdigit`, `isalpha` | Mesma cautela |
| Raiz, potência, arredondamento | `sqrt`, `pow`, `floor`, `ceil`, `round` | `pow` opera em ponto flutuante; cuidado com igualdade exata |
| Contar bits ligados | `bitset<N>::count()` | `__builtin_popcount` é **extensão GCC** |
| Limites de tipo | `numeric_limits<T>::max()`, `LLONG_MAX` | Evite somar a INF sem conferir overflow |
| MDC | Algoritmo de Euclides próprio ou `__gcd` GCC | `std::gcd` é C++17, não padrão C++11 |

Exemplo de precisão de inteiros: `long long produto = 1LL * a * b;` promove **antes** de multiplicar; `long long produto = a * b;` pode fazer overflow em `int` antes da atribuição.

`pow(10, k)` **não** é uma solução geral para potência inteira exata; use multiplicação inteira com verificações de estouro, quando adequado.

### Pares e tuplas como coordenadas / estados

```cpp
pair<int,int> ponto = {3, 7};
tuple<int,int,int> estado = make_tuple(1, 4, 9);
cout << ponto.first << ' ' << get<2>(estado) << '\n';
```

Pares e tuplas têm ordenação lexicográfica apropriada quando seus componentes são comparáveis, facilitando `sort`, `set` e `priority_queue`.

## 8. Mutabilidade, cópia, referência e memória

### 8.1. Modelo mental

- `int x = 5;`: variável/objeto com valor.
- `int& referencia = x;`: outro nome para o **mesmo** objeto; alterar a referência altera `x`.
- `const int& leitura = x;`: referência através da qual você não pode modificar `x`, **mas o objeto original ainda pode ser modificado por outra referência**.
- `const int fixo = 5;`: este objeto não pode ser modificado por interfaces regulares.
- `int* p = &x;`: ponteiro, pode ser nulo e pode apontar para outro objeto; `*p` acessa o destino.
- `const int* p`: não modifica o valor por `p`; `int* const p`: não permite trocar o endereço armazenado por `p`.
- `std::move(x)`: **conversão para rvalue**, não move por si; o move acontece caso uma operação compatível seja escolhida.

O padrão **não** garante que variáveis locais sempre estejam fisicamente na pilha ou que cada container esteja no heap; essas são características comuns das implementações. `vector` armazena seus elementos em memória contígua gerenciada pelo container, tipicamente obtida por alocação dinâmica.

### 8.2. Passagem por valor, referência e referência constante

```cpp
void porValor(vector<int> copia) {
    copia.push_back(99);  // Só muda a cópia; custo de cópia O(n).
}
void porReferencia(vector<int>& original) {
    original.push_back(99); // Muda o original.
}
long long soma(const vector<int>& dados) {
    return accumulate(dados.begin(), dados.end(), 0LL); // Sem copiar.
}

int main() {
    vector<int> numeros = {1, 2, 3};
    porValor(numeros);       // numeros continua com 3 elementos.
    porReferencia(numeros);  // numeros passa a ter 4 elementos.
    cout << soma(numeros) << '\n';
}
```

**Preferência prática:** escalares pequenos (`int`, `double`, alguns `pair`) geralmente por valor; containers grandes lidos sem mutação por `const T&`; containers a modificar por `T&`; retornos por valor quando o algoritmo precisa produzir um novo objeto (otimizações de cópia e move ajudam).

### 8.3. Cópia versus move em containers

```cpp
vector<int> original = {1, 2, 3};
vector<int> copia = original;             // Vetor independente (copia elementos).
vector<int> transferido = move(original); // Move recursos se possível.
```

Depois do move, o `original` permanece **válido**, mas o conteúdo é em geral **não especificado**. Não assuma que ele estará vazio sem estabelecer explicitamente o estado.

`unique_ptr<T>` representa propriedade exclusiva e **não pode ser copiado**; pode ser movido. `shared_ptr<T>` compartilha propriedade por contagem de referências. Para grafos, árvores e heaps de maratona, índices em `vector` normalmente são mais simples e previsíveis que ponteiros dinâmicos.

### 8.4. Invalidação de referência, ponteiros e iteradores

O principal risco em problemas de maratona não é "imutabilidade total", mas **usar um iterador ou ponteiro invalidado** por mudança estrutural.

| Container | Após inserção | Após remoção |
| --- | --- | --- |
| `vector` | Reallocação invalida **todos** os ponteiros/referências/iteradores; sem realocação, elementos a partir do ponto inserido podem ser invalidados | Elementos removidos e posições seguintes (incluindo `end()`) invalidados |
| `deque` | Iteradores geralmente invalidados; referências a elementos sobreviventes nas duas pontas permanecem válidas | Regras variam com remoção em pontas ou meio |
| `list`, `forward_list` | Outros nós/iteradores permanecem válidos | Apenas elementos removidos são invalidados |
| `set`, `map` | Iteradores e referências existentes permanecem válidos | Apenas o elemento removido é invalidado |
| `unordered_*` | `rehash` invalida iteradores (referências a elementos preservadas) | Elemento removido invalidado |

```cpp
vector<int> v = {10, 20};
v.reserve(100);
int& primeiro = v[0];
v.push_back(30);  // Com a capacidade reservada, não há realocação aqui.
cout << primeiro;  // Referência continua válida nesta operação.
```

Atenção: `reserve` **não** altera `size()`; não faça `v[5] = ...` até criar esses elementos com `resize`, `push_back` etc. Quando a capacidade esgotar, uma nova realocação poderá invalidar referências.

Não use `v.front()`, `v.back()`, `pq.top()`, `*v.begin()`, `*it` se o objeto/iterador estiver vazio ou apontar para `end()`. Acesso `v[i]` também não checa limites; `v.at(i)` verifica e pode lançar exceção.

### 8.5. Memória, lifetime e alocações

- Prefira `vector` a `new[]`/`delete[]`: o container administra o lifetime dos elementos (RAII).
- `vector<vector<int>>` armazena cada linha separadamente; se o problema for grande, um `vector<int> grade(linhas*colunas)` com acesso `grade[r*colunas+c]` pode ser mais eficiente.
- Recursão muito profunda (por exemplo, 200.000 vértices em cadeia) pode estourar a pilha no juiz. Considere busca em profundidade (Depth-First Search — DFS) **iterativa** com `vector<int>` ou `stack<int>`.
- Em `map` e `set`, cada nó tem overhead além do valor. Em grandes instâncias, `vector` + ordenação pode consumir menos memória e ser mais rápido na prática.
- `swap(a,b)` troca estados; `std::move` pode evitar cópias de buffers; cópia de `vector` duplica os elementos.
- Não devolva referência ou ponteiro para variável local que deixa de existir.
- No C++11, `emplace_back(args...)` constrói elemento no container; não é automaticamente mais eficiente que `push_back` em todos os casos.

## 9. Heurísticas de complexidade e escolha

Para `n=100.000`, ordenar é frequentemente viável; executar `O(n²)` (10 bilhões de operações) tende a ser proibitivo. Esses limites são heurísticos, dependem do hardware e dos limites de tempo do BOCA.

| Restrição / padrão | Complexidades candidatas |
| --- | --- |
| `n <= 20` | Busca com retrocesso (Backtracking), máscara de bits (Bitmask), `O(2^n)` com avaliação de custo |
| `n <= 100` | `O(n^3)` em cenários simples |
| `n <= 1.000` | `O(n²)` muitas vezes cabe |
| `n <= 100.000` | `O(n log n)` ou `O(n)` |
| Consultas estáticas numerosas | Pré-processar para reduzir custo por consulta |
| Consultas e atualizações intercaladas | Árvore de Fenwick (Fenwick Tree), árvore de segmentos (Segment Tree), mapas ordenados |

**Verifique sempre:** pior caso; formato de input; limites de valores; número de casos; necessidade de ordenação; estabilidade; desempate; ordem da saída; duplicatas; validade de índices; estouro de inteiros.


## 10. Como combinar a STL para criar estruturas que não existem prontas

Os exemplos abaixo demonstram **estruturas genéricas reutilizáveis**, sem interpretar nem implementar a solução de qualquer exercício dos cadernos.

### 10.1. Grafo por lista de adjacência

O C++11 **não** possui uma classe de grafo na biblioteca padrão. A composição mais habitual é:

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Aresta {
    int destino;
    long long peso;
};

int main() {
    int vertices = 5;
    vector<vector<Aresta>> grafo(vertices);
    grafo[0].push_back({1, 8});
    grafo[0].push_back({3, 2});

    for (const Aresta& aresta : grafo[0])
        cout << aresta.destino << " : " << aresta.peso << '\n';
}
```

- **Não direcionado:** para cada aresta `u-v`, insira nas duas adjacências.
- **Direcionado:** insira somente de `u` para `v`.
- **Ponderado:** armazene peso junto ao destino (`pair<int,long long>` ou `struct`).
- **Grafo sem pesos:** `vector<vector<int>>`.
- **Matriz de adjacência:** `vector<vector<bool>>` ou `vector<vector<char>>` usa O(V²) espaço; útil em instâncias pequenas/densas.
- **Busca em largura (Breadth-First Search — BFS):** uma `queue<int>` sobre a lista de adjacência; O(V+E).
- **Busca em profundidade (Depth-First Search — DFS):** pilha/recursão; O(V+E).
- **Algoritmo de Dijkstra (Dijkstra's Algorithm):** `priority_queue<pair<long long,int>, vector<pair<long long,int>>, greater<pair<long long,int>>>` com distâncias; exige pesos não negativos.
- **Componentes fortemente conexas (Strongly Connected Components — SCC):** busca em profundidade (Depth-First Search — DFS) sobre grafo e transposto; algoritmo de Kosaraju (Kosaraju's Algorithm) ou algoritmo de Tarjan (Tarjan's Algorithm); não há implementação STL pronta.
- **Pontes/articulações:** busca em profundidade (Depth-First Search — DFS) com tempos de entrada e valores `low`; não há estrutura pronta.

### 10.2. Árvore: também é grafo, mas sem ciclos

Para uma árvore não direcionada com N vértices: `vector<vector<int>> adjacentes(n)` e N−1 arestas. Use `parent`, `depth`, `order` armazenados em `vector<int>`. Para evitar recursão profunda, faça travessia iterativa.

Se precisar de representação explícita de uma **árvore binária com índice de filhos**:

```cpp
struct No {
    int valor;
    int esquerdo;
    int direito;

    explicit No(int valorInicial)
        : valor(valorInicial), esquerdo(-1), direito(-1) {}
};

vector<No> nos;
nos.emplace_back(10);
nos.emplace_back(5);
nos[0].esquerdo = 1;
```

Isso armazena nós em memória contígua, e os **índices** continuam representando elementos mesmo quando o vetor é realocado (diferentemente de ponteiros para elementos internos). Atenção a mudanças de ordem do vetor: `erase` no meio altera índices.

**Árvores de busca balanceadas ordenadas:** `set` e `map` já resolvem muitos requisitos (inserir/remover/localizar chaves e vizinhos em O(log n)). A biblioteca padrão **não expõe** o tipo específico da árvore interna nem seus filhos, altura, rotações ou o k-ésimo menor elemento por índice.

**Árvore de prefixos (Trie), árvore de segmentos (Segment Tree), árvore de Fenwick (Fenwick Tree), ancestral comum mais baixo (Lowest Common Ancestor — LCA), árvore binária de nós arbitrários:** precisam ser montadas conforme a necessidade.

### 10.3. Conjuntos disjuntos (Disjoint Set Union — DSU / Union-Find)

Não existe uma classe de conjuntos disjuntos (DSU / Union-Find) padrão; costuma combinar dois `vector<int>` com união por tamanho e compressão de caminho. Serve para **componentes que se unem**, mas não para remoções arbitrárias de arestas.

```cpp
struct DSU {
    vector<int> pai, tamanho;

    explicit DSU(int quantidade) : pai(quantidade), tamanho(quantidade, 1) {
        iota(pai.begin(), pai.end(), 0);
    }

    int encontrar(int elemento) {
        if (pai[elemento] == elemento) return elemento;
        return pai[elemento] = encontrar(pai[elemento]);
    }

    bool unir(int primeiro, int segundo) {
        primeiro = encontrar(primeiro);
        segundo = encontrar(segundo);
        if (primeiro == segundo) return false;
        if (tamanho[primeiro] < tamanho[segundo]) swap(primeiro, segundo);
        pai[segundo] = primeiro;
        tamanho[primeiro] += tamanho[segundo];
        return true;
    }
};
```

Custo amortizado quase constante por operação (O(α(n))). Para enormes cadeias de chamadas ou contextos restritos, é possível implementar `encontrar` iterativamente.

### 10.4. Árvore de Fenwick (Fenwick Tree / Binary Indexed Tree — BIT)

Criada com `vector<long long>` e índices internos **1-based**. A variante abaixo suporta **incrementar um elemento** e **somar um prefixo**.

```cpp
struct Fenwick {
    int quantidade;
    vector<long long> arvore;

    explicit Fenwick(int n) : quantidade(n), arvore(n + 1, 0) {}

    void adicionar(int indice, long long incremento) {
        for (++indice; indice <= quantidade; indice += indice & -indice)
            arvore[indice] += incremento;
    }

    long long prefixo(int quantidadeElementos) const {
        long long soma = 0;
        for (int indice = quantidadeElementos; indice > 0; indice -= indice & -indice)
            soma += arvore[indice];
        return soma;
    }

    long long intervalo(int esquerda, int direita) const {
        // Intervalo [esquerda, direita), 0-based.
        return prefixo(direita) - prefixo(esquerda);
    }
};
```

Ambas operações O(log n). **Não é uma árvore de segmentos (Segment Tree) universal:** a estrutura e as operações dependem da agregação matemática suportada.

### 10.5. Árvore de segmentos (Segment Tree): consultas e alterações em intervalos

A variante abaixo agrega **soma** e implementa **atribuição em um índice**, com custo O(log n) para cada operação. É apenas um modelo de API genérica; versões de mínimo, máximo, contagem, propagação preguiçosa (Lazy Propagation) e persistência exigem outras regras.

```cpp
struct SegmentTree {
    int base;
    vector<long long> arvore;

    explicit SegmentTree(int quantidade) : base(1) {
        while (base < quantidade) base *= 2;
        arvore.assign(2 * base, 0);
    }

    void definir(int indice, long long valor) {
        indice += base;
        arvore[indice] = valor;
        for (indice /= 2; indice > 0; indice /= 2)
            arvore[indice] = arvore[2 * indice] + arvore[2 * indice + 1];
    }

    long long consultar(int esquerda, int direita) const {
        // Intervalo [esquerda, direita), 0-based.
        long long soma = 0;
        for (esquerda += base, direita += base; esquerda < direita;
             esquerda /= 2, direita /= 2) {
            if (esquerda % 2 == 1) soma += arvore[esquerda++];
            if (direita % 2 == 1) soma += arvore[--direita];
        }
        return soma;
    }
};
```

Memória O(n) e construção da estrutura O(n); com `definir` para cada elemento inicialmente, o preenchimento completo será O(n log n).

### 10.6. Árvore de prefixos (Trie / Prefix Tree)

Útil quando o problema depende de **prefixos compartilhados** de palavras. Não existe uma árvore de prefixos (Trie) pronta no C++11. Um nó pode combinar um array de 26 índices e um marcador de palavra terminada:

```cpp
struct NoTrie {
    array<int, 26> proximo;
    bool terminal = false;

    NoTrie() {
        proximo.fill(-1);
    }
};

struct Trie {
    vector<NoTrie> nos;

    Trie() {
        nos.emplace_back();
    }

    void inserir(const string& palavra) {
        int atual = 0;
        for (char letra : palavra) {
            int indice = letra - 'a';  // Pressupõe letras a-z.
            if (indice < 0 || indice >= 26) return;
            if (nos[atual].proximo[indice] == -1) {
                int novoIndice = static_cast<int>(nos.size());
                nos[atual].proximo[indice] = novoIndice;
                nos.emplace_back();
            }
            atual = nos[atual].proximo[indice];
        }
        nos[atual].terminal = true;
    }
};
```

Percorrer/inserir palavra de comprimento L custa O(L); o espaço depende do total de prefixos distintos. Quando o alfabeto é esparso ou não restrito a `a-z`, é possível trocar `array<int,26>` por `map<char,int>` ou `unordered_map<char,int>`, com diferenças de custo/memória.

### 10.7. Tabela esparsa (Sparse Table): intervalos estáticos

Para operações idempotentes, como **mínimo** ou **máximo**, pode usar `vector<vector<int>> tabela` indexada por potência de 2. Construção O(n log n), consulta O(1) (mínimos/máximos com sobreposição), memória O(n log n). Não fornece atualizações eficientes; não use a mesma regra de consulta sobre soma, pois haveria contagem duplicada.

### 10.8. Outras composições essenciais

| Estrutura/técnica | Componentes | Padrão |
| --- | --- | --- |
| Soma prefixada 1D (Prefix Sum) | `vector<long long>` de tamanho N+1 | Muitas somas em intervalos estáticos: prefixos O(n), consulta O(1) |
| Soma prefixada 2D (Prefix Sum) | `vector<vector<long long>>` com borda extra | Muitas somas de sub-retângulos |
| Vetor de diferenças (Difference Array) | `vector<long long>` | Muitas atualizações aditivas por intervalo, materializar no fim |
| Pilha monotônica (Monotonic Stack) | `vector<int>` como pilha ou `stack<int>` | Próximo maior/menor, spans, limites monotônicos |
| Fila dupla monotônica (Monotonic Deque) | `deque<int>` | Máximo/mínimo em janelas móveis |
| Busca em largura 0–1 (0–1 BFS) | `deque<int>` + adjacência | Grafos com pesos 0 e 1 |
| Programação dinâmica em árvores (Tree DP) | Adjacência + ordem de visita + arrays | Agregar estados dos filhos em um nó |
| Saltos binários (Binary Lifting) / ancestral comum mais baixo (Lowest Common Ancestor — LCA) | `vector<vector<int>> ancestral`, profundidade | Consultas de ancestral comum, após pré-processamento |
| Treap (árvore de busca aleatorizada) / árvore binária de busca (Binary Search Tree — BST) própria | `struct No`, nós e ligações | Ordem estatística, split/merge, políticas especiais |
| Simulação de pilhas alinhadas | `vector<vector<int>>` | Índices físicos, acesso a níveis e pilhas vizinhas |
| Montículo (Heap) com remoção preguiçosa (Lazy Deletion) | `priority_queue` + `unordered_map` ou controle de versão | Prioridades mudam; descartar entradas antigas no topo |
| Menos recentemente usado (Least Recently Used — LRU) | `list<pair<K,V>>` + `unordered_map<K, list<...>::iterator>` | Reordenar elementos mantendo referências a nós |
| Programação dinâmica por estado (Dynamic Programming — DP) | `vector`/`array` ou `unordered_map` | Estados densos ou esparsos |
| Combinatória por máscara | `bitset`, `uint64_t` ou `vector<uint64_t>` | Subconjuntos de tamanho pequeno/médio |

**Cuidado em estruturas "montadas":** identifique claramente quais operações o problema pede e quais o modelo acima realmente implementa. Por exemplo, uma árvore de Fenwick (Fenwick Tree) de soma não resolve automaticamente mínimo arbitrário com atualizações.

## 11. Extensões GNU úteis, mas NÃO parte do C++11 padrão

A biblioteca padrão **não** contém uma árvore de estatísticas de ordem (Order Statistics Tree) de uso genérico (`find_by_order` / `order_of_key`). Em GCC existe a extensão **estruturas de dados baseadas em políticas (Policy-Based Data Structures — PBDS)**:

```cpp
#include <bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace std;
using namespace __gnu_pbds;

typedef tree<int, null_type, less<int>, rb_tree_tag,
             tree_order_statistics_node_update> arvoreOrdenada;
```

- `arvoreOrdenada.order_of_key(x)`: número de chaves estritamente menores que `x`.
- `arvoreOrdenada.find_by_order(k)`: iterador da k-ésima chave, índice 0.
- É **extensão**, não garantida no BOCA só porque `bits/stdc++.h` existe. Verifique a imagem do juiz.
- `tree` é um conjunto sem duplicatas; para multiconjunto com ranking são necessárias adaptações cuidadosas (por exemplo, pares com ID único).
- Não conte com PBDS se a proposta da prova exigir **estritamente biblioteca padrão**. Uma árvore de Fenwick (Fenwick Tree), árvore de segmentos (Segment Tree) ou ordenação prévia podem ser alternativas.

Também são extensões GCC: `__builtin_popcount`, `__builtin_clz`, `__int128`, VLA `int v[n]` (não é C++11 ISO). No padrão: `vector<int> v(n)` para tamanho variável.

## 12. Funcionalidades que NÃO existem em C++11 (evite atalhos de versões recentes)

| Recurso | Versão |
| --- | --- |
| `std::make_unique` | C++14 |
| `std::quoted` | C++14 |
| Structured bindings `auto [a,b]` | C++17 |
| `std::gcd`, `std::lcm`, `std::clamp` | C++17 |
| `std::optional`, `std::variant`, `std::string_view` | C++17 |
| `std::filesystem`, `std::pmr` | C++17 |
| `std::reduce`, `std::inclusive_scan` / `exclusive_scan` | C++17 |
| `std::span`, `std::ranges::sort` | C++20 |
| `std::format`, `std::popcount`, `map.contains(x)` | C++20 |
| `std::print`, `std::println` | C++23 |

Exemplos de alternativas C++11: `make_pair` ou `pair<int,int>{...}`, `.first`/`.second`, `find(x) != end()`, `std::sort`, cálculo de MDC pelo algoritmo de Euclides.

## 13. Processo de decisão durante a prova

1. **Protocolo:** EOF? N casos? sentinela? linhas? inteiro/real? Qual saída exata?
2. **Escala:** N, M, Q, total de entradas, limites de valores e memória.
3. **Modelo:** sequência, matriz, grafo dirigido/ponderado, árvore, texto, pontos, eventos.
4. **Operações:** consultas estáticas ou intercaladas com mudanças? Exige ordem? Duplicatas? Próximo vizinho?
5. **Estrutura:** vetor, set/map, hash, queue/heap ou estrutura composta.
6. **Técnica:** ordenar, prefixos, busca binária (Binary Search), dois ponteiros (Two Pointers), janela deslizante (Sliding Window), busca em largura (Breadth-First Search — BFS), busca em profundidade (Depth-First Search — DFS) e programação dinâmica (Dynamic Programming — DP) etc.
7. **Complexidade:** escolha estimativa conservadora para pior caso e compare com limite.
8. **Robustez:** overflow, índices 0/1-based, invalidação, recursão profunda, desempates, formato.
9. **Teste local:** casos mínimo, máximo, empate, duplicatas, vazio (se permitido), dados ordenados/inversos.
10. **Submissão:** remova leituras de arquivos, use somente `stdin`/`stdout`, linguagem C++11.

## 14. Fontes técnicas e material de referência

- [cppreference — containers](https://en.cppreference.com/w/cpp/container): todas as famílias, iterator invalidation, complexidades.
- [cppreference — algorithms](https://en.cppreference.com/w/cpp/algorithm): ordenação, buscas, heap, sets, ranges, funções numéricas.
- [cppreference — memory](https://en.cppreference.com/w/cpp/memory): gerenciamento, `unique_ptr`, `shared_ptr`.
- [GCC libstdc++ — cabeçalhos precompilados](https://gcc.gnu.org/onlinedocs/gcc-9.5.0/libstdc%2B%2B/manual/manual/using_headers.html): papel de `bits/stdc++.h`.
- [GCC libstdc++ — policy-based data structures](https://gcc.gnu.org/onlinedocs/libstdc%2B%2B/ext/pb_ds/): extensões GNU; não padronizadas.
- [CP-Algorithms](https://cp-algorithms.com/): estruturas compostas e algoritmos clássicos.
- [Cadernos do projeto](maratona-cadernos/): enunciados usados na matriz do [mapa dos problemas](mapa-cadernos-estruturas.md).

> O inventário considera a biblioteca de C++11 e as estruturas **diretamente úteis em competição**. Não lista individualmente todas as sobrecargas/funções de todo cabeçalho padrão (como internacionalização, regex ou modelos de concorrência), mas cobre as famílias de containers, adaptadores e algoritmos relevantes para os enunciados inspecionados.
