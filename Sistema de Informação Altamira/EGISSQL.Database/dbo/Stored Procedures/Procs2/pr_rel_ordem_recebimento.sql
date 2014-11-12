
-------------------------------------------------------------------------------  
--sp_helptext pr_rel_ordem_recebimento  
-------------------------------------------------------------------------------  
--pr_documentacao_padrao  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2009  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Douglas de Paula Lopes  
--Banco de Dados   : Egissql  
--
--Objetivo         : Consulta/Impressão da Ordem de Recebimento
--  
--Data             : 15.12.2008  
--Alteração        :   
--  
-- 18.03.2009 - Pedido de Venda/Item - Carlos Fernandes  
-- 05.10.2009 - Laudo no Item da Ordem de Recebimento - Carlos Fernandes
-- 13.05.2010 - Ajustes na Procedure - Dados do Cliente - Carlos Fernandes
-- 01.09.2010 - Nome do Usuário que lançou a Nota de Entrada - Carlos Fernandes
-- 04.10.2010 - Descrição do Produto Especial - Carlos Fernandes
------------------------------------------------------------------------------  
create procedure pr_rel_ordem_recebimento  
@dt_inicial           datetime,  
@dt_final             datetime,  
@ic_parametro         int = 0,  
@cd_nota_entrada      int = 0,  
@cd_fornecedor        int = 0,  
@cd_operacao_fiscal   int = 0,  
@cd_serie_nota_fiscal int = 0  
as  
  
if @ic_parametro = 1   
  begin  

    --Atualiza o Laudo no Item da Nota de Entrada

   update 
     Nota_Entrada_item
   set
     cd_laudo = l.cd_laudo
   from
     nota_entrada_item ni
     inner join Laudo l on l.cd_nota_entrada           = ni.cd_nota_entrada      and  
                           l.cd_fornecedor             = ni.cd_fornecedor        and  
                           --l.cd_serie_nota_fiscal      = ni.cd_serie_nota_fiscal and  
                           --l.cd_operacao_fiscal        = ni.cd_operacao_fiscal   and
                           l.cd_item_nota_entrada      = ni.cd_item_nota_entrada

   where
     ni.cd_nota_entrada           = @cd_nota_entrada      and  
     ni.cd_fornecedor             = @cd_fornecedor        and  
     ni.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and  
     ni.cd_operacao_fiscal        = @cd_operacao_fiscal   and
     isnull(ni.cd_laudo,0)=0 and
     isnull(l.cd_laudo,0)>0

  --select * from 
