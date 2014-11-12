
-------------------------------------------------------------------------------
--sp_helptext pr_credito_presumido_importacao
-------------------------------------------------------------------------------
--pr_credito_presumido_importacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : EgisAdmin ou Egissql
--
--Objetivo         : 
--Data             : 01.01.2010
--Alteração        : 30.11.2010
--
--
------------------------------------------------------------------------------
create procedure pr_credito_presumido_importacao

@ic_parametro  int,
@cd_nota_saida int,
@dt_inicial    datetime,
@dt_final      datetime


as

declare @pc_icms_minimo float

set @pc_icms_minimo = 4

--select * from nota_saida
-------------------------------------------------------------------------------
if @ic_parametro = 1     -- Carrega as informações da nota saída
-------------------------------------------------------------------------------
begin 

--   declare @OperPropria float
--   declare @pcMinIcmsDevido float
--   declare @vlMinIcmsdevido float
--   declare @vlOutrosCreditos float 

  select
   ns.dt_nota_saida,
   ns.cd_nota_saida,
   ns.cd_identificacao_nota_saida,
   sn.sg_serie_nota_fiscal, 
   p.cd_mascara_produto,  
   ns.cd_cliente,
   ns.nm_razao_social_nota,
   ns.cd_cnpj_nota_saida,
   ns.sg_estado_nota_saida,
   rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,00) as varchar(2))))                           as 'CST',
   ns.cd_mascara_operacao,
   ns.vl_total,
   ns.vl_bc_icms,
   nsi.nm_fantasia_produto,
   nsi.vl_total_item,    --valor contabil preciso ver qual é o correto   pod ser vl dos produtos =vl_produto
   nsi.vl_base_icms_item,
   nsi.pc_reducao_icms,
   nsi.pc_icms,
   nsi.pc_ipi ,  
   nsi.vl_icms_item,  

   --0.00 as wbase,
   case 
     when nsi.pc_reducao_icms > 0 then
      --(((nsi.vl_base_icms_item * nsi.pc_reducao_icms) / 100) - nsi.vl_base_icms_item)
        nsi.vl_base_icms_item - (((nsi.vl_base_icms_item * nsi.pc_reducao_icms) / 100))
                                                                  
   end as  wbaseicmsreduzida,
   
   
  --Verificar com Cliente a Fórmula de Cálculo----------------------------------------------------------------

--   0.00 as vl_icms_op_propria,
--   4.00 as pc_min_icms_devido,
--   0.00 as vl_min_icms_devido,
--   0.00 as vl_outros_creditos,
  

  
   --Valor do ICMS Próprio
   --case when isnull(nsi.pc_icms,0) > 0 then isnull(nsi.pc_icms,0) else 0.00 end as vl_icms_op_propria,   penso que seja o valor normal de icms nao a porcentagem

   
       
   case when isnull(nsi.pc_icms,0) > 0 then @pc_icms_minimo else 0.00 end       as pc_min_icms_devido, 

   --Valor do ICMS Mínimo

   case when isnull(nsi.pc_icms,0) > 0 then ((@pc_icms_minimo * nsi.vl_base_icms_item) / 100)
   else 0.00
   end                                                                          as vl_min_icms_devido,  


   --Outros Créditos
   case when isnull(nsi.pc_icms,0) > 0 then (((nsi.pc_icms - @pc_icms_minimo) * nsi.vl_base_icms_item) / 100)
   else 0.00
   end                                                                          as vl_outros_creditos    
      
     
   
 


 from

  nota_saida ns with (nolock)
  inner join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  inner join nota_saida_item nsi on nsi.cd_nota_saida      = ns.cd_nota_saida
  inner join produto         p   on p.cd_produto           = nsi.cd_produto
  

  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto                 = nsi.cd_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao               = nsi.cd_tributacao
  left outer join tributacao_icms ti                with (nolock) on ti.cd_tributacao_icms         = t.cd_tributacao_icms
  left outer join serie_nota_fiscal sn              with (nolock) on sn.cd_serie_nota_fiscal       = ns.cd_serie_nota
  left outer join cliente cl                        with (nolock) on cl.cd_cliente                 = ns.cd_cliente
 
 where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
     --isnull(opf.ic_cred_presum_op_fiscal,'N') = 'S'    and
     isnull(p.ic_importacao_produto,'N')      = 'S'     and
     isnull(ns.cd_status_nota,5) <> 7 --nao pode entrar nota cancelada 

   order by
      ns.cd_identificacao_nota_saida asc  -- ns.dt_nota_saida desc
end
 -------------------------------------------------------------------------------
else if @ic_parametro = 2     -- Carrega as informações da nota saída itens
-------------------------------------------------------------------------------
  begin
    select
--      nsi.cd_nota_saida 'Nota Saida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                  as 'Nota Saida',

      nsi.cd_item_nota_saida 'Item',
      nsi.nm_produto_item_nota 'Produto',
      um.sg_unidade_medida 'Unidade',
      nsi.qt_item_nota_saida 'Qtd',
      nsi.vl_unitario_item_nota 'Unitario',
      nsi.vl_total_item 'Total'
    from
      nota_saida_item nsi             with (nolock) 
      inner join nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
      left outer join unidade_medida um on  nsi.cd_unidade_medida = um.cd_unidade_medida
      
    where 
      ns.cd_nota_saida=@cd_nota_saida

    order by nsi.cd_item_nota_saida
  end
else
  return

 

