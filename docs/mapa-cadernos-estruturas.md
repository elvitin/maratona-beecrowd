# Mapa dos cadernos de maratona → estruturas e técnicas C++11

> **Objetivo:** conectar o [guia de estruturas C++11](guia-stl-cpp11-maratona.md) com **problemas reais** dos cadernos fornecidos. **Não contém resolução, passo a passo de solução, código específico do problema nem saída calculada.** As sugestões abaixo são **candidatas ao estudo**, não garantias de necessidade ou de complexidade ótima.

## 1. Corpus e método

Fonte primária: [`docs/maratona-cadernos/`](maratona-cadernos/), também presente no ZIP `maratona-cadernos.zip` anexado à pesquisa. Os arquivos `tarefasANO.pdf` contêm os enunciados; os `ioANO.*` são materiais auxiliares de entrada/saída e/ou compactados. Não trate estes auxiliares como enunciados adicionais sem verificá-los.

Foram inspecionados os PDFs de tarefas de 2005 a 2019 e de 2022 a 2025 (19 cadernos). O PDF de 2005 tem texto extraído com codificação ilegível e não fundamenta classificações específicas neste mapa; **não foi aplicado OCR**. O ZIP também tem arquivos RAR e ZIP internos que não foram necessários para identificar os enunciados dos cadernos de tarefas.

**Como interpretar cada linha:**
- **Dados reais**: entidades que o enunciado descreve, sem inferir detalhes ausentes.
- **Ferramentas para avaliar**: possíveis containers/algoritmos; podem existir abordagens melhores.
- **Por que estudar**: capacidade de modelagem que esse tipo de entrada exige.
- Páginas são **páginas físicas do PDF**, começando em 1, e não o número do problema.

## 2. Leitura, textos, simulação e formatação

