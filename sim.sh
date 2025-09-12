VHDL_FILES=(
    "parity3.vhd"
    "tb_parity3.vhd"
)

TOP_ENTITY="tb_parity3" 
SIM_TIME="100ns"      
VCD_WAVE_FILE="tb_wave.vcd"
GHW_WAVE_FILE="tb_wave.ghw"      

VHDL_STANDARD="--std=08"      # Configura o padrão VHDL para 2008


echo "--- Iniciando simulação VHDL com GHDL ---"
echo "Arquivos VHDL: ${VHDL_FILES[@]}"
echo "Entidade de topo: ${TOP_ENTITY}"
echo "Tempo de simulação: ${SIM_TIME}"
echo "Arquivo de waveform: ${WAVE_FILE}"
echo "-----------------------------------------"

# Limpeza 
echo "Executando limpeza..."
rm -f *.o *.cf ${VCD_WAVE_FILE} ${GHW_WAVE_FILE} work-obj*.cf *.ghw 2>/dev/null # Remove arquivos anteriores
echo "Limpeza concluída."

# Compilação
echo "Iniciando compilação..."
for file in "${VHDL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERRO: Arquivo VHDL não encontrado: $file"
        exit 1
    fi
    echo "Compilando $file..."
    ghdl -a ${VHDL_STANDARD} "$file"
    if [ $? -ne 0 ]; then
        echo "ERRO na compilação de $file. Verifique o código VHDL."
        exit 1
    fi
done
echo "Compilação concluída com sucesso."

# Elaboração 
echo "Iniciando elaboração da entidade de topo '$TOP_ENTITY'..."
ghdl -e ${VHDL_STANDARD} "$TOP_ENTITY"
if [ $? -ne 0 ]; then
    echo "ERRO na elaboração da entidade $TOP_ENTITY. Verifique a arquitetura e dependências."
    exit 1
fi
echo "Elaboração concluída com sucesso."

# --- Execução da Simulação ---
echo "Iniciando simulação por $SIM_TIME..."
# --- waveform 
ghdl -r ${VHDL_STANDARD} "$TOP_ENTITY" --stop-time="$SIM_TIME" --vcd="$VCD_WAVE_FILE" --wave="$GHW_WAVE_FILE"
if [ $? -ne 0 ]; then
    echo "ERRO durante a execução da simulação."
    exit 1
fi

echo "Simulação concluída."
echo "Arquivo de waveform '${VCD_WAVE_FILE}' e '${GHW_WAVE_FILE}' gerado."

# --- Instruções Finais ---
echo "-----------------------------------------"
echo "Simulação finalizada."

exit 0