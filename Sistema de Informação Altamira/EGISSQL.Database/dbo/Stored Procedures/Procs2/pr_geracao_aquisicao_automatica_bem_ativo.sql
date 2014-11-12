
-----------------------------------------------------------------------------------
--pr_geracao_aquisicao_automatica_bem_ativo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : SAF2003
--Objetivo         : Ativo Fixo
--                   Geração Automática de Bens do Ativo Fixo, a partir do Recebimento
--                   Notas Fiscais de entrada / item / Operação fiscal
--
--Data             : 09.08.2005
--Alteração        : 09.08.2005
--                 : 25.04.2006 - Término do desenvolvimento - Carlos Fernandes
--                   
-----------------------------------------------------------------------------------
create procedure pr_geracao_aquisicao_automatica_bem_ativo
@ic_parametro       int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@vl_teto_ativo_fixo float    = 0,
@cd_usuario         int      = 0
as

--Operacao fiscal

--select ic_ativo_operacao_fiscal,* from operacao_fiscal
--select * from nota_entrada  
--select * from nota_entrada_item
--select * from bem
--select * from valor_bem
--select cd_departamento,* from pedido_compra

declare @Tabela     varchar(50)
declare @cd_bem     int
declare @cd_aux_bem int

-- Nome da Tabela usada na geração e liberação de códigos
set @Tabela = cast(DB_NAME()+'.dbo.bem' as varchar(50))


--select * from grupo_bem
--select * from bem

select

  --Bem
  --Rotina de Busca Código Automático

  identity(int,1,1)           as cd_bem,
  ine.nm_produto_nota_entrada as nm_bem,
  cast('' as varchar )        as ds_bem,
  cast('' as varchar )        as nm_mascara_bem,
  case when isnull(cf.cd_grupo_bem,0)>0            
       then cf.cd_grupo_bem
       else 0 
  end                         as cd_grupo_bem,
  ine.qt_item_nota_entrada    as qt_bem,
  0                           as cd_plano_conta,
  pc.cd_centro_custo,
  1                           as cd_status_bem,
  0                           as cd_localizacao_bem,
  0                           as cd_tipo_reavaliacao,
  0                           as cd_apolice_seguro,
  ne.dt_nota_entrada          as dt_inicio_uso_bem,
  null                        as dt_garantia_bem,
  cast('' as varchar )        as nm_marca_bem,
  cast('' as varchar )        as nm_modelo_bem, 
  cast('' as varchar )        as nm_serie_bem,
  cast('' as varchar )        as cd_patrimonio_bem,
  0                           as cd_area_risco,
  dbo.fn_empresa()            as cd_empresa,
  ine.cd_item_nota_entrada    as cd_item_bem,
  cast('' as varchar )        as cd_subitem_bem,
  @cd_usuario                 as cd_usuario,
  getdate()                   as dt_usuario,
  ne.dt_nota_entrada          as dt_aquisicao_bem,
  ne.cd_nota_entrada,
  ne.cd_fornecedor,
  ne.cd_serie_nota_fiscal,
  ine.cd_item_nota_entrada,
  ine.qt_item_nota_entrada,
  cast('' as varchar )        as nm_obs_item,
  pc.cd_departamento,
  1                           as cd_turno,
  null                        as cd_tipo_baixa_bem,
  null                        as dt_baixa_bem,
  ne.cd_operacao_fiscal

  --Valor Bem

  ( ine.qt_item_nota_entrada * ine.vl_item_nota_entrada )        as vl_original_bem,
  1                                                              as cd_moeda,
  0.00                                                           as vl_cor_acumulada_bem,
  0.00                                                           as vl_deprec_acumulada_bem,
  0.00                                                           as qt_original_bem,
  case when isnull(gb.pc_depreciacao_grupo_bem,0)>0.00
  then gb.pc_depreciacao_grupo_bem
  else 0.00
  end                                                            as pc_depreciacao_bem,
  0.00                                                           as pc_deprec_acelerada_bem,
  ( ine.qt_item_nota_entrada * ine.vl_item_nota_entrada )        as vl_mercado_bem,
  0.00                                                           as vl_residual_bem,
  0.00                                                           as vl_lucro_bem,
  0.00                                                           as qt_residual_bem,
  0.00                                                           as qt_lucro_bem,  
  0.00                                                           as pc_plano_conta_depreciacao,
  0.00                                                           as pc_depreciado_bem,
  100                                                            as pc_saldo_depreciacao_bem,
  0.00                                                           as vl_maximo_seguro_bem,
  48                                                             as qt_mes_apuracao_bem,
  isnull(ine.vl_icms_nota_entrada,ine.vl_icms_ciap_nota_entrada) as vl_icms_bem,
  isnull(ine.vl_ipi_nota_entrada,ine.vl_ipi_apura_nota_entrada)  as vl_ipi_bem

into
  #Bem
  
from
  Nota_Entrada ne 
  inner join Nota_Entrada_item ine        on ine.cd_fornecedor          = ne.cd_fornecedor       and
                                             ine.cd_nota_entrada        = ne.cd_nota_entrada     and
                                             ine.cd_operacao_fiscal     = ne.cd_operacao_fiscal  and
                                             ine.cd_serie_nota_fiscal   = ne.cd_serie_nota_fiscal 
  left outer join Operacao_Fiscal opf     on opf.cd_operacao_fiscal     = ine.cd_operacao_fiscal 
  left outer join Pedido_Compra pc        on pc.cd_pedido_compra        = ine.cd_pedido_compra
  left outer join Classificacao_Fiscal cf on cf.cd_classificacao_fiscal = ine.cd_classificacao_fiscal
  left outer join Grupo_Bem gb            on gb.cd_grupo_bem            = cf.cd_grupo_bem
where
  isnull(ine.cd_bem,0)=0 and
  ne.dt_nota_entrada between @dt_inicial and @dt_final and
  isnull(opf.ic_ativo_operacao_fiscal,'N')='S'         
  --and ne.vl_total_nota_entrada >= case when isnull(@vl_teto_ativo_fixo,0)>0 then ne.vl_total_nota_entrada end 

order by
  ne.vl_total_nota_entrada desc

--select * from #bem

--Cadastro dos bens no Ativo Fixo

while exists ( select top 1 cd_bem from #bem order by cd_bem )
begin
  select 
    top 1 
    @cd_aux_bem = cd_bem
  from 
    #bem 
  order by 
    cd_bem

   --Gera o Código do Bem

     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_bem', @codigo = @cd_bem output

   --Executa o Cadastro do Bem
    
--     insert into bem
--        values
--        select
--          @cd_bem
--        from
       


   --Deleta o Código do Bem
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_bem, 'D'   


   --delete o registro
   
   delete from #bem 
   where
      cd_bem = @cd_aux_bem

end

--select * from #bem


--select * from classificacao_fiscal
--select cd_classificacao_fiscal,* from nota_entrada_item
