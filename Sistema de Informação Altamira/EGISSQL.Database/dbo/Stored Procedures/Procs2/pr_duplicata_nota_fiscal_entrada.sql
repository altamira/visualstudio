
------------------------------------------------------------------------------------------
--pr_duplicata_nota_fiscal_entrada
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Eduardo Baião
--Banco de Dados: EGISSQL 
--Objetivo      : Listar as Informações das Duplicatas p/ a Nota Fiscal de Entrada
--                Basea do na "pr_duplicata_nota_fiscal"
--Data          : 07/08/2003
--Atualizado    : 07/08/2003
------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_duplicata_nota_fiscal_entrada
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_fornecedor int,
@cd_nota_fiscal int,
@cd_serie_nota_fiscal int,
@cd_operacao_fiscal int = 0

as

declare @i int
declare @qt_parcela int

  select distinct
     p.cd_ident_parc_nota_entr as 'DUPLICATA',
     convert(varchar,p.dt_parcela_nota_entrada,3) as 'VENCIMENTO',
     p.vl_parcela_nota_entrada as 'VLDUPLICATA',
     cast(null as varchar(25)) as 'DUPLICATA2',
     cast(null as varchar) as 'VENCIMENTO2',
     cast(null as float) as 'VLDUPLICATA2',
     cast(null as varchar(25)) as 'DUPLICATA3',
     cast(null as varchar) as 'VENCIMENTO3',
     cast(null as float) as 'VLDUPLICATA3'

  into
     #Nota_Entrada_Parcela_Padrao
  from
     Nota_Entrada_Parcela p left outer join
     Nota_Entrada         n on n.cd_nota_entrada = p.cd_nota_entrada and 
							p.cd_fornecedor=n.cd_fornecedor and 
							p.cd_operacao_fiscal=n.cd_operacao_fiscal and
							p.cd_serie_nota_fiscal=n.cd_serie_nota_fiscal
  where
     p.cd_fornecedor = @cd_fornecedor and
     p.cd_nota_entrada = @cd_nota_fiscal and
     p.cd_serie_nota_fiscal = @cd_serie_nota_fiscal -- and
--     p.cd_operacao_fiscal = @cd_operacao_fiscal 
and
     p.cd_parcela_nota_entrada = 1


  if exists(select * from Nota_Entrada_Parcela
            where cd_fornecedor = @cd_fornecedor and
                  cd_nota_entrada = @cd_nota_fiscal and
                  cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
--                  cd_operacao_fiscal = @cd_operacao_fiscal and
                  cd_parcela_nota_entrada > 1) begin

     update
        #Nota_Entrada_Parcela_Padrao
     set
        DUPLICATA2      = p.cd_ident_parc_nota_entr,
        VENCIMENTO2     = convert(varchar,p.dt_parcela_nota_entrada,3),
        VLDUPLICATA2    = p.vl_parcela_nota_entrada
     from
        Nota_Entrada_Parcela p
     where
        p.cd_fornecedor = @cd_fornecedor and
        p.cd_nota_entrada         = @cd_nota_fiscal  and
        p.cd_serie_nota_fiscal    = @cd_serie_nota_fiscal and
--        p.cd_operacao_fiscal = @cd_operacao_fiscal and
        p.cd_parcela_nota_entrada = 2

  end

  if exists(select * from Nota_Entrada_Parcela
            where cd_fornecedor = @cd_fornecedor and
                  cd_nota_entrada = @cd_nota_fiscal and
                  cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
--                  cd_operacao_fiscal = @cd_operacao_fiscal and
                  cd_parcela_nota_entrada > 2) begin

     update
        #Nota_Entrada_Parcela_Padrao
     set
        DUPLICATA3      = p.cd_ident_parc_nota_entr,
        VENCIMENTO3     = convert(varchar,p.dt_parcela_nota_entrada,3),
        VLDUPLICATA3    = p.vl_parcela_nota_entrada
     from
        Nota_Entrada_Parcela p
     where
        p.cd_fornecedor = @cd_fornecedor and
        p.cd_nota_entrada         = @cd_nota_fiscal  and
        p.cd_serie_nota_fiscal    = @cd_serie_nota_fiscal and
--        p.cd_operacao_fiscal = @cd_operacao_fiscal and
        p.cd_parcela_nota_entrada = 3

  end

  select
     DUPLICATA,
     VENCIMENTO,
     VLDUPLICATA,
     DUPLICATA2,
     VENCIMENTO2,
     VLDUPLICATA2,
     DUPLICATA3,
     VENCIMENTO3,
     VLDUPLICATA3

  from
     #Nota_Entrada_Parcela_Padrao

  drop table #Nota_Entrada_Parcela_Padrao

