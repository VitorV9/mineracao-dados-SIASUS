require_relative 'siasusetl'

dir_atual = __dir__
arquivos_brutos = [
  File.join(dir_atual, "../Dadosbrutos/PARS2510a.csv"),
  File.join(dir_atual, "../Dadosbrutos/PARS2510b.csv"),
  File.join(dir_atual, "../Dadosbrutos/PARS2511.csv"),
  File.join(dir_atual, "../Dadosbrutos/PARS2512.csv")
]
caminho_saida = File.join(dir_atual, "../base_idosos_tratada.csv")

puts "Iniciando a extração dos dados..."
limpar_dados_siasus(arquivos_brutos, caminho_saida)