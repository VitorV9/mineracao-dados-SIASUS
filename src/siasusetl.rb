require 'csv'

def limpar_dados_siasus(arquivos_brutos, caminho_saida)
  File.open(caminho_saida, "w", encoding: 'utf-8') do |saida|

    saida.puts "faixa_idade,sexo,cid_doenca,grupo_procedimento"

    arquivos_brutos.each do |arquivo|
      puts "Lendo o arquivo: #{File.basename(arquivo)}..."

      cabecalho = []
      idx_idade = idx_proc = idx_sexo = idx_cid = nil

      File.foreach(arquivo, encoding: 'bom|utf-8', chomp: true) do |linha|
        
        colunas = linha.gsub('"', '').split(',', -1)

        if cabecalho.empty?
          cabecalho = colunas.map { |c| c.strip.upcase }
          idx_idade = cabecalho.index('PA_IDADE')
          idx_proc  = cabecalho.index('PA_PROC_ID')
          idx_sexo  = cabecalho.index('PA_SEXO')
          idx_cid   = cabecalho.index('PA_CIDPRI')
          next
        end

        next if colunas.size < 5

        idade_raw = colunas[idx_idade]
        proc_raw  = colunas[idx_proc]
        sexo      = colunas[idx_sexo]
        cid       = colunas[idx_cid]

        next if idade_raw.nil? || proc_raw.nil? || cid.nil? || cid.strip == "0000" || idade_raw.strip.empty?

        idade = idade_raw.to_i

        next if idade < 60

        faixa_idade = if idade < 70 then "60_69"
                      elsif idade < 80 then "70_79"
                      else "80_MAIS" end

        grupo_proc = proc_raw[0..1]

        saida.puts "#{faixa_idade},#{sexo},#{cid},#{grupo_proc}"
      end
    end
  end
  puts "Limpeza concluída! Base salva."
end