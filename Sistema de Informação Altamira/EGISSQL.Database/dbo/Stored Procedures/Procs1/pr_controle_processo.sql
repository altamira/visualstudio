
CREATE PROCEDURE pr_controle_processo
--------------------------------------------------------------------
--pr_controle_processo
-------------------------------------------------------------------- 
--GBS - Global Business Solution  Ltda                          2004
--------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000 
--Autor(es)             : Daniel C. Neto 
--Banco de Dados        : EGISSQL 
--Objetivo              : Rotinas para Controle de Processo
--Data                  : 11/09/2002 
--Atualizado            : 12/12/2002 - Acertos Daniel C. Neto.
--                      : 13/12/2002 - Acertos Daniel C. Neto.
--                      : 05/05/2004 - Revisão - Carlos Cardoso Fernandes
--                      : 11/08/2003 - Inclusão de novo campo - Daniel C. Neto.
--                      : 13/08/2003 - Acerto no Join de Pedido_Venda_Item - DANIEL DUELA 
--                      : 22/10/2003 - Acerto no campo 'ic_requisicao_compra' - DUELA/FABIO
--                      : 24/11/2003 - Atualização da rotina de exclusão - DUELA
--                      : 07/04/2004 - Inclusão do parâmetro '@cd_processo' para Pesquisa - DUELA
--                      : 07/04/2004 - Atualização da rotina de exclusão - DUELA
--                      : 14/04/2004 - Atualização da rotina de exclusão - DUELA
--                      : 27/04/2004 - Inclusão dos Campo 'cd_produto', 
--                                    'qt_planejada_processo' e 'cd_fase_produto' - DUELA
--                      : 16.06.2004 - Alterado o modo de execução da procedure de macro-substituição para case. IGOR GAMA 
--                      : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 26/01/2005 - Incluído campo de ic_credito - Daniel C. Neto.
--                      : 12/07/2006 - Trazer os itens da composicao que tiverem processo produtivo - Paulo Souza
--                      : 27.09.2006 - Datas de Fim de Produção e Liberação na Consulta - Carlos Fernandes
--                      : 06.10.2006 - Complemento das Informações - Código Produto/Desenho/Revisão - Carlos Fernandes
--                      : 24.02.2007 - Revisão para controle de desenho - Carlos Fernandes
--                      : 29.08.2007 - Exclusão dos dados da Guio de Fio - Carlos Fernandes
--                      : 17.09.2007 - Verificação na consulta do produo - Carlos Fernandes
--                      : 10.10.2007 - Verificação da proposta/item da proposta - Carlos Fernandes
-- 03.03.2008 - Verificação de Performance - Carlos Fernandes
-- 09.06.2008 - Cliente - Carlos Fernandes
-- 12.07.2008 - Acerto da Programação de Entrega - Carlos Fernandes
-- 20.08.2008 - Data de Entrega - Carlos Fernandes
-- 28.10.2008 - Exclusão da Movimentação de Estoque do Produto - Carlos Fernandes
-- 18.03.2009 - Exclusão da Programação no Mapa de Produção - APSNET - Carlos Fernandes
-- 20.08.2010 - Mostrar o Processo/OP Origem - Carlos Fernandes
-- 21.10.2010 - Número da Nota Fiscal - Carlos Fernandes
-- 09.11.2010 - Exclusão do Plano MRP - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------------------- 
@ic_parametro            int         = 0,  
@dt_inicial              datetime    = '', 
@dt_final                datetime    = '', 
@nm_fantasia_cliente     varchar(20) = '',
@cd_pedido_venda         int         = 0,
@cd_processo             int         = 0,
@cd_usuario              int         = 0

as 

