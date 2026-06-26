require 'csv'

def limpar_dados_siasus(arquivos_brutos, caminho_saida)
  separador = ","

  CSV.open(caminho_saida, "w") do |csv_saida|
    csv_saida << ["faixa_idade", "sexo", "cid_doenca", "grupo_procedimento"]

    arquivos_brutos.each do |arquivo|
      puts "Lendo o arquivo: #{File.basename(arquivo)}..."
      
      CSV.foreach(arquivo, headers: true, col_sep: separador, encoding: 'bom|utf-8', liberal_parsing: true) do |row|
        idade_raw = row['PA_IDADE'] || row['pa_idade']
        proc_raw  = row['PA_PROC_ID'] || row['pa_proc_id']
        sexo      = row['PA_SEXO'] || row['pa_sexo']
        cid       = row['PA_CIDPRI'] || row['pa_cidpri']

        next if idade_raw.nil? || proc_raw.nil? || cid.nil? || cid == "0000"
        
        idade = idade_raw.to_i
        
        next if idade < 60 

        faixa_idade = if idade < 70 then "60_69"
                      elsif idade < 80 then "70_79"
                      else "80_MAIS" end

        grupo_proc = proc_raw[0..1]

        csv_saida << [faixa_idade, sexo, cid, grupo_proc]
      end
    end
  end
  puts "Limpeza concluída! Base salva."
end