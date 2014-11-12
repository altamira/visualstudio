
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina geradora do livro de entradas para todas as notas apartir
--          da data indicada
--Data: 06/10/2003
--      14/04/2004 - Incluir o período de data e as notas que não foram modificadas pelo fiscal - ALEXANDRE
--      25/08/2006 - Ajuste para buscar corretamente as NFEs não modificadas - ELIAS
-- 29.07.2008 - Notas de Entrada gerada no Faturamento - Carlos Fernandes
-- 09.12.2009 - Verificação da Procedure - Carlos Fernandes
-----------------------------------------------------------------------------------------

create procedure pr_executar_gerar_rem
@dt_inicio  datetime,
@dt_final   datetime,
@cd_usuario int      = 0
as

begin

  declare @NotaEntrada int
  declare @Fornecedor  int
  declare @CFOP        int
  declare @Serie       int
  declare @Receb       datetime

  declare cExecutarGerarRem cursor for
  select distinct
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.dt_receb_nota_entrada
  from
    Nota_Entrada ne                                 with (nolock)  
    left outer join Nota_Entrada_Item_Registro neir on ne.cd_nota_entrada      = neir.cd_nota_entrada and
                                                       ne.cd_fornecedor        = neir.cd_fornecedor and
                                                       ne.cd_operacao_fiscal   = neir.cd_operacao_fiscal and
                                                       ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal
  where isnull(neir.ic_manutencao_fiscal,'N') = 'N' and
    ne.dt_receb_nota_entrada between @dt_inicio and @dt_final
  order by 
    ne.dt_receb_nota_entrada

  open cExecutarGerarRem 

  fetch next from cExecutarGerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  while @@fetch_status = 0
  begin

--     print('NF '         +cast(@NotaEntrada as varchar)+
--           ' Fornecedor '+cast(@Fornecedor as varchar)+
--           ' Serie '     +cast(@Serie as varchar)+
--           ' CFOP '      +cast(@CFOP as varchar)+
--           ' Receb '     +cast(@Receb as varchar))

    exec pr_gerar_rem 1, @NotaEntrada, @Fornecedor, @Serie, @CFOP, @cd_usuario, 'S'

    fetch next from cExecutarGerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  end

  close      cExecutarGerarRem
  deallocate cExecutarGerarRem

  -----------------------------------------------------------------------------------------
  --Notas Fiscais de Entrada Lançadas no Faturamento
  -----------------------------------------------------------------------------------------
  --Importação
  -----------------------------------------------------------------------------------------

  declare cExecutarGerarRem cursor for
  select distinct
    ns.cd_nota_saida as cd_nota_entrada,
    ns.cd_cliente    as cd_fornecedor,
    ns.cd_operacao_fiscal,
    ns.cd_serie_nota as cd_serie_nota_fiscal,
    ns.dt_nota_saida as dt_receb_nota_entrada
  from
    Nota_Saida ns with (nolock) 
    left outer join Nota_Entrada_Item_Registro neir on ns.cd_nota_saida        = neir.cd_nota_entrada       and
                                                       ns.cd_cliente           = neir.cd_fornecedor         and
                                                       ns.cd_operacao_fiscal   = neir.cd_operacao_fiscal    and
                                                       ns.cd_serie_nota        = neir.cd_serie_nota_fiscal

    left outer join Operacao_Fiscal opf             on ns.cd_operacao_fiscal        = opf.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof       on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal

    --select * from operacao_fiscal
    --select * from grupo_operacao_fiscal
    --select * from tipo_operacao_fiscal

  where
    isnull(neir.ic_manutencao_fiscal,'N') = 'N'       and
    ns.dt_nota_saida between @dt_inicio and @dt_final and
    gof.cd_tipo_operacao_fiscal = 1

  order by 
    ns.dt_nota_saida

  open cExecutarGerarRem 

  fetch next from cExecutarGerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  while @@fetch_status = 0
  begin

--     print('NF '+cast(@NotaEntrada as varchar)+
--           ' Fornecedor '+cast(@Fornecedor as varchar)+
--           ' Serie '+cast(@Serie as varchar)+
--           ' CFOP '+cast(@CFOP as varchar)+
--           ' Receb '+cast(@Receb as varchar))

    exec pr_gerar_rem 1, @NotaEntrada, @Fornecedor, @Serie, @CFOP, @cd_usuario

    fetch next from cExecutarGerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  end

  close cExecutarGerarRem
  deallocate cExecutarGerarRem


end