--Variáveis para deletar o estoque / exclusão do processo

  declare @cd_produto                    int
  declare @qt_movimento_estoque          float 
  declare @cd_fase_produto               int
  declare @cd_movimento_estoque          int
  declare @cd_tipo_movimento_estoque     int
  declare @cd_tipo_movimento_estoque_aux int
  declare @cd_plano_mrp                  int

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta de Processos pelos Parâmetros Escolhidos.
-------------------------------------------------------------------------------
begin

  --Setando as variáveis

  set @cd_processo         = isnull(@cd_processo,0)
  set @nm_fantasia_cliente = isnull(@nm_fantasia_cliente,'')
  set @cd_pedido_venda     = isnull(@cd_pedido_venda,0)
  set @dt_inicial          = isnull(@dt_inicial,'')
  set @dt_final            = isnull(@dt_final,'')

     SELECT 
       0 as Sel,
       case when IsNull(pp.ic_libprog_processo,'N') = 'S' then 1 else 0 end as Lib,
       pp.dt_processo,
       pp.cd_processo,
       pp.cd_identifica_processo,
       pp.cd_produto,
       pp.cd_fase_produto,
       pp.qt_planejada_processo,
       pp.nm_mp_processo_producao,
       pp.ic_mapa_processo,
       p.cd_interno_projeto,
       pc.nm_item_desenho_projeto,
       pc.nm_item_desenho_projeto + '/' + cast(pcm.cd_projeto_material as varchar)  as 'Material',
       pvi.cd_pedido_venda,
       pvi.cd_item_pedido_venda,
       pvi.dt_item_pedido_venda,
       isnull(pvi.dt_entrega_fabrica_pedido,pp.dt_entrega_processo)                 as dt_entrega_fabrica_pedido,

