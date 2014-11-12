
CREATE VIEW dbo.vw_gera_arquivo_pedido_importacao_item
AS

--select sg_pais_imp_empresa,* from egisadmin.dbo.empresa

Select
--       '98046'                                                   as 'CodigoSubsidiaria',
      e.sg_pais_imp_empresa                                      as 'CodigoSubsidiaria',
       '00'                                                      as 'CodigoFilial',
       'D'                                                       as 'CodigoDetalhe',
       Right('000' + Cast(pii.cd_item_ped_imp as VarChar),3)     as 'Item',
       Cast(pii.nm_fantasia_produto as VarChar(30))              as 'NumeroModelo',
       Right('0000000' + Cast(pii.qt_item_ped_imp as VarChar),7) as 'Quantidade',
       Cast('' as VarChar(9))                                    as 'PrecoFob',
       Cast('' as VarChar(4))                                    as 'CodigoProduto',
       Cast('' as VarChar(24))                                   as 'Nota',
       Cast('' as VarChar(10))                                   as 'NumeroPrateleira',
       Case
         When IsNull(p.ic_bem_ind_acessorio_prod,'N') = 'S' 
           Then 'P'
         Else ''
       End                                                       as 'EmbalagemIndividual',
       pii.cd_pedido_importacao,
       pii.nm_item_obs_ped_imp                                   as 'Observacao',
       
       (case when isnull(p.cd_fase_produto_baixa,0)>0
       then
        p.cd_fase_produto_baixa
       else 
        pc.cd_fase_produto end )                                as 'cd_fase_produto',
       dbo.fn_produto_localizacao(pii.cd_produto, 
       (case when isnull(p.cd_fase_produto_baixa,0)>0
       then
        p.cd_fase_produto_baixa
       else 
        pc.cd_fase_produto end ) )                                as 'localizacao'
From
  Pedido_Importacao_Item pii              with (nolock)
  left outer join egisadmin.dbo.Empresa e with (nolock) on (e.cd_empresa = dbo.fn_empresa())             
  Left outer join Produto p               with (nolock) on (p.cd_produto = pii.cd_produto)
  left outer join Parametro_Comercial pc  with (nolock) on (pc.cd_empresa = dbo.fn_empresa())