------------------------------------------------------------------------------  
--ic_parametro = 1 - Seleciona os itens da nota de entrada  
------------------------------------------------------------------------------  
    select  
      isnull(pci.cd_plano_compra,pc.cd_plano_compra)      as cd_mapa_compra,    
      pl.cd_mascara_plano_compra+' - '+pl.sg_plano_compra as sg_plano_compra,   
      ap.sg_aplicacao_produto,  
      p.cd_mascara_produto,   
      p.nm_fantasia_produto,  

      case when isnull(ni.nm_produto_nota_entrada,'')<>'' then
        ni.nm_produto_nota_entrada
      else
        p.nm_produto
      end                                                 as nm_produto,
 
      isnull(ni.cd_mascara_classificacao, cf.cd_mascara_classificacao) as cd_mascara_classificacao,  
      op.cd_mascara_operacao,  
      op.ic_servico_operacao,  
      un.sg_unidade_medida,  
      un.ic_fator_conversao,   
      pci.qt_saldo_item_ped_compra,   
  
      case when isnull(pci.cd_pedido_compra,0)>0 then
         ltrim(rtrim(cast(pci.cd_pedido_compra as varchar)))+'-'+ltrim(rtrim(cast(pci.cd_item_pedido_compra as varchar)))
      else
        ''
      end                                    as nm_pedido_compra,

      pci.cd_pedido_venda,  
      pci.cd_item_pedido_venda,  
      case when isnull(pci.cd_pedido_venda,0)>0 then
         ltrim(rtrim(cast(pci.cd_pedido_venda as varchar)))+'-'+ltrim(rtrim(cast(pci.cd_item_pedido_venda as varchar)))
      else
        ''
      end                                    as nm_pedido_venda,
      pc.ic_pedido_gerado_autom,  
      isnull(op.ic_estoque_op_fiscal,'N')    as ic_estoque_op_fiscal,  
      isnull(p.ic_estoque_inspecao_prod,'N') as ic_estoque_inspecao_prod,  
      isnull(poc.ic_estoque_produto,'N')     as ic_estoque_produto,  
      isnull(poc.ic_deducao_imposto,'N')     as ic_deducao_imposto,  
      isnull(p.ic_guia_trafego_produto,'N')  as ic_guia_trafego_produto,  
      pc.cd_destinacao_produto,   
  
      case when isnull(p.cd_produto_baixa_estoque,0) >0 then  
        isnull(p.cd_produto_baixa_estoque,0)  
      else  
        isnull(p.cd_produto,0)  
      end                                                                  as cd_produto_baixa,  
  
     (case when isnull(me.vl_custo_contabil_produto,0)>0 then  
        isnull(me.vl_custo_contabil_produto,0) * ni.qt_item_nota_entrada  
      else  
        ni.vl_custo_nota_entrada   
      end)                                                                 as 'VlrCusto',  
  
     (case when isnull(me.vl_custo_contabil_produto,0)>0 then  
        isnull(me.vl_custo_contabil_produto,0)  
     else  
        ni.vl_total_nota_entr_item/ni.qt_item_nota_entrada  
     end)                                                                  as 'VlrCustoUnitario',  
  
     isnull(f.nm_fase_produto,'Sem Definição')                          as nm_fase_produto,   
     isnull(ni.cd_fase_produto,me.cd_fase_produto)                      as cd_fase_produto,  
     pci.pc_icms                                                        as pc_icms_pedido_compra,  
     pci.pc_ipi                                                         as pc_ipi_pedido_compra,  
     case when isnull(p.cd_produto,0) = 0 then 'S' else p.ic_especial_produto end as ic_especial_produto,  
     ni.*,  
     umc.sg_unidade_medida as sg_unidade_destino,   
     pci.dt_entrega_item_ped_compr
     

     --pci.cd_pedido_venda,
     --pci.cd_item_pedido_venda  

  from   
     Nota_Entrada_Item ni with (nolock)   
     left outer join (select distinct   
                        a.cd_fornecedor,   
                        a.cd_documento_movimento,   
                        a.cd_operacao_fiscal,  
                        a.cd_serie_nota_fiscal,   
                        a.cd_item_documento,   
                        a.cd_fase_produto as cd_fase_produto,  
                        a.vl_custo_contabil_produto  
                      from   
                        Movimento_Estoque a with(nolock)  
                      where   
                        a.cd_movimento_estoque in ( select   
                                                      min(b.cd_movimento_estoque)  
                                                    from   
                                                      Movimento_Estoque b with(nolock)  
                                                    where   
                                                      b.cd_fornecedor          = @cd_fornecedor                    and  
                                                      b.cd_documento_movimento = cast(@cd_nota_entrada as varchar) and  
                                                      b.cd_operacao_fiscal     = @cd_operacao_fiscal               and  
                                                      b.cd_serie_nota_fiscal   = @cd_serie_nota_fiscal             and  
                                                      b.cd_item_documento      = a.cd_item_documento)              and   
                                                      a.cd_documento_movimento = cast(@cd_nota_entrada as varchar) and  
                                                      a.cd_fornecedor          = @cd_fornecedor                    and  
                                                      a.cd_operacao_fiscal     = @cd_operacao_fiscal               and  
                                                      a.cd_serie_nota_fiscal   = @cd_serie_nota_fiscal)   
  
                                          me               on me.cd_item_documento       = ni.cd_item_nota_entrada   
     left outer join Produto              p   with(nolock) on ni.cd_produto              = p.cd_produto  
     left outer join Produto_Custo        poc with(nolock) on p.cd_produto               = poc.cd_produto  
     left outer join Classificacao_Fiscal cf  with(nolock) on cf.cd_classificacao_fiscal = ni.cd_classificacao_fiscal  
     left outer join Operacao_Fiscal      op  with(nolock) on op.cd_operacao_fiscal      = ni.cd_operacao_fiscal  
     left outer join Unidade_Medida       un  with(nolock) on ni.cd_unidade_medida       = un.cd_unidade_medida  
     left outer join Unidade_Medida       umc with(nolock) on ni.cd_unidade_destino      = umc.cd_unidade_medida  
     left outer join Pedido_Compra        pc  with(nolock) on pc.cd_pedido_compra        = ni.cd_pedido_compra  
     left outer join Pedido_Compra_Item   pci with(nolock) on pci.cd_item_pedido_compra  = ni.cd_item_pedido_compra and  
                                                              pci.cd_pedido_compra       = ni.cd_pedido_compra  
     left outer join Plano_compra         pl with(nolock)  on pl.cd_plano_compra         = isnull(pci.cd_plano_compra,pc.cd_plano_compra)  
     left outer join Aplicacao_Produto    ap with(nolock)  on ap.cd_aplicacao_produto    = pc.cd_aplicacao_produto  
     left outer join Fase_Produto         f  with(nolock)  on f.cd_fase_produto          = me.cd_fase_produto  

