# SRA Toolkit
## Comandos importantes para o projeto

Lista de comandos importantes:
1. **fastq-dump** ([Documentação](https://ncbi.github.io/sra-tools/fastq-dump.html))
2. **fasterq-dump** ([Documentação](https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump))
3. **vdb-dump** ([Documentação](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=vdb-dump))

### 1. fastq-dump
Lista de opções:
* Comandos gerais:
    * `<-h>` ou `<--help>`: Traz uma lista com todas as opções possíveis de comandos a serem usados.
    * `<-v>` ou `<--version>`: Mostra qual versão do sra-toolkit estamos usando.
* Formatação dos dados:
    * `<--split-files>`: Separa o *dump* em arquivos diferentes. Os arquivos receberão um sufixo correspondente à sua ordem na leitura.
    * `<--fasta <[comprimento da linha]>>`: Apenas FASTA, sem os quality scores. A quebra de linha é opcional (0 para nenhuma quebra).
    * `<-I>` ou `<--readids>`: Acrescenta o id da leitura após o id do spot como 'accession.spot.readid' na defline.
    * `<-F>` ou `<--origfmt>`: Acrescenta o nome orig9inalda sequência na defline.
    * `<-C>` ou `<--dumpcs <[color space key]>>`: Formata a sequência usando um colorspace (SOLiD é o padrão).
    * `<-B>` ou `<--dumpbase>`: Formata a sequência usando um basespace (SOLiD não é padrão).
    * `<-Q>` ou `<--offset <int>>`: Offset usado para QS em ASCII. O padrão é 33 ('!' na tabela ASCII).
* Filtragem:
    * `<-N>` ou `<--minSpotId <id da coluna>>`: Id mínimo que um spot precisa para sem *dumpado*. Para *dumpar* uma range, use -N.
    * `<-N>` ou `<--minSpotId <id da coluna>>`: Id máximo que um spot pode ter para sem *dumpado*. Para *dumpar* uma range, use -X.
    * `<-M>` ou `<--minReadLen <comprimento>>`: Filtragem baseada no comprimento da sequência >= comprimento
    * `<--skip-technical>`: *Dumpa* somente as leituras biológicas.
    * `<--aligned>`: *Dumpa* somente sequências alinhadas. Usado somente para sequências alinhadas.
    * `<--unaligned>`: *Dumpa* somente sequências não alinhadas. Usado somente para sequências não alinhadas.
* Auxiliares de workflow e pipelining:
    * `<-O>` ou `<--outdir <path>>`: Diretório de saída.
    * `<-Z>` ou `<--stdout>`: Output no terminal.
    * `<--gzip>`: Comprime a saída usando gzip.
    * `<--bzip2>`: Comprime a saída usano bzip2.

TODO: exemplos de uso.

### 2. fasterq-dump
Lista de opções:
* Comandos gerais:
    * `<-h>` ou `<--help>`: Traz uma lista com todas as opções possíveis de comandos a serem usados.
    * `<-v>` ou `<--version>`: Mostra qual versão do sra-toolkit estamos usando.
* Formatação dos dados:
    * `<--split-files>`: Separa o *dump* em arquivos diferentes. Os arquivos receberão um sufixo correspondente à sua ordem na leitura.
    * `<--fasta <[comprimento da linha]>>`: Apenas FASTA, sem os quality scores. A quebra de linha é opcional (0 para nenhuma quebra).
    * `<-I>` ou `<--readids>`: Acrescenta o id da leitura após o id do spot como 'accession.spot.readid' na defline.
    * `<-F>` ou `<--origfmt>`: Acrescenta o nome orig9inalda sequência na defline.
    * `<-C>` ou `<--dumpcs <[color space key]>>`: Formata a sequência usando um colorspace (SOLiD é o padrão).
    * `<-B>` ou `<--dumpbase>`: Formata a sequência usando um basespace (SOLiD não é padrão).
    * `<-Q>` ou `<--offset <int>>`: Offset usado para QS em ASCII. O padrão é 33 ('!' na tabela ASCII).
* Filtragem:
    * `<-M>` ou `<--minReadLen <comprimento>>`: Filtragem baseada no comprimento da sequência >= comprimento
    * `<--skip-technical>`: *Dumpa* somente as leituras biológicas.
    * `<--aligned>`: *Dumpa* somente sequências alinhadas. Usado somente para sequências alinhadas.
    * `<--unaligned>`: *Dumpa* somente sequências não alinhadas. Usado somente para sequências não alinhadas.
* Auxiliares de workflow e pipelining:
    * `<-O>` ou `<--outdir <path>>`: Diretório de saída.
    * `<-Z>` ou `<--stdout>`: Output no terminal. Não funciona para split-3 e split-files.

TODO: exemplos de uso.

## 3. vdb-dump
Lista de opções:
* Comandos gerais:
    * `<-h>` ou `<--help>`: Traz uma lista com todas as opções possíveis de comandos a serem usados.
    * `<-v>` ou `<--version>`: Mostra qual versão do sra-toolkit estamos usando.
* Formatação dos dados:
    * `<-I>` ou `<--row_id_on>`: Imprime o id da coluna.
    * `<-N>` ou `<--colname_off>`: Não imprime o nome da coluna.
    * `<-X>` ou `<--in_hex>`: Imprime os números em hexadecimal.
    * `<-E>` ou `<--table_enum>`: Enumera as tabelas.
    * `<-T>` ou `<--table <table(s)>>`: *Dumpa* somente as tabelas inclusas em uma lista separada por vírgulas.
    * `<-o>` ou `<--column_enum_short>`: Lista as colunas disponíveis de maneira sucinta.
    * `<-O>` ou `<--column_enum>`: Lista as colunas disponíveis de maneira extensa.
    * `<--phys>`: Lista as colunas físicas.
    * `<-C>` ou `<--columns <coluna(s)>>`: *Dumpa* somente as colunas inclusas em uma lista separada por vírgulas.
    * `<-x>` ou `<--exclude>`: Exclui colunas específicas do *dump*.
    * `<-R>` ou `<--rows <linha(s)>>`: *Dumpa* somente as linhas inclusas em uma lista separada por vírgulas.
    * `<-M>` ou `<--max_length <comprimento máximo>>`: Limita o comprimento das linhas.
    * `<-f>` ou `<--format <formato>>`: *Dumpa* no dado formato (csv, xml, json, piped, tab, fastq, fasta).
* Auxiliares de workflow e pipelining:
    * `<--outdir-file>`: Diretório de saída.
    * `<--gzip>`: Comprime a saída usando gzip.
    * `<--bzip2>`: Comprime a saída usano bzip2.
    * `<--outdir-buffer-size>`: Muda o tamanho do buffer de saída.
    * `<--disable-multithreadings>`: Desabilita multithreading.
    * `<--option-file <arquivo>>`: Lê opções e parâmetros em dado arquivo.

TODO: exemplos de uso.