| Caderno / problema | Página PDF | Dados / operações observadas | Ferramentas candidatas e tema de estudo |
| --- | ---: | --- | --- |
| 2006 — **Monitor LCD** | [2](maratona-cadernos/tarefas2006.pdf#page=2) | Entrada numérica, representação visual de dígitos | `string`, `array`, máscaras de segmentos, laços e saída formatada |
| 2006 — **Criptografia** | [3](maratona-cadernos/tarefas2006.pdf#page=3) | Transformação de texto | `string`, `array<char,26>`, mapeamento de caracteres |
| 2006 — **WERTYU** | [9](maratona-cadernos/tarefas2006.pdf#page=9) | Substituição de teclas/caracteres | `string`, `map<char,char>` ou lookup por array |
| 2009 — **Histórico de Comandos** | [6](maratona-cadernos/tarefas2009.pdf#page=6) | Registro/ordem de comandos que muda durante o uso | `list`, `deque`, `vector`, `map` de índices; custo de reposicionamento |
| 2010 — **Rouba-Monte** | [8](maratona-cadernos/tarefas2010.pdf#page=8) | Simulação de jogadas e montes | `vector`, `stack`, contadores, estado por jogador |
| 2012 — **Robô Colecionador** | [2](maratona-cadernos/tarefas2012.pdf#page=2) | Arena retangular, orientação e instruções | `vector<string>`, `pair<int,int>`, `struct Estado`, `array` de direções |
| 2012 — **Jingle Composing** | [8](maratona-cadernos/tarefas2012.pdf#page=8) | Sequências simbólicas e duração | `string`, `map<char,int>` ou `array` para tabela de símbolos |
| 2012 — **Revisão de Contrato** | [10](maratona-cadernos/tarefas2012.pdf#page=10) | Texto de números e transformação de dígitos | `string`, `erase`, `find`, tratamento de zeros |
| 2013 — **Loop Musical** | [2](maratona-cadernos/tarefas2013.pdf#page=2) | Sequência de magnitudes e padrões locais | `vector<int>`, índices vizinhos, laços circulares |
| 2014 — **Restoring IPv6** | [6](maratona-cadernos/tarefas2014.pdf#page=6) | Representação e reconstrução textual de endereço | `string`, parsing, `stringstream` e `iomanip` |
| 2015 — **Polynomial Printer** | [6](maratona-cadernos/tarefas2015.pdf#page=6) | Coeficientes de polinômio e texto formatado | `vector<long long>`, `ostringstream`, regras de sinais/formatos |
| 2019 — **Exploradores do mundo plano** | [5](maratona-cadernos/tarefas2019.pdf#page=5) | Robôs, orientação, limites e comandos | `struct`, `vector`, `set<pair<int,int>>` para registrar posições |
| 2019 — **Tautograms** | [8](maratona-cadernos/tarefas2019.pdf#page=8) | Palavras em linhas | `getline`, `istringstream`, `tolower` |
| 2024 — **Contando o Caos** | [3](maratona-cadernos/tarefas2024.pdf#page=3) | Horários `HH:MM` e propriedade palíndroma | `string`, conversão número↔texto, `setw`, `setfill`; **não é** problema de inversões |
| 2025 — **The Supreme AI Model** | [6](maratona-cadernos/tarefas2025.pdf#page=6) | Dígitos e concatenação para formar número | `array<int,10>`, `vector<int>`, `sort`, `string` e comparação de representação |

## 3. Ordenação, busca, frequência e conjuntos

| Caderno / problema | Página PDF | Dados / operações observadas | Ferramentas candidatas e tema de estudo |
| --- | ---: | --- | --- |
| 2006 — **Futebol** | [4](maratona-cadernos/tarefas2006.pdf#page=4) | Times, partidas, estatísticas e desempates | `struct Time`, `vector<Time>`, `map<string,int>`, `sort` com comparador |
| 2009 — **Fake Tickets** | [5](maratona-cadernos/tarefas2009.pdf#page=5) | Bilhetes identificados por números e ocorrências | `vector<int>` de frequências, `unordered_map` ou `sort` |
| 2012 — **Onde Estão as Bolhas?** | [4](maratona-cadernos/tarefas2012.pdf#page=4) | Ordenação por trocas adjacentes, sequências extensas | `vector`; conceito de inversões, contagem combinada a merge sort/Fenwick Tree (**não** substituir diretamente pelo número de comparações de `sort`) |
| 2013 — **Symmetric Order** | [6](maratona-cadernos/tarefas2013.pdf#page=6) | Nomes e ordenação com regras de organização | `vector<string>`, `deque<string>` ou índices ordenados |
| 2014 — **Campeonato de Futebol da FIPP** | [4](maratona-cadernos/tarefas2014.pdf#page=4) | Classificação e ordenação de participantes | `struct`, `vector`, `sort` e regras de desempate |
| 2018 — **Um vencedor** | [2](maratona-cadernos/tarefas2018.pdf#page=2) | Votos/pontuações e escolha de resultado | `vector`, `map`, contagens e desempates |
| 2023 — **Pastas** | [10](maratona-cadernos/tarefas2023.pdf#page=10) | Pastas representadas pela **posição da aba** e sequência periódica de arquivamento | `vector<int>` ou `array` de frequências; **não** é árvore de diretórios |
| 2024 — **Telefone Celular** | [4](maratona-cadernos/tarefas2024.pdf#page=4) | Dicionário de palavras e completamento por prefixos | Trie com `vector<No>` + `array<int,26>`; alternativa: `vector<string>` ordenado e análise de prefixos |
| 2024 — **What is the class?** | [6](maratona-cadernos/tarefas2024.pdf#page=6) | Pontos 2D, classes, distância Manhattan/Euclidiana e desempate | `struct Ponto`, `vector<Ponto>`, `min_element`, comparadores, aritmética segura |
| 2025 — **The Space Explorers** | [5](maratona-cadernos/tarefas2025.pdf#page=5) | Centroides e consultas de ponto mais próximo em 2D | `vector<pair<double,double>>`, comparação de distâncias; avaliar quando busca linear basta e quando índice espacial se justifica |
| 2025 — **Estação Mais Próxima** | [7](maratona-cadernos/tarefas2025.pdf#page=7) | Posições **já ordenadas** em 1D e muitas consultas | `vector<long long>`, `lower_bound`, cálculo de distância a candidatos vizinhos |
| 2025 — **A Curiosidade de Lee** | [8](maratona-cadernos/tarefas2025.pdf#page=8) | Vetores de até 10 dimensões, propriedade numérica de pares | `array<long long,10>`, `bitset<10>`, `set`/`unordered_set` de assinaturas; avaliar equivalência e hash |

## 4. Grades, intervalos, matemática e programação dinâmica

| Caderno / problema | Página PDF | Dados / operações observadas | Ferramentas candidatas e tema de estudo |
| --- | ---: | --- | --- |
| 2006 — **Minesweeper** | [7](maratona-cadernos/tarefas2006.pdf#page=7) | Grade 2D e vizinhança local | `vector<string>`, `array<pair<int,int>,8>` para deslocamentos |
| 2011 — **Temperatura Lunar** | [6](maratona-cadernos/tarefas2011.pdf#page=6) | Série de medições e intervalos | `vector<int>`, janela deslizante ou prefixos conforme as consultas |
| 2012 — **Mário** | [11](maratona-cadernos/tarefas2012.pdf#page=11) | Posições de armários e rearranjos | `vector`, intervalos, `sort`, janela deslizante |
| 2015 — **Circuito Bioquímico Digital** | [4](maratona-cadernos/tarefas2015.pdf#page=4) | Vetores sucessivos de bits e sequências contínuas | `vector<int>` para comprimentos por coluna, `bitset` quando largura fixa |
| 2015 — **Zona de Animais** | [10](maratona-cadernos/tarefas2015.pdf#page=10) | Retângulos com coordenadas limitadas a 0..19 | `struct Retangulo`, grade `array<array<int,20>,20>` ou análise geométrica de interseção |
| 2019 — **Unidirecional** | [3](maratona-cadernos/tarefas2019.pdf#page=3) | Matriz, passos entre colunas e custo de caminho | `vector<vector<long long>>`, programação dinâmica de grade; restauração de índices de caminho |
| 2022 — **Desempilhando Caixas** | [8](maratona-cadernos/tarefas2022.pdf#page=8) | Várias pilhas lado a lado, caixas de base até topo | `vector<vector<int>>`, `stack`, vizinhança e simulação por níveis |
| 2023 — **Macaco-prego** | [3](maratona-cadernos/tarefas2023.pdf#page=3) | Retângulos, interseção de limites e casos de teste | `struct Retangulo`, pares de coordenadas e limites |
| 2023 — **Quadrado** | [8](maratona-cadernos/tarefas2023.pdf#page=8) | Matriz quadrada e somatórios de linhas/colunas | `vector<vector<long long>>`, vetores de somas e diagonais |
| 2024 — **Doces do Dia das Bruxas** | [11](maratona-cadernos/tarefas2024.pdf#page=11) | Sequência de inteiros, subconjunto/trecho e divisibilidade | `vector<long long>`, somas prefixadas, `unordered_map` ou `vector<int>` de resíduos |
| 2025 — **O Mercado dos Parâmetros** | [4](maratona-cadernos/tarefas2025.pdf#page=4) | Pontos reais, candidatos e métrica numérica | `struct Ponto`, `vector<pair<double,double>>`, `double`, `numeric_limits`, acumulação |
| 2025 — **A Batalha dos Algoritmos** | [3](maratona-cadernos/tarefas2025.pdf#page=3) | Dimensões e comparação de custos numéricos | Tipos inteiros adequados, `long long`, overflow e comparações; estruturas podem ser desnecessárias |

## 5. Grafos, hierarquias e árvores

| Caderno / problema | Página PDF | Dados / operações observadas | Ferramentas candidatas e tema de estudo |
| --- | ---: | --- | --- |
| 2013 — **Curso Universitário** | [4](maratona-cadernos/tarefas2013.pdf#page=4) | Disciplinas, relações de pré-requisito e planejamento | Grafo de dependências, `vector<vector<int>>`, graus de entrada, `queue`, ordenação topológica |
| 2016 — **Países em Guerra** | [3](maratona-cadernos/tarefas2016.pdf#page=3) | Rede **direcionada**, tempos de entrega e grupos mutuamente alcançáveis | Lista de adjacência ponderada; alcançabilidade, componentes fortemente conexas, caminhos mínimos |
| 2016 — **Rota Crítica** | [9](maratona-cadernos/tarefas2016.pdf#page=9) | Estradas cuja interrupção compromete conectividade | Grafo não direcionado, DFS, pontes/articulações, tempos `tin/low` |
| 2017 — **Árvore** | [4](maratona-cadernos/tarefas2017.pdf#page=4) | Árvore com até 200.000 vértices coloridos | `vector<vector<int>>`, travessia iterativa, pais/profundidades, agregação em árvore |
| 2022 — **Copa do mundo** | [10](maratona-cadernos/tarefas2022.pdf#page=10) | Chave de confrontos e progressão de resultados | `vector`, `queue`, modelo de árvore de torneio |
| 2024 — **Challenging Hike** | [8](maratona-cadernos/tarefas2024.pdf#page=8) | Árvore de pontos turísticos, valores e escolha de sequência crescente em caminhos | Adjacência, DFS iterativa, estados de sequência crescente, técnicas de LIS/DP em árvore |

O termo **árvore** no enunciado nem sempre exige construir uma BST própria. Uma árvore do problema normalmente é um **grafo acíclico conectado** e basta lista de adjacência. Já uma **trie** é uma estrutura específica para prefixos. **Fenwick** e **Segment Tree** servem para consultas/atualizações de intervalos, não para armazenar automaticamente as arestas de uma árvore de vértices.

## 6. Exercícios por estrutura: roteiro de estudo sem gabarito

| Estrutura ou técnica | Cadernos para estudar primeiro |
| --- | --- |
| `string` + parsing + conversões | 2006 Criptografia; 2012 Revisão de Contrato; 2014 Restoring IPv6; 2024 Contando o Caos |
| `vector` + `sort` + comparador | 2006 Futebol; 2014 Campeonato de Futebol da FIPP; 2025 The Supreme AI Model |
| Busca binária em vetor ordenado | 2025 Estação Mais Próxima |
| Hash, contadores, arrays de frequência | 2009 Fake Tickets; 2023 Pastas; 2025 A Curiosidade de Lee |
| Estruturas de prefixo (trie) | 2024 Telefone Celular |
| Matrizes e simulação | 2006 Minesweeper; 2012 Robô Colecionador; 2015 Zona de Animais |
| Prefixos, DP e consultas de intervalo | 2019 Unidirecional; 2024 Doces do Dia das Bruxas |
| Grafos e componentes | 2013 Curso Universitário; 2016 Países em Guerra; 2016 Rota Crítica |
| Árvores com DFS e estados | 2017 Árvore; 2024 Challenging Hike |
| Pilhas com posições físicas | 2022 Desempilhando Caixas |
| Numéricos e tipos | 2025 A Batalha dos Algoritmos; 2025 O Mercado dos Parâmetros |

## 7. O que não é possível concluir só pela classificação

- **Não é possível afirmar a estrutura ótima** a partir do título e da descrição breve; cada caderno deve ser estudado com os limites completos.
- A presença de "árvore" ou "grafo" em um enunciado **não** torna DSU, Segment Tree, Dijkstra ou LCA automaticamente necessárias.
- Problemas de caminho mínimo podem ter pesos negativos, não negativos ou ser grades com estados; escolha o algoritmo conforme a definição do enunciado.
- Algumas abordagens avançadas são apenas **alternativas para aprender**; uma estrutura simples pode ser suficiente para o limite dado.
- **Nenhum exercício foi resolvido.** Nenhum dos códigos de entrada/saída de amostra foi usado para calcular gabaritos ou criar submissões.

## 8. Referências

- [Guia de containers, algoritmos, memória e estruturas combinadas](guia-stl-cpp11-maratona.md).
- [I/O da biblioteca de C](io-c.md) e [I/O de C++11](io-cpp11.md).
- [cppreference — Containers](https://en.cppreference.com/w/cpp/container).
- [cppreference — Algorithms](https://en.cppreference.com/w/cpp/algorithm).
