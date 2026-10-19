
CXX      = g++
CXXFLAGS ?= -std=c++11 -O2 -Wall -Wextra -pedantic

SRC       = main.cpp
BIN       = build/main
INPUT     = stdin
OUTPUT    = stdout

.DEFAULT_GOAL := run
.PHONY: build run clean

build: $(BIN)

$(BIN): $(SRC)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -o $@

run: build
	@test -f $(INPUT) || (echo "Arquivo '$(INPUT)' nao encontrado." >&2; exit 1)
	@./$(BIN) < $(INPUT) > $(OUTPUT)
	@echo "Execucao concluida. Saida em '$(OUTPUT)'."

clean:
	rm -rf build $(OUTPUT)
