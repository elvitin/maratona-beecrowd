CXX      = g++
CXXFLAGS ?= -std=c++11 -O2 -Wall -Wextra -pedantic

SRC         = main.cpp
BIN         = build/main
VERSION_SRC = version.cpp
VERSION_BIN = build/version
INPUT       ?= stdin
OUTPUT      ?= stdout

.DEFAULT_GOAL := run
.PHONY: help build run build-version version clean

help:
	@printf '%s\n' \
	  'Comandos disponíveis:' \
	  '  make help                         Exibe esta ajuda.' \
	  '  make                              Compila e executa main.cpp.' \
	  '  make build                        Compila somente main.cpp.' \
	  '  make run                          Lê stdin e grava stdout.' \
	  '  make version                      Compila e executa version.cpp.' \
	  '  make build-version                Compila somente version.cpp.' \
	  '  make clean                        Remove somente os binários de build/.' \
	  '' \
	  'Opções:' \
	  '  make run INPUT=outro.in OUTPUT=outro.out'

build: $(BIN)

$(BIN): $(SRC)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -o $@

run: build
	@test -f "$(INPUT)" || (echo "Arquivo '$(INPUT)' nao encontrado." >&2; exit 1)
	@"./$(BIN)" < "$(INPUT)" > "$(OUTPUT)"
	@echo "Execucao concluida. Saida em '$(OUTPUT)'."

build-version: $(VERSION_BIN)

$(VERSION_BIN): $(VERSION_SRC)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -o $@

version: build-version
	@"./$(VERSION_BIN)"

clean:
	rm -rf build
