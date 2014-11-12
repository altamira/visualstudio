
--sp_helptext pr_resumo_local_apuracao_pis_cofins_depreciacao

-------------------------------------------------------------------------------
--pr_resumo_local_apuracao_pis_cofins_depreciacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do Pis/Cofins - Depreciação
--Data             : 28.04.2007
--Alteração        : 17.05.2007

------------------------------------------------------------------------------
create procedure pr_resumo_local_apuracao_pis_cofins_depreciacao
@dt_inicial datetime = '',
@dt_final   datetime = ''


as

--select cd_localizacao_bem,* from bem
--select * from localizacao_bem
--select * from tipo_bem
--select * from centro_custo
--select * from valor_bem
--select * from valor_bem_fechamento

--Buscar da Tabela de Imposto / Imposto_Aliquota

declare @pc_pis    decimal(25,4)
declare @pc_cofins decimal(25,4)

set @pc_pis    = cast((1.65/100) as decimal(25,4))
set @pc_cofins = cast((7.60/100) as decimal(25,4))

--select @pc_pis,@pc_cofins

select
  cc.cd_mascara_centro_custo,
  cc.nm_centro_custo,
  tb.nm_tipo_bem,

  Sum( case when isnull(tb.ic_pis_cofins_tipo_bem,'N') = 'S' 
  then
     --vbf.vl_depreciacao_bem * (isnull(cc.pc_producao_ativo,0)/100) 
     (case when isnull(vb.pc_producao_bem,0)>0   
     then  
       vb.pc_producao_bem  
     else  
       cc.pc_producao_ativo end  / 100 ) * isnull(vbf.vl_depreciacao_bem,0)
  else
     0.00 
  end )                                                             as somaproducao,

  Sum( case when isnull(vb.pc_producao_bem,0)>0   
  then  
    vb.pc_producao_bem  
  else  
    cc.pc_producao_ativo 
  end )                                                            as pc_producao_ativo,  
  
  Sum( isnull(vbf.vl_depreciacao_bem,0))                           as depreciacao,
  
  Sum( vbf.vl_depreciacao_bem *
      (case when isnull(vb.pc_producao_bem,0)>0
      then vb.pc_producao_bem
      else cc.pc_producao_ativo end /100) * @pc_cofins )           as cofins,
  
  Sum( vbf.vl_depreciacao_bem *
       (case when isnull(vb.pc_producao_bem,0)>0
      then vb.pc_producao_bem
      else cc.pc_producao_ativo end /100) * @pc_pis )              as pis,  
  
  Sum( vbf.vl_depreciacao_bem *   
      (case when isnull(vb.pc_producao_bem,0)>0   
      then vb.pc_producao_bem   
      else cc.pc_producao_ativo end /100) * @pc_cofins +  
  
       vbf.vl_depreciacao_bem *   
      (case when isnull(vb.pc_producao_bem,0)>0   
      then vb.pc_producao_bem   
      else cc.pc_producao_ativo end /100) * @pc_pis )              as Credito  

from
  bem b                                    with (nolock) 
  inner join Centro_Custo cc               with (nolock) on cc.cd_centro_custo    = b.cd_centro_custo
  left join Valor_Bem vb                   with (nolock) on vb.cd_bem             = b.cd_bem  
  left outer join Tipo_Bem tb              with (nolock) on tb.cd_tipo_bem        = b.cd_tipo_bem
  left outer join Valor_Bem_Fechamento vbf with (nolock) on vbf.dt_bem_fechamento = @dt_final and
                                                            vbf.cd_bem            = b.cd_bem
  left outer join Localizacao_Bem lb       with (nolock) on lb.cd_localizacao_bem = b.cd_localizacao_bem
where
  isnull(vbf.vl_depreciacao_bem,0)>0  
  --and b.cd_centro_custo = 760

group by
  tb.nm_tipo_bem,
  cc.cd_mascara_centro_custo,
  cc.nm_centro_custo
order by
  tb.nm_tipo_bem,
  cc.cd_mascara_centro_custo,
  cc.nm_centro_custo
