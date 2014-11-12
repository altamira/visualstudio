
-----------------------------------------------------------------------------------
--pr_apuracao_pis_cofins_bens_deprecicacao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : SAF2003
--Objetivo         : Ativo Fixo
--                   Apuracação de PIS/COFINS de Bens do Ativo Permanente - 
--                   da Máquina.
--
--Data             : 09.08.2005
--Alteração        : 09.08.2005
--                 : 31.01.2007 - Verificação de quais bens deve ser apurados
--                   
-----------------------------------------------------------------------------------
create procedure pr_apuracao_pis_cofins_bens_deprecicacao
@cd_grupo_bem int,
@dt_inicial   datetime,
@dt_final     datetime
as

--select * from grupo_bem
--select * from bem
--select * from valor_bem
--select * from ciap

select
   b.cd_bem,                        
  gb.nm_grupo_bem                  as GrupoBem,
   b.nm_bem                        as Bem,
   b.cd_patrimonio_bem             as Patrimonio,
   b.nm_mascara_bem                as Codigo,  
   b.dt_aquisicao_bem              as DataAquisicao,
   b.dt_inicio_uso_bem                                           as InicioUso,
   vb.vl_original_bem                                            as ValorAquisicao,
   isnull(vb.vl_icms_bem,0)                                      as Icms,
   isnull(vb.vl_ipi_bem,0)                                       as IPI,

   (vb.vl_original_bem-isnull(vb.vl_icms_bem,0))                 as ValorLiquidoICMS,
   vb.vl_original_bem*(1.65/100)                                 as PIS,
   vb.vl_original_bem*(7.6/100)                                  as COFINS,
   vb.vl_original_bem-
   
   --Valor do ICMS

   case when isnull(vb.vl_icms_bem,0)>0 then
       isnull(vb.vl_icms_bem,0)
   else
     --Busca ICMS no CIAP
     isnull((select sum(c.vl_icms_ciap) from Ciap c where c.cd_bem = vb.cd_bem ),0)
   end 
  -(
   (vb.vl_original_bem*(1.65/100))+

   (vb.vl_original_bem*(7.6/100)))   as ValorLiquido,  

   isnull(vb.qt_mes_apuracao_bem,0)  as Meses,
    b.dt_baixa_bem                   as DataBaixa,
   tp.nm_tipo_baixa_bem              as BaixaBem,
   gb.pc_depreciacao_grupo_bem       as TaxaDepreciacao,
   f.nm_fantasia_fornecedor          as Fornecedor,
   tm.nm_tipo_mercado                as TipoMercado,
   tb.nm_tipo_bem                    as TipoBem

into
  #Apuracao

from
  bem b
  left outer join Valor_Bem vb      on vb.cd_bem            = b.cd_bem
  left outer join Grupo_Bem gb      on gb.cd_grupo_bem      = b.cd_grupo_bem
  left outer join Fornecedor f      on f.cd_fornecedor      = b.cd_fornecedor
  left outer join Tipo_Mercado tm   on tm.cd_tipo_mercado   = f.cd_tipo_mercado
  left outer join Tipo_Baixa_Bem tp on tp.cd_tipo_baixa_bem = b.cd_tipo_baixa_bem
  left outer join Tipo_Bem       tb on tb.cd_tipo_bem       = b.cd_tipo_bem
where
  @cd_grupo_bem = case when @cd_grupo_bem = 0 then @cd_grupo_bem else b.cd_grupo_bem end and
  b.dt_aquisicao_bem between @dt_inicial and @dt_final and
  isnull(tb.ic_pis_cofins_tipo_bem,'S') = 'S'

--Aprentação dos Valores já Calculando o Saldo

select
  a.*,
  case when isnull(a.Meses,0)>0 then
    a.ValorAquisicao/a.Meses
  else 0.00 end as ValorApurado,

--  ValorApurado = a.ValorAquisicao/a.Meses,

  Parcela = ( select isnull(max(cd_parcela),0) from Bem_Apuracao where cd_bem = a.cd_bem ),
  ValorAquisicao-isnull(((a.ValorAquisicao/isnull(a.Meses,1)) * ( select isnull(max(cd_parcela),0) from Bem_Apuracao where cd_bem = a.cd_bem )),0)  as Saldo
from
  #Apuracao a


