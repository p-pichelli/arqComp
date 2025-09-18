#!/usr/bin/env bash

# ===================== Configurações =====================
VHDL_FILES=(
    "reg_16bits.vhd"
    "reg_16bits_tb.vhd"
)

TOP_ENTITY="reg_16bits_tb" 
SIM_TIME="10us"      
VHDL_STANDARD="--std=08"      # Configura o padrão VHDL para 2008

# Diretório de saída (padrão: build). Pode ser passado como 1º argumento.
OUTPUT_DIR=${1:-build}

# Arquivos de waveform agora dentro do diretório de saída
VCD_WAVE_FILE="${OUTPUT_DIR}/tb_wave.vcd"
GHW_WAVE_FILE="${OUTPUT_DIR}/tb_wave.ghw"

# Nome do executável/elaboração
EXECUTABLE="${OUTPUT_DIR}/${TOP_ENTITY}.exe"


echo "--- Iniciando simulação VHDL com GHDL ---"
echo "Arquivos VHDL: ${VHDL_FILES[@]}"
echo "Entidade de topo: ${TOP_ENTITY}"
echo "Tempo de simulação: ${SIM_TIME}"
echo "Diretório de saída: ${OUTPUT_DIR}"
echo "Waveforms: $(basename "$VCD_WAVE_FILE"), $(basename "$GHW_WAVE_FILE")"
echo "-----------------------------------------------------"

# Cria diretório de saída
mkdir -p "$OUTPUT_DIR" || { echo "ERRO ao criar diretório $OUTPUT_DIR"; exit 1; }

# Limpeza seletiva dentro do diretório de saída
echo "Executando limpeza no diretório de saída..."
rm -f "${OUTPUT_DIR}"/*.o "${OUTPUT_DIR}"/*.cf "$VCD_WAVE_FILE" "$GHW_WAVE_FILE" "${OUTPUT_DIR}"/*.ghw 2>/dev/null
echo "Limpeza concluída."

# Compilação
echo "Iniciando compilação..."
for file in "${VHDL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERRO: Arquivo VHDL não encontrado: $file"
        exit 1
    fi
    echo "Compilando $file..."
    ghdl -a ${VHDL_STANDARD} --workdir="${OUTPUT_DIR}" "$file" || { echo "ERRO na compilação de $file"; exit 1; }
done
echo "Compilação concluída com sucesso."

# Elaboração 
echo "Iniciando elaboração da entidade de topo '$TOP_ENTITY'..."
ghdl -e ${VHDL_STANDARD} --workdir="${OUTPUT_DIR}" -o "${EXECUTABLE}" "$TOP_ENTITY" || { echo "ERRO na elaboração"; exit 1; }
echo "Elaboração concluída com sucesso. Executável: $EXECUTABLE"

# --- Execução da Simulação ---
echo "Iniciando simulação por $SIM_TIME..."
# Executa diretamente o binário gerado (evita erro de não encontrar .exe ao usar 'ghdl -r')
"${EXECUTABLE}" --stop-time="${SIM_TIME}" --vcd="${VCD_WAVE_FILE}" --wave="${GHW_WAVE_FILE}" || { echo "ERRO durante a simulação"; exit 1; }

echo "Simulação concluída."
echo "Arquivos de waveform gerados em: ${VCD_WAVE_FILE} e ${GHW_WAVE_FILE}"

# --- Instruções Finais ---
echo "-----------------------------------------"
echo "Simulação finalizada. Resultados em '${OUTPUT_DIR}'."

exit 0