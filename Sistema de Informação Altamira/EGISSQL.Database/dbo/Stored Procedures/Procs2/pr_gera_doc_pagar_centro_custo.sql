
CREATE PROCEDURE pr_gera_doc_pagar_centro_custo
------------------------------------------------------------------
--pr_gera_doc_pagar_centro_custo
------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------
--Stored Procedure  : Microsoft SQL Server 2000
--Autor(es)         : Daniel C. Neto.
--Banco de Dados    : EGISSQL 
--Objetivo          : Geração de Centro de Custo Rateado para Documento a Pagar
--Data              : 19/10/2006
--Atualização       : 06/11/2006 - alterado para 6 casas decimais - Daniel C Neto
-- 21.11.2007 - Verificação para Rateio Automático do Recebimento/Nota Entrada - Carlos Fernandes
---------------------------------------------------------------------------------------------------
@cd_documento         int,
@cd_nota_entrada      int,
@cd_fornecedor        int,
@cd_operacao_fiscal   int,
@cd_serie_nota_fiscal int,
@cd_usuario int

as


delete from documento_pagar_centro_custo where cd_documento_pagar = @cd_documento

select 
  identity(int,1,1)             as cd_chave,
  @cd_documento                 as cd_documento_pagar,
  nei.cd_centro_custo,
  0                             as cd_item_centro_custo,
  cast((vl_total_nota_entr_item * 100 ) / vl_total_nota_entrada as decimal(25,6)) as pc_centro_custo,
  cast((( cast((vl_total_nota_entr_item * 100 ) / vl_total_nota_entrada as decimal(25,6)) ) / 100 ) *
    dp.vl_documento_pagar  as decimal(25,2)) 
                                as vl_centro_custo,
  @cd_usuario                   as cd_usuario,
  Getdate()                     as dt_usuario
into #DocPagar
from 
  nota_entrada_item nei inner join
  nota_entrada ne on       ne.cd_nota_entrada      = nei.cd_nota_entrada and
			   ne.cd_fornecedor        = nei.cd_fornecedor and
			   ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
			   ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal inner join
  Documento_Pagar dp on    dp.cd_documento_pagar = @cd_documento
where
  ne.cd_nota_entrada      = @cd_nota_entrada and
  ne.cd_fornecedor        = @cd_fornecedor and
--  ne.cd_operacao_fiscal   = @cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
  IsNull(nei.cd_centro_custo,0) <> 0 

declare @cd_chave              int
declare @cd_item_documento     int
declare @cd_documento_anterior int

set @cd_item_documento = 0 
set @cd_documento_anterior = 0 

while exists ( select top 1 'x' from #DocPagar )
begin

  if @cd_documento_anterior = ( select top 1 cd_documento_pagar from #DocPagar order by cd_documento_pagar)
    set @cd_item_documento = @cd_item_documento + 1
  else
    set @cd_item_documento = 1

  print @cd_item_documento

  insert into Documento_Pagar_Centro_custo
    ( cd_documento_pagar, cd_centro_custo, cd_item_centro_custo, pc_centro_custo,
      vl_centro_custo, cd_usuario, dt_usuario, cd_item_documento )
  select top 1 
    cd_documento_pagar,
    cd_centro_custo,
    cd_item_centro_custo,
    pc_centro_custo,
    vl_centro_custo,
    cd_usuario,
    dt_usuario,
    @cd_item_documento
  from 
    #DocPagar
  order by cd_documento_pagar

  select  top 1 
    @cd_chave              = cd_chave,
    @cd_documento_anterior = cd_documento_pagar
  from 
    #DocPagar 
  order by 
    cd_documento_pagar 

  delete from #DocPagar where cd_chave = @cd_chave

end

-- Verificando diferenças de arrendondamento e colocando no ultimo item do rateio.

declare @pc_diferenca float
declare @vl_diferenca float

select 
   @pc_diferenca      = 100 - sum(pc_centro_custo),
   @vl_diferenca      = max(dp.vl_documento_pagar) - sum(vl_centro_custo),
   @cd_item_documento = max(cd_item_documento)
from 
  documento_pagar dp inner join
  documento_pagar_centro_custo dpc on dpc.cd_documento_pagar = dp.cd_documento_pagar
where 
  dp.cd_documento_pagar = @cd_documento

update documento_pagar_centro_custo
set 
  pc_centro_custo = pc_centro_custo + @pc_diferenca,
  vl_centro_custo = vl_centro_custo + @vl_diferenca
where
  cd_documento_pagar = @cd_documento and
  cd_item_documento  = @cd_item_documento

--------------------------------