--select * from processo_producao where cd_processo = 19218

       Case 
         When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then IsNull(pvi.qt_item_pedido_venda, pp.qt_planejada_processo)
         Else pp.qt_planejada_processo 
       End                                              as qt_item_pedido_venda,

       isNull(cli.nm_fantasia_cliente, '(Sem Cliente)') as nm_fantasia_cliente,

       Case when isnull(pp.cd_produto,0)>0 
       then
         prod.nm_produto
       else  
         case When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then 
             case 
               when isnull(pvi.cd_servico,0) > 0 then 
                 case 
                   when cast(pvi.ds_produto_pedido_venda as varchar(50)) <> '' then 
                     cast(pvi.ds_produto_pedido_venda as varchar(50)) 
                   else 
                     pvi.nm_produto_pedido
                 end
               else IsNull(pvi.nm_produto_pedido, prod.nm_produto)
             end
          Else 
             prod.nm_produto
          End                  
       end                         as nm_produto_pedido,
       
       Case when isnull(pp.cd_produto,0)>0 
       then
          prod.nm_fantasia_produto   
       else
         case When IsNull(pp.cd_id_item_pedido_venda,0) = 0 then
           case when isnull(pvi.cd_servico,0) > 0 then
               cast(s.nm_servico as varchar(25))
           else
              IsNull(pvi.nm_fantasia_produto, prod.nm_fantasia_produto) end
         Else prod.nm_fantasia_produto
         End 
       end                                             as nm_fantasia_produto,
 
       Case when isnull(pp.cd_produto,0)<>isnull(pvi.cd_produto,0) then
         prod.vl_produto
       else
         
         case When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then IsNull(pvi.vl_unitario_item_pedido, prod.vl_produto)
         Else pvc.vl_item_comp_pedido 
         End 
       end as vl_unitario_item_pedido, 

       pvi.ds_observacao_fabrica,
       pvi.ds_produto_pedido_venda,

       Case 
         When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then pvi.ds_produto_pedido
         Else prod.ds_produto
       End as ds_produto_pedido,

       Case 
         When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then IsNull(pvi.qt_liquido_item_pedido,prod.qt_peso_liquido) 
         Else prod.qt_peso_liquido
       End as qt_liquido_item_pedido,

       Case 
         When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then IsNull(pvi.qt_bruto_item_pedido, prod.qt_peso_bruto)
         Else prod.qt_peso_bruto
       End as qt_bruto_item_pedido,

       Case when isnull(pp.cd_produto,0)<>isnull(pvi.cd_produto,0) then
         pp.qt_planejada_processo * isnull(pvc.vl_item_comp_pedido,prod.vl_produto)
       else
         case When IsNull(pp.cd_id_item_pedido_venda,0) = 0
           Then (pvi.qt_item_pedido_venda * IsNull(pvi.vl_unitario_item_pedido, prod.vl_produto))
         Else pp.qt_planejada_processo * pvc.vl_item_comp_pedido
         End    
       end                     as Total,
       vi.nm_fantasia_vendedor AS VI,
       ve.nm_fantasia_vendedor AS VE,
       IsNull((select top 1 1 from Requisicao_Compra_Item x 
               where x.cd_pedido_venda = pvi.cd_pedido_venda and
                     x.cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0) as ic_requisicao_compra,
       pp.ds_processo,
       pp.ds_processo_fabrica,
       un.sg_unidade_medida,
       pv.ds_pedido_venda,
       pp.cd_status_processo,
       sp.nm_status_processo,
       case when (isnull(pp.cd_pedido_venda,0)=0) then 'N' else
         case when (isnull(pv.dt_credito_pedido_venda,'')  <>'') then
           'N' else 'S' end end as 'ic_credito',
       pp.cd_id_item_pedido_venda,
       pp.dt_liberacao_processo,
       pp.dt_prog_processo,
       pp.dt_canc_processo,
       pp.dt_fimprod_processo,
      
       case
         when isnull(pvi.cd_pedido_venda,0) > 0 then

           case when isnull(pvi.cd_servico,0)>0 then
              cast(pvi.cd_servico as varchar(25))
           else
             case when isnull(pvi.cd_produto,0)>0 then
                prod.cd_mascara_produto
             else
                cast(pvi.cd_grupo_produto as varchar(25)) end
           end
         else
           prod.cd_mascara_produto
       end as cd_mascara_produto,
  
       case when isnull(pvi.cd_produto,0)>0 then
           isnull(prod.cd_desenho_produto,pvi.cd_desenho_item_pedido)
       else
           isnull(pvi.cd_desenho_item_pedido,pp.cd_desenho_processo_produto)
       end as cd_desenho_produto,

       case when isnull(pvi.cd_produto,0)>0 then
            isnull(prod.cd_rev_desenho_produto,pvi.cd_rev_des_item_pedido)
       else 
         isnull(pvi.cd_rev_des_item_pedido,pp.cd_rev_des_processo_produto)
       end as cd_rev_desenho_produto,
       pvi.cd_consulta,
       pvi.cd_item_consulta,
       pp.cd_programacao_entrega,
       isnull(pp.cd_processo_origem,0)     as cd_processo_origem,

       nsi.cd_identificacao_nota_saida as cd_nota_saida,
       nsi.dt_nota_saida,
       nsi.dt_saida_nota_saida,
       nsi.cd_item_nota_saida,
       nsi.qt_item_nota_saida,
       nsi.qt_devolucao_item_nota,
       nsi.qt_item_nota_saida as qt_faturada

     from 
       Processo_Producao pp                  with (nolock) 

       left outer join Pedido_Venda pv       with (nolock) on pp.cd_pedido_venda = pv.cd_pedido_venda 
       left outer join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda and
                                                              pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda

       left outer join Cliente cli           with (nolock) on cli.cd_cliente           = 
                                                              case when isnull(pv.cd_cliente,0)>0 then pv.cd_cliente else pp.cd_cliente end

       left outer join Vendedor vi           with (nolock) on pv.cd_vendedor_interno = vi.cd_vendedor 
       left outer join Vendedor ve           with (nolock) on pv.cd_vendedor = ve.cd_vendedor 
       left outer join Unidade_Medida un     with (nolock) on un.cd_unidade_medida = pvi.cd_unidade_medida 
       left outer join Projeto p             with (nolock) on pp.cd_projeto = p.cd_projeto 
       left outer join Projeto_Composicao pc with (nolock) on pp.cd_projeto = pc.cd_projeto and 
                                                              pp.cd_item_projeto = pc.cd_item_projeto
       left outer join Projeto_Composicao_Material pcm with (nolock) on pp.cd_projeto               = pcm.cd_projeto and 
                                                                        pp.cd_item_projeto          = pcm.cd_item_projeto and 
                                                                        pp.cd_projeto_material      = pcm.cd_projeto_material
       left outer join Produto prod                    with (nolock) on pp.cd_produto               = prod.cd_produto
       left outer join Status_processo sp              with (nolock) on pp.cd_status_processo       = sp.cd_status_processo
       left outer join Pedido_venda_composicao pvc     with (nolock) on pvc.cd_pedido_venda         = pvi.cd_pedido_venda and
                                                                        pvc.cd_item_pedido_venda    = pvi.cd_item_pedido_venda and
                                                                        pvc.cd_id_item_pedido_venda = pp.cd_item_pedido_venda
       left outer join Servico s                       with (nolock) on s.cd_servico                = pvi.cd_servico

       LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                              nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda


     WHERE 
--       pvi.dt_cancelamento_item is null
       isnull(pp.cd_processo,0) = case when @cd_processo = 0
                                     then isnull(pp.cd_processo,0)
                                   else @cd_processo end
       and isnull(pvi.cd_pedido_venda,0) = case when @cd_pedido_venda = 0 then isnull(pvi.cd_pedido_venda,0)
                                      else @cd_pedido_venda end
       and pp.dt_processo between case when @dt_inicial = '' then pp.dt_processo
                                       else @dt_inicial end
                          and case when @dt_final = '' then pp.dt_processo
                                   else @dt_final end
       and IsNull(cli.nm_fantasia_cliente,'') like @nm_fantasia_cliente + '%'
     ORDER BY 
       pp.dt_processo desc, 
       pp.cd_identifica_processo

end

---------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Exclusão do Processo
---------------------------------------------------------------------------------
begin

  --select * from processo_producao_guia_fio
  --select * from processo_producao_texto
  --select * from processo_producao_inspecao

  --Programacao de entrega
  update
    programacao_entrega
  set
    cd_processo = 0
  where
    cd_processo = @cd_processo

  --Plano MRP --> select * from plano_mrp_composicao

  select
    @cd_plano_mrp = isnull(cd_plano_mrp,0)
  from
    plano_mrp_composicao with (nolock)
  where
    cd_processo = @cd_processo

  --select * from plano_mrp

  update
    plano_mrp
  set
    ic_processo_plano =  'N'
  where
    cd_plano_mrp = @cd_plano_mrp

  update
    plano_mrp_composicao
  set
    cd_processo = 0
  where
    cd_processo = @cd_processo


  delete from Processo_Producao_Embalagem        where cd_processo          = @cd_processo

  delete from Processo_Producao_Parada           where cd_processo          = @cd_processo

  delete from Processo_Producao_Apontamento      where cd_processo          = @cd_processo

  delete from Processo_Producao_Texto            where cd_processo_producao = @cd_processo

  delete from Processo_Producao_Composicao       where cd_processo          = @cd_processo

  delete from Processo_Producao_Componente       where cd_processo          = @cd_processo

  delete from Processo_Producao_Guia_Fio         where cd_processo          = @cd_processo

  delete from Processo_Producao_Inspecao         where cd_processo          = @cd_processo

  delete from Processo_Producao_Revisao          where cd_processo          = @cd_processo

  delete from Processo_Producao_Pedido           where cd_processo          = @cd_processo

  delete from Processo_Producao_Composicao_Placa where cd_processo          = @cd_processo

  delete from Processo_Producao_Ferramenta       where cd_processo_producao = @cd_processo

  delete from Processo_Producao_Teste            where cd_processo          = @cd_processo

  delete from Processo_Producao_Adicao           where cd_processo          = @cd_processo

  delete from Processo_Producao_Fase_Apontamento where cd_processo          = @cd_processo

  delete from Processo_Producao                  where cd_processo          = @cd_processo

  --Programação de Produção --Mapa
  delete from Programacao_Composicao             where cd_processo          = @cd_processo

  --select * from programacao_composicao

  --Ajusta o Saldo do Produto da Ordem de Produção
  --select * from movimento_estoque

  select
    cd_movimento_estoque
    cd_produto,
    qt_movimento_estoque,
    cd_fase_produto,
    cd_tipo_movimento_estoque,
    cd_tipo_documento_estoque
    
  into
    #MovimentoEstoqueProcesso
  from
    Movimento_Estoque me with (nolock) 
  where 
    cd_documento_movimento    = @cd_processo and
    cd_tipo_documento_estoque = 12           and
    cd_produto>0

  while exists ( select top 1 cd_produto from #MovimentoEstoqueProcesso )
  begin

    select top 1 
      @cd_produto                = cd_produto,
      @qt_movimento_estoque      = qt_movimento_estoque,
      @cd_fase_produto           = cd_fase_produto,
      @cd_tipo_movimento_estoque = cd_tipo_movimento_estoque
    from
      #MovimentoEstoqueProcesso

    --Ajusta o Tipo de Movimento de Estoque
    --select * from tipo_movimento_estoque

    select
      @cd_tipo_movimento_estoque = 
        (case when @cd_tipo_movimento_estoque = 2 
         then 3   --Cancelamento da Reserva
         else
           case when @cd_tipo_movimento_estoque = 1 
           then
             11   --Saída
           else
             case when @cd_tipo_movimento_estoque = 11
             then 1
             else 0
             end
           end 
         end)

    --Ajusta o Saldo do Produto

   --Reserva
   --select * from movimento_estoque
   --select * from tipo_movimento_estoque

   exec pr_Movimenta_estoque  
        3,                          --Acerto do Saldo do Produto
        @cd_tipo_movimento_estoque, --Tipo de Movimentação de Estoque ( Reserva )
        NULL,                    --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_movimento_estoque,   --Quantidade
        NULL,                    --Quantidade Antiga
        null,                    --Data do Movimento de Estoque
        null,                    --Pedido de Venda
        null,                    --Item do Pedido
        12,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        null,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        null,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão

--       exec pr_Movimenta_estoque  
--         3,                       --Acerto do Saldo do Produto
--         1,                       --Tipo de Movimentação de Estoque ( Real )
--         NULL,                    --Tipo de Movimentação de Estoque (OLD)
--         @cd_produto,             --Produto
--         @cd_fase_produto,        --Fase de Produto
--         @qt_movimento_estoque,   --Quantidade
--         NULL,                    --Quantidade Antiga
--         null,                    --Data do Movimento de Estoque
--         null,                    --Pedido de Venda
--         null,                    --Item do Pedido
--         12,                       --Tipo de Documento
--         null,                    --Data do Pedido
--         NULL,                    --Centro de Custo
--         null                  ,  --Valor Unitário
--         null,                    --Valor Total
--         'N',                     --Peps Não
--         'N',                     --Mov. Terceiro
--         null,                    --Histórico
--         'S',                     --Mov. Saída
--         null,                    --Cliente
--         NULL,                    --Fase de Entrada ?
--         '0',                     --Fase de Entrada
--         @cd_usuario,
--         null,                    --Data do Usuário
--         1,                       --Tipo de Destinatário = Cliente
--         null, 
--         0.00,                    --Valor Fob
--         0.00,                    --Custo Contábil,
--         0.00,                    --Valor Fob Convertido,
--         0,                       --Produto Anterior
--         0,                       --Fase Anterior
--         'N',                     --Consignação, 
--         'N',                     --Amostra         
--         'A',                     --Tipo de Lançamento = 'A'=Automático 
--         0,                       --Item da Composição
--         0,                       --Histórico
--         NULL,                    --Operação Fiscal,
--         NULL,                    --Série da Nota
--         null,                    --Código do Movimento de Estoque   
--         NULL,                    --Lote 
--         NULL,                    --Tipo de Movimento Transferência
--         NULL,                    --Unidade
--         NULL,                    --Unidade Origem
--         NULL,                    --Fator
--         NULL,                    --Qtd. Original
--         'N',                     --Atualiza Saldo Lote
--         NULL,                    --Lote Anterior
--         NULL                     --Custo da Comissão

--    end 

    delete from #MovimentoEstoqueProcesso
    where
      cd_produto                = @cd_produto  and
      cd_tipo_documento_estoque = 12           and
      cd_produto>0

  end


  --Movimentação do Estoque do Produto Gerado pela Ordem de Produção

  delete from Movimento_Estoque                  where cd_documento_movimento    = @cd_processo and
                                                       cd_tipo_documento_estoque = 12 
  --select * from processo_producao_revisao
  --select * from processo_producao_pedido
  --select * from processo_producao_composicao_placa
  --select * from processo_producao_ferramenta

end

else if @ic_parametro = 5 -- Exclusão do Processo
begin

  update
    programacao_entrega
  set
    cd_processo = 0
  where
    cd_processo = @cd_processo



  select
    @cd_plano_mrp = isnull(cd_plano_mrp,0)
  from
    plano_mrp_composicao with (nolock)
  where
    cd_processo = @cd_processo

  --select * from plano_mrp

  update
    plano_mrp
  set
    ic_processo_plano = 'N'
  where
    cd_plano_mrp = @cd_plano_mrp

  update
    plano_mrp_composicao
  set
    cd_processo = 0
  where
    cd_processo = @cd_processo



  delete from Processo_Producao_Embalagem        where cd_processo          = @cd_processo

  delete from Processo_Producao_Parada           where cd_processo          = @cd_processo

  delete from Processo_Producao_Apontamento      where cd_processo          = @cd_processo

  delete from Processo_Producao_Texto            where cd_processo_producao = @cd_processo

  delete from Processo_Producao_Composicao       where cd_processo          = @cd_processo

  delete from Processo_Producao_Componente       where cd_processo          = @cd_processo

  delete from Processo_Producao_Guia_Fio         where cd_processo = @cd_processo

  delete from Processo_Producao_Inspecao         where cd_processo = @cd_processo

  delete from Processo_Producao_Revisao          where cd_processo = @cd_processo

  delete from Processo_Producao_Pedido           where cd_processo = @cd_processo

  delete from Processo_Producao_Composicao_Placa where cd_processo = @cd_processo

  delete from Processo_Producao_Ferramenta       where cd_processo_producao = @cd_processo

  delete from Processo_Producao_Teste            where cd_processo = @cd_processo

  delete from Processo_Producao_Adicao           where cd_processo = @cd_processo

  delete from Processo_Producao_Fase_Apontamento where cd_processo = @cd_processo


  --Programação de Produção --Mapa
  delete from Programacao_Composicao             where cd_processo          = @cd_processo

  --delete from Processo_Producao                  where cd_processo = @cd_processo

  --Ajusta o Saldo do Produto da Ordem de Produção
  --select * from movimento_estoque

  select
    cd_movimento_estoque
    cd_produto,
    qt_movimento_estoque,
    cd_fase_produto,
    cd_tipo_movimento_estoque,
    cd_tipo_documento_estoque
    
  into
    #EstoqueProcesso
  from
    Movimento_Estoque me with (nolock) 
  where 
    cd_documento_movimento    = @cd_processo and
    cd_tipo_documento_estoque = 12           and
    cd_produto>0

  while exists ( select top 1 cd_produto from #EstoqueProcesso )
  begin

    select top 1 
      @cd_produto                = cd_produto,
      @qt_movimento_estoque      = qt_movimento_estoque,
      @cd_fase_produto           = cd_fase_produto,
      @cd_tipo_movimento_estoque = cd_tipo_movimento_estoque
    from
      #EstoqueProcesso

    --Ajusta o Tipo de Movimento de Estoque
    set @cd_tipo_movimento_estoque     = 0
    set @cd_tipo_movimento_estoque_aux = 0

    select 
      @cd_tipo_movimento_estoque = 
        (case when @cd_tipo_movimento_estoque = 2 
         then 3 --Cancelamento da Reserva
         else
           case when @cd_tipo_movimento_estoque = 1 
           then
             11   --Saída
           else
             case when @cd_tipo_movimento_estoque = 11
             then 1
             else 0
             end
           end 
         end)
    
    
    --Ajusta o Saldo do Produto

    if @cd_tipo_movimento_estoque=11
    begin
      select 
        @cd_tipo_movimento_estoque_aux = 2

     print '1'

     exec pr_Movimenta_estoque  
        3,                          --Acerto do Saldo do Produto
        @cd_tipo_movimento_estoque, --Tipo de Movimentação de Estoque ( Reserva )
        @cd_tipo_movimento_estoque, --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,                --Produto
        @cd_fase_produto,           --Fase de Produto
        @qt_movimento_estoque,      --Quantidade
        NULL,                       --Quantidade Antiga
        null,                       --Data do Movimento de Estoque
        null,                       --Pedido de Venda
        null,                       --Item do Pedido
        12,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        null,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        null,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão

   end

   print '2'

   if @cd_tipo_movimento_estoque_aux>0
   begin
     exec pr_Movimenta_estoque  
        3,                              --Acerto do Saldo do Produto
        @cd_tipo_movimento_estoque_aux, --Tipo de Movimentação de Estoque ( Reserva )
        @cd_tipo_movimento_estoque_aux, --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_movimento_estoque,   --Quantidade
        NULL,                    --Quantidade Antiga
        null,                    --Data do Movimento de Estoque
        null,                    --Pedido de Venda
        null,                    --Item do Pedido
        12,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        null,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        null,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão
   end

   print '3'

--    end 

    delete from #EstoqueProcesso
    where
      cd_produto                = @cd_produto  and
      cd_tipo_documento_estoque = 12           and
      cd_produto>0

  end

  --Movimentação do Estoque do Produto Gerado pela Ordem de Produção

  delete from Movimento_Estoque                  where cd_documento_movimento    = @cd_processo and
                                                       cd_tipo_documento_estoque = 12 

end