--      left outer join Laudo               l   with(nolock)  on l.cd_nota_entrada          = ni.cd_nota_entrada      and
--                                                               l.cd_item_nota_entrada     = ni.cd_item_nota_entrada and                     
--                                                               l.cd_fornecedor            = ni.cd_fornecedor        and
--                                                               l.cd_serie_nota_fiscal     = ni.cd_serie_nota_fiscal and
--                                                               l.cd_operacao_fiscal       = ni.cd_operacao_fiscal
  --select * from laudo

  where   
     ni.cd_nota_entrada           = @cd_nota_entrada and  
     ni.cd_fornecedor             = @cd_fornecedor and  
     ni.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and  
     ni.cd_operacao_fiscal        = @cd_operacao_fiscal  and  
     ni.ic_tipo_nota_entrada_item = 'P'  

  order by   
     ni.cd_item_nota_entrada  
  end  

else if @ic_parametro = 2  
  begin  
------------------------------------------------------------------------------  
--ic_parametro = 2 - Seleciona as notas de entrada  
------------------------------------------------------------------------------  
    select top 1  
  
      case when n.cd_tipo_destinatario = 1 then  
        (select isnull(rtrim(ltrim(cast(cd_ddd as varchar(5)))),'') + ' ' + isnull(rtrim(ltrim(cast(cd_telefone as varchar(20)))),'') from cliente where cd_cliente = n.cd_fornecedor)  
      else   
        case when n.cd_tipo_destinatario = 2 then  
          (select isnull(rtrim(ltrim(cast(cd_ddd as varchar(5)))),'') + ' ' + isnull(rtrim(ltrim(cast(cd_telefone as varchar(20)))),'') from fornecedor where cd_fornecedor = n.cd_fornecedor)  
        end   
      end      as Telefone,  
  
      (select nm_tipo_transporte from Tipo_Transporte where cd_tipo_transporte = t.cd_tipo_transporte) as 'ViaTransporte',  
  
      n.cd_nota_entrada,  
  
      (select  
        count(*)  
      from  
        Nota_Entrada_Parcela ne with (nolock)  
      where  
        ne.cd_nota_entrada = n.cd_nota_entrada and
        ne.cd_fornecedor   = n.cd_fornecedor   and
        ne.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal) as qt_parcelas,  
  
      (select   
         count(*)   
       from   
         nota_entrada_item x  
       where   
         x.cd_nota_entrada = n.cd_nota_entrada and 
         x.cd_fornecedor   = n.cd_fornecedor   and
         x.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal ) as qt_item_nota,  
  
      n.sg_estado,  
      sn.nm_status_nota,  
      n.qt_bruto_nota_entrada,  
      n.ic_provisao_nota_entrada,  
      n.qt_liquido_nota_entrada,  
      n.ic_emitida_nota_entrada,  
      n.vl_desconto_nota_entrada,  
      n.ic_reter_iss,  
      tp.nm_tipo_pagamento_frete,   
      t.cd_transportadora,  
      t.nm_transportadora as nm_transportadora,  
      t.nm_endereco as nm_endereco_transp,  
      t.cd_numero_endereco as cd_numero_endereco_transp,   
      t.nm_bairro as nm_bairro_transp,  
      t.cd_cep as cd_cep_transp,  
      isnull((select nm_cidade from cidade where cd_cidade = t.cd_cidade),'') as cidade_transp,  
      isnull((select sg_estado from estado where cd_estado = t.cd_estado),'') as estado_transp,  
      t.cd_cnpj_transportadora,  
      cp.nm_condicao_pagamento,  
      t.cd_ddd      as cd_ddd_transp,  
      t.cd_telefone as cd_telefone_transp,  
      t.cd_fax      as cd_fax_transp,  
      c.nm_comprador,  
      n.cd_fornecedor,  
      n.cd_tipo_destinatario,  
      n.cd_operacao_fiscal,  
      n.cd_serie_nota_fiscal,   
      nr.cd_rem,  
      td.nm_tipo_destinatario,  
      n.nm_fantasia_destinatario,  
      o.cd_mascara_operacao,  
      o.nm_operacao_fiscal,  
      n.nm_especie_nota_entrada,  
      s.sg_serie_nota_fiscal,  
      n.dt_receb_nota_entrada,  
      n.dt_nota_entrada,  
      n.vl_total_nota_entrada,  
      n.vl_bicms_nota_entrada,  
      n.vl_icms_nota_entrada,  
      n.vl_ipi_nota_entrada,  
      n.vl_bsticm_nota_entrada,  
      n.vl_sticm_nota_entrada,  
      n.vl_biss_nota_entrada,  
      n.vl_iss_nota_entrada,  
      n.vl_irrf_nota_entrada,  
      n.vl_frete_nota_entrada,  
      n.vl_seguro_nota_entrada,  
      n.vl_despac_nota_entrada,  
      n.vl_prod_nota_entrada,  
      n.vl_servico_nota_entrada,  
      n.vl_iss_nota_entrada,  
      n.vl_pis_nota_entrada,  
      n.vl_cofins_nota_entrada,  
      n.vl_csll_nota_entrada,  
      n.vl_bcinss_nota_entrada,  
      n.vl_inss_nota_entrada,  
      n.vl_pis_nota_entrada,  
      n.pc_iss_nota_entrada,  
      n.pc_inss_nota_entrada,  
      n.pc_csll_nota_entrada,  
      n.pc_pis_nota_entrada,  
      n.pc_irrf_nota_entrada,  
      n.pc_cofins_nota_entrada,  
      vw.cd_cnpj                        as cd_cnpj_fornecedor,
      --f.cd_cnpj_fornecedor,  
      cc.nm_centro_custo,  
      pf.nm_conta_plano_financeiro,  
      ic_carta_cor_nota_entrada,  
      ic_conf_nota_entrada,  
      ic_sco,  
      ic_slf,  
      ic_sce,  
      ic_scu,  
      ic_scp,  
      ic_pcp,  
      ic_sep,  
      ic_simp,  
      ic_sct,  
      ic_scp_retencao,  
      ic_diverg_nota_entrega,  
      u.nm_fantasia_usuario,  
      n.cd_plano_financeiro,  
      isnull(n.ic_nfe_nota_entrada,'N') as ic_nfe_nota_entrada,
      n.ds_obs_compl_nota_entrada
  
  
  from   
      Nota_Entrada                              n  with (nolock)     
      left outer join nota_entrada_item         ni with (nolock)    on ni.cd_nota_entrada      = n.cd_nota_entrada and  
                                                                       ni.cd_item_nota_entrada = (select   
                                                                                                    min(cd_item_nota_entrada)  
     from  
                                                                                                    nota_entrada_item  
                                                                                                  where   
                                                                                                    cd_nota_entrada = n.cd_nota_entrada)                                 
      left outer join pedido_compra             pc with (nolock)  on pc.cd_pedido_compra        = ni.cd_pedido_compra  
      left outer join Nota_Entrada_Registro     nr with (nolock)  on n.cd_nota_entrada          = nr.cd_nota_entrada      and  
                                                                     n.cd_fornecedor            = nr.cd_fornecedor        and  
                                                                     n.cd_operacao_fiscal       = nr.cd_operacao_fiscal   and  
                                                                     n.cd_serie_nota_fiscal     = nr.cd_serie_nota_fiscal  
      left outer join Operacao_Fiscal           o  with (nolock)  on n.cd_operacao_fiscal       = o.cd_operacao_fiscal  
      left outer join comprador                 c  with (nolock)  on c.cd_comprador             = pc.cd_comprador  
      left outer join fornecedor                f  with (nolock)  on f.cd_fornecedor            = n.cd_fornecedor  
      left outer join Serie_Nota_Fiscal         s  with (nolock)  on n.cd_serie_nota_fiscal     = s.cd_serie_nota_fiscal  
      left outer join Tipo_Destinatario         td with (nolock)  on n.cd_tipo_destinatario     = td.cd_tipo_destinatario  
      left outer join condicao_pagamento        cp with (nolock)  on cp.cd_condicao_pagamento   = n.cd_condicao_pagamento     
      left outer join plano_financeiro          pf with (nolock)  on pf.cd_plano_financeiro     = n.cd_plano_financeiro  
      left outer join Tipo_pagamento_frete      tp with (nolock)  on tp.cd_tipo_pagamento_frete = n.cd_tipo_pagamento_frete  
      left outer join centro_custo              cc with (nolock)  on cc.cd_centro_custo         = n.cd_centro_custo  
      left outer join Transportadora            t  with (nolock)  on t.cd_transportadora        = n.cd_transportadora  
      left outer join EGISADMIN.dbo.Usuario     u  with (nolock)  on u.cd_usuario               = isnull(n.cd_usuario_inclusao,n.cd_usuario)  
      left outer join Status_nota               sn with (nolock)  on sn.cd_status_nota          = n.cd_status_nota  
      left outer join vw_destinatario           vw with (nolock)  on vw.cd_destinatario         = n.cd_fornecedor and
                                                                     vw.cd_tipo_destinatario    = n.cd_tipo_destinatario
