
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina geradora das Valores Tributaveis que não tiveram Retenção
--          mas que devido a alguma retenção no ano deverão ser informados na DIRF - ELIAS
--Data: 05/08/2005
-----------------------------------------------------------------------------------------

create procedure pr_executar_gerar_dirf
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
  declare @Imposto char(1)

  -- TODAS NFS QUE TIVERAM RETENÇÃO
  select distinct ne.cd_nota_entrada, ne.cd_fornecedor, ne.cd_operacao_fiscal,
       ne.cd_serie_nota_fiscal, ne.cd_tipo_destinatario, dp.cd_documento_pagar, 
       case when (((isnull(ne.vl_pis_nota_entrada,0) <> 0) and (isnull(ne.vl_irrf_nota_entrada,0) <> 0)) or
                  ((isnull(ne.vl_cofins_nota_entrada,0) <> 0) and (isnull(ne.vl_irrf_nota_entrada,0) <> 0)) or 
                  ((isnull(ne.vl_csll_nota_entrada,0) <> 0) and (isnull(ne.vl_irrf_nota_entrada,0) <> 0))) then 'A' else
         case when isnull(ne.vl_irrf_nota_entrada,0) <> 0 then 'I' else 
           case when ((isnull(ne.vl_pis_nota_entrada,0) <> 0) or (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
                      (isnull(ne.vl_csll_nota_entrada,0) <> 0)) then 'C' else 'N' end end end as ic_imposto
  into #Retencao
  from Nota_Entrada ne inner join 
    Nota_Entrada_Parcela nep on nep.cd_nota_entrada = ne.cd_nota_entrada and
                                nep.cd_fornecedor = ne.cd_fornecedor and
                                nep.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                nep.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal left outer join
    Documento_Pagar dp on dp.cd_documento_pagar = nep.cd_documento_pagar left outer join
    (select cd_documento_pagar, min(dt_pagamento_documento) as dt_pagamento_documento 
     from Documento_pagar_pagamento group by cd_documento_pagar) dpp on dpp.cd_documento_pagar = nep.cd_documento_pagar
  where isnull(dpp.dt_pagamento_documento,isnull(dp.dt_vencimento_documento, nep.dt_parcela_nota_entrada)) between @dt_inicio and @dt_final and
      ((isnull(ne.vl_pis_nota_entrada,0) <> 0) or (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
       (isnull(ne.vl_csll_nota_entrada,0) <> 0) or (isnull(ne.vl_irrf_nota_entrada,0) <> 0))

  -- NFEs QUE NÃO TIVERAM RETENÇÃO, MAS DEVEM TER O VALOR INFORMADO DEVIDO A EXISTÊNCIA
  -- DE PELO MENOS UMA RETENÇÃO DURANTE O ANO
  declare cExecutarGerarDIRF cursor for
  select distinct
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.dt_receb_nota_entrada,
    isnull(r.ic_imposto,'A') as ic_imposto
  from Nota_Entrada ne inner join 
    #Retencao r on r.cd_fornecedor = ne.cd_fornecedor and r.cd_tipo_destinatario = ne.cd_tipo_destinatario inner join
    Nota_Entrada_Parcela nep on nep.cd_nota_entrada = ne.cd_nota_entrada and
                                nep.cd_fornecedor = ne.cd_fornecedor and
                                nep.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                nep.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal left outer join
    Documento_Pagar dp on dp.cd_documento_pagar = nep.cd_documento_pagar left outer join
    (select cd_documento_pagar, min(dt_pagamento_documento) as dt_pagamento_documento 
     from Documento_pagar_pagamento group by cd_documento_pagar) dpp on dpp.cd_documento_pagar = nep.cd_documento_pagar inner join
    Operacao_Fiscal op on op.cd_operacao_fiscal = ne.cd_operacao_fiscal 
  where 
    op.ic_servico_operacao = 'S' and 
    isnull(dpp.dt_pagamento_documento,isnull(dp.dt_vencimento_documento, nep.dt_parcela_nota_entrada)) between @dt_inicio and @dt_final and
    not exists(select 'x' from #Retencao 
               where ne.cd_nota_entrada = cd_nota_entrada and ne.cd_fornecedor = cd_fornecedor and
                     ne.cd_operacao_fiscal = cd_operacao_fiscal and ne.cd_serie_nota_fiscal = cd_serie_nota_fiscal and
                     dp.cd_documento_pagar = cd_documento_pagar and  
                     ic_imposto = r.ic_imposto)
  order by
    ne.dt_receb_nota_entrada, isnull(r.ic_imposto,'A') desc

  open cExecutarGerarDIRF

  fetch next from cExecutarGerarDIRF into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb, @Imposto

  while @@fetch_status = 0
  begin

    print('NF '+cast(@NotaEntrada as varchar)+
          ' Fornecedor '+cast(@Fornecedor as varchar)+
          ' Serie '+cast(@Serie as varchar)+
          ' CFOP '+cast(@CFOP as varchar)+
          ' Receb '+cast(@Receb as varchar))

    exec dbo.pr_gerar_doctos_pagar_retencao 1, @NotaEntrada, @Fornecedor, @CFOP, @Serie, @cd_usuario, NULL, 'N', 'S', @Imposto

    fetch next from cExecutarGerarDIRF into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb, @Imposto

  end

  close cExecutarGerarDIRF
  deallocate cExecutarGerarDIRF

end


