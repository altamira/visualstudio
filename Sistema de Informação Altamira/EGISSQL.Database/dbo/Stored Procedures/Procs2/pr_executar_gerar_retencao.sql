
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina geradora das Retenções das Notas de Entrada
--Data: 14/07/2005
-----------------------------------------------------------------------------------------

create procedure pr_executar_gerar_retencao
@dt_inicio datetime,
@dt_final datetime,
@cd_usuario int
as

begin

  declare @NotaEntrada int
  declare @Fornecedor int
  declare @CFOP int
  declare @Serie int
  declare @Receb datetime

  declare cExecutarGerarRetencao cursor for
  select distinct
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.dt_receb_nota_entrada
  from Nota_Entrada ne inner join 
    Nota_Entrada_Parcela nep on nep.cd_nota_entrada = ne.cd_nota_entrada and
                                nep.cd_fornecedor = ne.cd_fornecedor and
                                nep.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                nep.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal left outer join
    Documento_Pagar dp on dp.cd_documento_pagar = nep.cd_documento_pagar
  where ne.dt_receb_nota_entrada between @dt_inicio and @dt_final and
      ((isnull(ne.vl_pis_nota_entrada,0) <> 0) or (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
       (isnull(ne.vl_csll_nota_entrada,0) <> 0) or (isnull(ne.vl_irrf_nota_entrada,0) <> 0))
  order by
    dt_receb_nota_entrada

  open cExecutarGerarRetencao

  fetch next from cExecutarGerarRetencao into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  while @@fetch_status = 0
  begin

    print('NF '+cast(@NotaEntrada as varchar)+
          ' Fornecedor '+cast(@Fornecedor as varchar)+
          ' Serie '+cast(@Serie as varchar)+
          ' CFOP '+cast(@CFOP as varchar)+
          ' Receb '+cast(@Receb as varchar))

    exec dbo.pr_gerar_doctos_pagar_retencao 1, @NotaEntrada, @Fornecedor, @CFOP, @Serie, @cd_usuario, NULL, 'N'

    fetch next from cExecutarGerarRetencao into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  end

  close cExecutarGerarRetencao
  deallocate cExecutarGerarRetencao

end

