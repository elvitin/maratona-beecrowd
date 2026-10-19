# Guias de C++11 para maratonas

Materiais para consulta rápida durante o estudo e a preparação para BOCA/beecrowd.

- [Guia aprofundado de C++11 — containers, algoritmos, memória e estruturas compostas](guia-stl-cpp11-maratona.md): inventário de recursos prontos, conversões, passagem por cópia e referência, árvores, grafos, conjuntos disjuntos (Disjoint Set Union — DSU), árvore de Fenwick (Fenwick Tree), árvore de segmentos (Segment Tree) e árvore de prefixos (Trie).
- [Mapa dos cadernos — problemas e estruturas candidatas](mapa-cadernos-estruturas.md): relaciona os enunciados do acervo `maratona-cadernos` às estruturas sem resolver exercícios.
- [Glossário PT-BR / inglês de algoritmos e estruturas](glossario-algoritmos-ptbr-en.md): busca em largura (BFS), busca em profundidade (DFS), ordenação por intercalação (Merge Sort), árvore de segmentos (Segment Tree), entre outros.
- [I/O com a biblioteca C](io-c.md): `scanf`, `printf`, especificadores, largura, precisão, EOF, `fgets`, `getchar`, `sscanf`, `snprintf`, buffers e segurança.
- [I/O de C++11 e equivalências C ↔ C++](io-cpp11.md): `cin`, `cout`, `iomanip`, `getline`, `stringstream`, tabelas de correspondência, diferenças e limitações reais.

## Regras para a prova

1. As soluções são **C++11**. Evite `std::format` (C++20), `std::print` (C++23) e recursos de outras versões não suportados pelo juiz.
2. Prefira manter uma única família de I/O por solução; não misture streams de C e C++ após chamar `std::ios::sync_with_stdio(false)`.
3. O redirecionamento para arquivos `stdin` e `stdout` é feito pelo Makefile local — **não** por `freopen` no código.
4. Em problemas interativos, dê `flush` da saída antes de esperar a resposta do juiz.
5. Use o compilador selecionado pelo torneio como referência de compatibilidade.
