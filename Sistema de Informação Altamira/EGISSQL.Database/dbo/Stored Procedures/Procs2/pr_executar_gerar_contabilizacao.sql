
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina geradora da contabilização
--Data: 06/10/2003
-----------------------------------------------------------------------------------------

create procedure pr_executar_gerar_contabilizacao
@dt_inicio datetime,
@cd_usuario int
as

begin

  declare @NotaEntrada int
  declare @Fornecedor int
  declare @CFOP int
  declare @Serie int
  declare @Receb datetime

  declare cExecutarGerarContabilizacao cursor for
  select
    cd_nota_entrada,
    cd_fornecedor,
    cd_operacao_fiscal,
    cd_serie_nota_fiscal,
    dt_receb_nota_entrada
  from
    Nota_Entrada
  where
    dt_receb_nota_entrada >= @dt_inicio
  order by
    dt_receb_nota_entrada

  open cExecutarGerarContabilizacao 

  fetch next from cExecutarGerarContabilizacao into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  while @@fetch_status = 0
  begin

    print('NF '+cast(@NotaEntrada as varchar)+
          ' Fornecedor '+cast(@Fornecedor as varchar)+
          ' Serie '+cast(@Serie as varchar)+
          ' CFOP '+cast(@CFOP as varchar)+
          ' Receb '+cast(@Receb as varchar))

    exec pr_gerar_contabilizacao_entrada 1, @NotaEntrada, @Fornecedor, @CFOP, @Serie, @cd_usuario
    fetch next from cExecutarGerarContabilizacao into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  end

  close cExecutarGerarContabilizacao
  deallocate cExecutarGerarContabilizacao

end

