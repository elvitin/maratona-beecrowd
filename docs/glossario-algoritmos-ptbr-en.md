# Glossário bilíngue de algoritmos e estruturas para maratonas

Termos em português brasileiro (PT-BR) ao lado dos nomes em inglês usados em editoriais, referências técnicas e competições. A **sigla** e o nome original continuam disponíveis para pesquisa. Nomes próprios (Dijkstra, Fenwick, Kosaraju, Tarjan) não são traduzidos.

| PT-BR | Inglês / sigla | Contexto |
| --- | --- | --- |
| Busca em largura | Breadth-First Search (BFS) | Exploração por níveis de grafos; também em árvores |
| Busca em profundidade | Depth-First Search (DFS) | Travessia por aprofundamento, pilha ou recursão |
| Busca em largura 0–1 | 0–1 BFS | Menores caminhos com arestas de peso zero ou um |
| Algoritmo de Dijkstra | Dijkstra's Algorithm | Menores caminhos com pesos não negativos |
| Ordenação topológica | Topological Sorting / Topological Sort | Dependências em grafo dirigido acíclico |
| Algoritmo guloso | Greedy Algorithm | Escolhas locais sob critério demonstrável |
| Busca com retrocesso | Backtracking | Explorar alternativas e desfazer escolhas |
| Busca binária | Binary Search | Busca em intervalos ordenados ou espaço de resposta monotônico |
| Dois ponteiros | Two Pointers | Percorrer sequência com índices coordenados |
| Janela deslizante | Sliding Window | Atualizar resultados em intervalos móveis |
| Soma prefixada | Prefix Sum | Consultas de somas acumuladas |
| Vetor de diferenças | Difference Array | Atualizações aditivas em intervalos |
| Programação dinâmica | Dynamic Programming (DP) | Reuso de estados de subproblemas |
| Programação dinâmica em árvores | Tree DP | Agregação de estados em árvore |
| Maior subsequência estritamente crescente | Longest Increasing Subsequence (LIS) | Subsequência crescente máxima em comprimento |
| Contagem de inversões | Inversion Counting | Pares fora de ordem |
| Ordenação por intercalação | Merge Sort | Divisão e intercalação, também para contar inversões |
| Ordenação estável | Stable Sort | Preservar ordem relativa dos elementos equivalentes |
| Ordenação por montículo | Heap Sort | Ordenar a partir de um heap |
| Montículo | Heap | Estrutura de prioridades |
| Pilha monotônica | Monotonic Stack | Próximos maiores ou menores e limites |
| Fila dupla monotônica | Monotonic Deque | Máximos e mínimos em janela móvel |
| Conjuntos disjuntos; união e busca | Disjoint Set Union (DSU) / Union-Find | Unir e consultar componentes |
| Árvore de Fenwick; árvore binária indexada | Fenwick Tree / Binary Indexed Tree (BIT) | Atualizações e consultas prefixadas |
| Árvore de segmentos | Segment Tree | Consultas e atualizações em intervalos |
| Tabela esparsa | Sparse Table | Consultas estáticas de operações idempotentes |
| Árvore de prefixos | Trie / Prefix Tree | Compartilhar prefixos de palavras |
| Saltos binários | Binary Lifting | Consultar ancestrais por potências de dois |
| Ancestral comum mais baixo | Lowest Common Ancestor (LCA) | Encontrar ancestral comum mais profundo |
| Árvore binária de busca | Binary Search Tree (BST) | Organizar chaves por ordem |
| Árvore de estatísticas de ordem | Order Statistics Tree | Consultar ranking, ordem e k-ésimo elemento |
| Propagação preguiçosa | Lazy Propagation | Adiar operações sobre intervalos |
| Remoção preguiçosa | Lazy Deletion | Adiar a remoção física de elementos obsoletos |
| Componentes fortemente conexas | Strongly Connected Components (SCC) | Grupos mutuamente alcançáveis em grafo dirigido |
| Algoritmo de Kosaraju | Kosaraju's Algorithm | Identificação de componentes fortemente conexas |
| Algoritmo de Tarjan | Tarjan's Algorithm | Identificação de componentes fortemente conexas |
| Menos recentemente usado | Least Recently Used (LRU) | Política de substituição de cache |
| Árvore de busca aleatorizada | Treap | BST com prioridades |
| Máscara de bits | Bitmask | Representar conjuntos e estados com bits |
| Programação por máscaras de bits | Bitmask DP | Estados de programação dinâmica baseados em subconjuntos |

**Identificadores da STL não são traduzidos:** `sort`, `stable_sort`, `binary_search`, `lower_bound`, `upper_bound`, `priority_queue`, `vector`, `map` e outras APIs mantêm sua grafia original no código. Diferencie o *nome do algoritmo* da *função* que o implementa. Por exemplo, **busca binária (Binary Search)** é a técnica, enquanto `std::binary_search` é uma função específica.

**Abreviações conforme o contexto:** DFS, BFS, DP, LIS, LCA, DSU, SCC e BIT são siglas de nomes em inglês; use as expansões da tabela na primeira menção técnica de cada seção, especialmente nos títulos e nas tabelas.

**Compatibilidade:** os nomes em português e inglês não implicam que exista uma função pronta na biblioteca padrão C++11; Fenwick Tree, Segment Tree, Trie e DSU são estruturas que precisam de implementação ou composição. `bits/stdc++.h` reúne cabeçalhos GNU, não implementações dessas estruturas.

Consulte o [guia técnico](guia-stl-cpp11-maratona.md) e o [mapa dos exercícios](mapa-cadernos-estruturas.md) para exemplos de uso sem resolução dos problemas.