--select * from vw_destinatario

    where  
     n.cd_nota_entrada           = @cd_nota_entrada and  
     n.cd_fornecedor             = @cd_fornecedor and  
     n.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and  
     n.cd_operacao_fiscal        = @cd_operacao_fiscal  
  end  

else if @ic_parametro = 3  
  begin  
------------------------------------------------------------------------------  
--ic_parametro = 3 - Seleciona as parcelas da nota  
------------------------------------------------------------------------------  
  
    declare @ic_ord_plano_financ char(1)  
    set @ic_ord_plano_financ = (select IsNull(ic_ord_plano_financ, 'A') from Parametro_Financeiro  
                   where cd_empresa = dbo.fn_empresa())  
  
    Select   
      nep.cd_parcela_nota_entrada,  
      nep.cd_ident_parc_nota_entr,  
      nep.dt_parcela_nota_entrada,  
      nep.vl_parcela_nota_entrada,  
      nep.nm_obs_parc_nota_entrada,  
      case when @ic_ord_plano_financ = 'C' then  
        cast(p.cd_mascara_plano_financeiro as varchar(30))+' - '+ p.nm_conta_plano_financeiro   
      else    
        p.nm_conta_plano_financeiro +' - ' + cast(p.cd_mascara_plano_financeiro as varchar(30))  
      end as 'PLANOFINANCEIRO',  
      cc.nm_centro_custo,  
      cp.nm_condicao_pagamento  
    From   
      Nota_entrada_Parcela               nep with (nolock)
      left outer join nota_saida         n   with (nolock) on n.cd_nota_saida          = nep.cd_nota_entrada   
      left outer join plano_financeiro   p   with (nolock) on p.cd_plano_financeiro    = nep.cd_plano_financeiro  
      left outer join grupo_financeiro   g   with (nolock) on g.cd_grupo_financeiro    = p.cd_grupo_financeiro  
      left outer join centro_custo       cc  with (nolock) on cc.cd_centro_custo       = p.cd_centro_custo  
      left outer join condicao_pagamento cp  with (nolock) on cp.cd_condicao_pagamento = n.cd_condicao_pagamento  
  where   
     nep.cd_nota_entrada           = @cd_nota_entrada and  
     nep.cd_fornecedor             = @cd_fornecedor and  
     nep.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and  
     nep.cd_operacao_fiscal        = @cd_operacao_fiscal   
  end  
else  
  begin  
------------------------------------------------------------------------------  
--ic_parametro = 4 - Seleciona os serviços da nota  
------------------------------------------------------------------------------  
    Select  
      nei.cd_item_nota_entrada,  
      nei.cd_servico,  
      nei.qt_item_nota_entrada,  
      nei.vl_item_nota_entrada,  
      nei.vl_total_nota_entr_item,  
      nei.cd_nota_entrada,  
      s.nm_servico,  
      nei.nm_produto_nota_entrada,  
      nei.vl_iss_servico,  
      s.vl_servico  
    From   
      nota_entrada_item                 nei with(nolock)  
      left outer join servico           s   with(nolock) on s.cd_servico = nei.cd_servico    
  where   
     nei.cd_nota_entrada           = @cd_nota_entrada and  
     nei.cd_fornecedor             = @cd_fornecedor and  
     nei.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and  
     nei.cd_operacao_fiscal        = @cd_operacao_fiscal  and  
     nei.ic_tipo_nota_entrada_item = 'S'  
  end  

