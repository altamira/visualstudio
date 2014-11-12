
CREATE PROCEDURE pr_consulta_estoque_minimo  
------------------------------------------------------------------------------------------------------    
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------    
--Stored Procedure: Microsoft SQL Server       2000  
--Autor(s): Lucio Vanderlei  
--Banco de Dados: SapSQL  
--Objetivo: Consultar Estoque Mínimo de Produtos e  
--          saldos negativos           
--Data       : 23/04/2002  
--Atualizado : 24/04/2002 - Estoques Zerados  
--           : 04/07/2003 - Modificado filtro para saldos reais ao invés de  
--                          saldos de reserva - ELIAS/LUDINEI   
--           : 04/07/2003 - Modificado para trazer apenas os saldos negativos - LUDINEI  
--           : 03/03/2004 - Modificado para consultar por outros parametros :  
--                          Produtos ABaixo do estoque minimo  
--                     Estoque minimo atingido  
--                          Sem definição de estoque - Rafael M. Santiago  
--           : 11/02/2005 - Modificado para Mostrar também os Produtos que tenham  
--                          saldo inferior ao configurado como mínimo - ELIAS  
--           : 02.09.2005 - Verificação dos Pedidos de Importação  
--           : 18.03.2006 - Verificação da Rotina - Carlos Fernades  
-- 13/04/2006 - Paulo Souza  
--              Acrescentado à coluna Requisição de compras a quantidade de requisição  
--              de importação e uma nova coluna para quantidade em pedido de importação  
-- 14.04.2007 - Acerto da Máscara - Carlos Fernandes
-- 30.10.2007 - Mostrar o Produto de Acordo com o Status do Produto - Carlos Fernandes
-- 20.08.2008 - Tipo de Estoque Mínimo - Carlos Fernandes
-- 22.09.2008 - Unidade de Medida/Grupo de Produto - Carlos Fernandes
-- 11.02.2009 - Grupo/Categoria/Qtd. Produção - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------  
@ic_parametro      int, -- 1 = Estoque Mínimo, 2 = Estoque Negativo, 3 = Abaixo do estoque minimo, 4 = Atingiram estoque minimo, 5 = Sem Definição de estoque  
@cd_grupo_produto  int,  
@cd_produto        int,   
@cd_serie_produto  int,  
@cd_dias_consumo   int,  
@cd_fase_produto   int = 0,
@ic_tipo_saldo     char(1) = 'A' --Ambos / Real / Disponível
  
as  
  
--select * from status_produto
--select * from parametro_estoque


--Tipo de Saldo = Disponível ou Atual 

declare @ic_tipo_saldo_minimo char(1)

select 
  @ic_tipo_saldo_minimo = isnull(ic_tipo_saldo_minimo,'S')
from
  parametro_estoque with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

declare @data_inicial datetime,  
        @data_final   datetime,  
        @cd_meses     int  
  
set @data_inicial = DateAdd(Day, (@cd_dias_consumo * -1), GETDATE() )  
set @data_final   = GETDATE()  
  
set @cd_meses     = DateDiff(Month, @data_inicial, @Data_final)  
  
------------------------------------------------------------------------------------      
-- Saldos do próprio produto  
------------------------------------------------------------------------------------      

IF @ic_parametro = 5 -- Produtos Sem definicao  
begin  
  Select  
    isnull(a.cd_grupo_produto,0)            as 'CodGrupoProduto',   
    a.cd_produto                            as 'CodProduto',  
    --dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto) as 'MascaraProduto',  
    case
      when isnull(dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto),'') <> '' then
        dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto)
      else
        a.cd_mascara_produto
    end                                     as 'MascaraProduto', 
    a.nm_produto                            as 'Descricao',  
    a.nm_fantasia_produto                   as 'Produto',   
    isnull(b.qt_saldo_reserva_produto,0)    as 'Disponivel',  
    f.nm_fase_produto                       as 'Fase',  
    isnull(b.qt_saldo_atual_produto,0)      as 'Atual',  
    case when @ic_tipo_saldo_minimo='S' then
      isnull(b.qt_saldo_reserva_produto,0) 
    else
      isnull(b.qt_saldo_atual_produto,0)
    end                                     as 'Saldo_Comparativo',

    isnull(b.qt_minimo_produto,0)           as 'Minimo',  
--    isnull(b.qt_req_compra_produto,0)       as 'Requisicao',  
    isnull(b.qt_pd_compra_produto,0)+  
    isnull(b.qt_importacao_produto,0)       as 'PedidoCompra',  
    --isnull(b.dt_prev_ent1_produto,'' )    as 'Previsao1',  
    --isnull(b.dt_prev_ent2_produto,'')     as 'Previsao2',  
    --isnull(b.dt_prev_ent3_produto,'')     as 'Previsao3',  
    b.dt_prev_ent1_produto                  as 'Previsao1',  
    b.dt_prev_ent2_produto                  as 'Previsao2',  
    b.dt_prev_ent3_produto                  as 'Previsao3',  
    d.sg_unidade_medida                     as 'UnidadeMedida',  
    ConsumoMensal =   
      case   
       when @ic_parametro in (1,3,4,5) then 0 -- Não necessário nesta query  
       else isnull((select sum(me.qt_movimento_estoque)/@cd_meses   
                     from movimento_estoque me  with (nolock) 
                     where (me.cd_produto = a.cd_produto) and  
                           (me.dt_movimento_estoque between @data_inicial and @data_final) and  
                           (me.ic_mov_movimento = 'S')),0)  
      end,  
   IsNUll((select Sum(pii.qt_saldo_item_ped_imp)  
           from pedido_importacao_item pii  with (nolock) 
           where pii.cd_produto = a.cd_produto and  
                 pii.qt_saldo_item_ped_imp > 0 and  
                 pii.dt_cancel_item_ped_imp is null  
           group by pii.cd_produto),0) as 'PedidoImportacao',  
    (isnull(b.qt_req_compra_produto,0) +  
     IsNull((select Sum(rci.qt_item_requisicao_compra)  
            from requisicao_compra_item rci  with (nolock) 
                 inner join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and  
                                                               rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and  
                                                               pii.dt_cancel_item_ped_imp is null  
            where rci.cd_produto = a.cd_produto  
            Group by rci.cd_produto),0)) as 'Requisicao',
    (isnull((select sum(pp.qt_planejada_processo)
            from
              processo_producao pp with (nolock) 
            where
              pp.cd_produto       = a.cd_produto and
              pp.dt_canc_processo is null        and 
              pp.cd_status_processo <> 5 --Não pode estar encerrada
              --select * from status_processo
            group by pp.cd_produto),0)) as 'Qtd_Producao',

     sp.nm_status_produto,
     c.nm_grupo_produto,
     cp.nm_categoria_produto      
  
  into #TmpSaldosProdutoDefinicao  

 from  
    Produto a                         with (nolock)
    Left Outer Join Produto_Saldo b   with (nolock) on a.cd_produto = b.cd_produto  
    left outer Join Fase_Produto f    with (nolock) on f.cd_fase_produto = b.cd_fase_produto  
    left outer Join Grupo_Produto c   with (nolock) on a.cd_grupo_produto = c.cd_grupo_produto  
    Left Outer Join Unidade_Medida d  with (nolock) on a.cd_unidade_medida = d.cd_unidade_medida  
    Left outer Join Status_Produto sp with (nolock) on sp.cd_status_produto = a.cd_status_produto and
                                                       isnull(sp.ic_bloqueia_uso_produto,'N')='N'
    left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = a.cd_categoria_produto

   where   
--    not exists (select 'x' from produto_saldo where produto_saldo.cd_produto = a.cd_produto and cd_fase_produto = @cd_fase_produto)  
--    and  
    (a.cd_produto_baixa_estoque is null or a.cd_produto_baixa_estoque = 0)   
    and (@cd_grupo_produto = 0 or a.cd_grupo_produto = @cd_grupo_produto)   
    and (@cd_produto = 0 or a.cd_produto = @cd_produto)   
    and (@cd_serie_produto = 0 or a.cd_serie_produto = @cd_serie_produto)   
    and isnull(b.qt_minimo_produto,0)=0   
    and b.cd_fase_produto = case when @cd_fase_produto = 0 then b.cd_fase_produto else @cd_fase_produto end  
    --and (IsNull(b.qt_saldo_atual_produto,0) < b.qt_minimo_produto or b.qt_saldo_atual_produto <= 0)   
    --and (@cd_fase_produto = 0 or ISNULL(b.cd_fase_produto,@cd_fase_produto) = @cd_fase_produto)   
      
---------------------------------------------------  
-- Saldos de produtos com baixa de estoque em outro  
---------------------------------------------------  
  
  Select  
    isnull(a.cd_grupo_produto,0)            as 'CodGrupoProduto',   
    a.cd_produto                            as 'CodProduto',  
    --dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto) as 'MascaraProduto',  
    case
      when isnull(dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto),'') <> '' then
        dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto)
      else
        a.cd_mascara_produto
    end                                     as 'MascaraProduto', 
    a.nm_produto                            as 'Descricao',  
    a.nm_fantasia_produto                   as 'Produto',   
    isnull(b.qt_saldo_reserva_produto,0)    as 'Disponivel',  
    f.nm_fase_produto                       as 'Fase',  
    isnull(b.qt_saldo_atual_produto,0)      as 'Atual',  
    case when @ic_tipo_saldo_minimo='S' then
      isnull(b.qt_saldo_reserva_produto,0) 
    else
      isnull(b.qt_saldo_atual_produto,0)
    end                                     as 'Saldo_Comparativo',

    isnull(b.qt_minimo_produto,0)           as 'Minimo',  
--    isnull(b.qt_req_compra_produto,0)       as 'Requisicao',  
    isnull(b.qt_pd_compra_produto,0)+  
    isnull(b.qt_importacao_produto,0)       as 'PedidoCompra',  
    --isnull(b.dt_prev_ent1_produto,'' )    as 'Previsao1',  
    --isnull(b.dt_prev_ent2_produto,'')     as 'Previsao2',  
    --isnull(b.dt_prev_ent3_produto,'')     as 'Previsao3',  
    b.dt_prev_ent1_produto                  as 'Previsao1',  
    b.dt_prev_ent2_produto                  as 'Previsao2',  
    b.dt_prev_ent3_produto                  as 'Previsao3',  
    d.sg_unidade_medida                     as 'UnidadeMedida',  
    ConsumoMensal =   
      case   
       when @ic_parametro in (1,3,4,5) then 0 -- Não necessário nesta query  
       else isnull((select sum(me.qt_movimento_estoque)/@cd_meses   
                     from movimento_estoque me  with (nolock) 
                     where (me.cd_produto = a.cd_produto) and  
                           (me.dt_movimento_estoque between @data_inicial and @data_final) and  
                           (me.ic_mov_movimento = 'S')),0)  
      end,  
   IsNUll((select Sum(pii.qt_saldo_item_ped_imp)  
           from pedido_importacao_item pii  with (nolock) 
           where pii.cd_produto = a.cd_produto and  
                 pii.qt_saldo_item_ped_imp > 0 and  
                 pii.dt_cancel_item_ped_imp is null  
           group by pii.cd_produto),0) as 'PedidoImportacao',  
    (isnull(b.qt_req_compra_produto,0) +  
     IsNull((select Sum(rci.qt_item_requisicao_compra)  
            from requisicao_compra_item rci  with (nolock) 
                 inner join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and  
                                                               rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and  
                                                               pii.dt_cancel_item_ped_imp is null  
            where rci.cd_produto = a.cd_produto  
            Group by rci.cd_produto),0)) as 'Requisicao',
    (isnull((select sum(pp.qt_planejada_processo)
            from
              processo_producao pp with (nolock) 
            where
              pp.cd_produto       = a.cd_produto and
              pp.dt_canc_processo is null        and 
              pp.cd_status_processo <> 5 --Não pode estar encerrada
              --select * from status_processo
            group by pp.cd_produto),0)) as 'Qtd_Producao',

     sp.nm_status_produto,
     c.nm_grupo_produto,
     cp.nm_categoria_produto      
  
  into #TmpSaldosOutroProdutoDefinicao  
  from  
    Produto a  with (nolock)  
      Inner Join   
    Produto o   
      on a.cd_produto_baixa_estoque = o.cd_produto  
      Left Outer Join   
    Produto_Saldo b   
      on o.cd_produto = b.cd_produto  
      left outer join  
    Grupo_Produto c   
      on o.cd_grupo_produto = c.cd_grupo_produto  
      left outer join  
    Fase_Produto f  
      on f.cd_fase_produto = b.cd_fase_produto  
      Left Outer Join   
    Unidade_Medida d   
      on o.cd_unidade_medida = d.cd_unidade_medida  
    Left outer Join Status_Produto sp with (nolock) on sp.cd_status_produto = a.cd_status_produto and
                                                       isnull(sp.ic_bloqueia_uso_produto,'N')='N'

    left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = a.cd_categoria_produto
  Where  
--    not exists (select 'x' from produto_saldo where produto_saldo.cd_produto = a.cd_produto and cd_fase_produto = @cd_fase_produto)  
-- and  
    isnull(a.cd_produto_baixa_estoque,0) > 0    
    and (@cd_grupo_produto = 0 or a.cd_grupo_produto = @cd_grupo_produto)   
    and (@cd_produto = 0 or a.cd_produto = @cd_produto)   
    and (@cd_serie_produto = 0 or a.cd_serie_produto = @cd_serie_produto)   
    and isnull(b.qt_minimo_produto,0)=0   
    and b.cd_fase_produto = case when @cd_fase_produto = 0 then b.cd_fase_produto else @cd_fase_produto end  
  
--    and (IsNull(b.qt_saldo_atual_produto,0) < b.qt_minimo_produto or b.qt_saldo_atual_produto <= 0)   
--    and (@cd_fase_produto = 0 or ISNULL(b.cd_fase_produto,@cd_fase_produto) = @cd_fase_produto)   
  
-- Juntar as duas seleções   
  
  insert into #TmpSaldosProdutoDefinicao  
  select * from #TmpSaldosOutroProdutoDefinicao  
  
end  
  
else  
  
begin  
  Select  
    a.cd_grupo_produto            as 'CodGrupoProduto',   
    a.cd_produto                  as 'CodProduto',  
    --dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto) as 'MascaraProduto',  
    case
      when isnull(dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto),'') <> '' then
        dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto)
      else
        a.cd_mascara_produto
    end as 'MascaraProduto', 
    a.nm_produto                  as 'Descricao',  
    a.nm_fantasia_produto         as 'Produto',   
    b.qt_saldo_reserva_produto    as 'Disponivel',  
    f.nm_fase_produto             as 'Fase',  
    b.qt_saldo_atual_produto      as 'Atual',  
    isnull(b.qt_minimo_produto,0) as 'Minimo',  
--    b.qt_req_compra_produto               as 'Requisicao',  
  
    isnull(b.qt_pd_compra_produto,0)+  
    isnull(b.qt_importacao_produto,0)     as 'PedidoCompra',  
  
    --isnull(b.dt_prev_ent1_produto,'' )    as 'Previsao1',  
    --isnull(b.dt_prev_ent2_produto,'')     as 'Previsao2',  
    --isnull(b.dt_prev_ent3_produto,'')     as 'Previsao3',  
    b.dt_prev_ent1_produto                  as 'Previsao1',  
    b.dt_prev_ent2_produto                  as 'Previsao2',  
    b.dt_prev_ent3_produto                  as 'Previsao3',  
    d.sg_unidade_medida                     as 'UnidadeMedida',  

    ConsumoMensal =   
      case   
       when @ic_parametro in (1,3,4,5) then 0 -- Não necessário nesta query  
       else isnull((select sum(me.qt_movimento_estoque)/@cd_meses   
                     from movimento_estoque me  
                     where (me.cd_produto = a.cd_produto) and  
                           (me.dt_movimento_estoque between @data_inicial and @data_final) and  
                           (me.ic_mov_movimento = 'S')),0)  
      end,  
   IsNUll((select Sum(pii.qt_saldo_item_ped_imp)  
           from pedido_importacao_item pii  
           where pii.cd_produto = a.cd_produto and  
                 pii.qt_saldo_item_ped_imp > 0 and  
                 pii.dt_cancel_item_ped_imp is null  
           group by pii.cd_produto),0) as 'PedidoImportacao',  
    (isnull(b.qt_req_compra_produto,0) +  
     IsNull((select Sum(rci.qt_item_requisicao_compra)  
            from requisicao_compra_item rci  
                 inner join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and  
                                                               rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and  
                                                               pii.dt_cancel_item_ped_imp is null  
            where rci.cd_produto = a.cd_produto  
            Group by rci.cd_produto),0)) as 'Requisicao',

    (isnull((select sum(pp.qt_planejada_processo)
            from
              processo_producao pp with (nolock) 
            where
              pp.cd_produto       = a.cd_produto and
              pp.dt_canc_processo is null        and 
              pp.cd_status_processo <> 5 --Não pode estar encerrada
              --select * from status_processo
            group by pp.cd_produto),0)) as 'Qtd_Producao',

   sp.nm_status_produto,
   c.nm_grupo_produto,
   cp.nm_categoria_produto
  
  into #TmpSaldosProduto  
  from  
    Produto a with(nolock)  
      Left Outer Join   
    Produto_Saldo b   
      on a.cd_produto = b.cd_produto  
      Inner Join   
    Fase_Produto f  
      on f.cd_fase_produto = b.cd_fase_produto  
      Inner Join   
    Grupo_Produto c   
      on a.cd_grupo_produto = c.cd_grupo_produto  
      Left Outer Join   
    Unidade_Medida d   
      on a.cd_unidade_medida = d.cd_unidade_medida  
    Left outer Join Status_Produto sp with (nolock) on sp.cd_status_produto = a.cd_status_produto 
--                                                       and isnull(sp.ic_bloqueia_uso_produto,'N')='N'
    left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = a.cd_categoria_produto
   
  where   
    (a.cd_produto_baixa_estoque is null or a.cd_produto_baixa_estoque = 0)   
    and (@cd_grupo_produto = 0 or a.cd_grupo_produto = @cd_grupo_produto)   
    and (@cd_produto = 0 or a.cd_produto = @cd_produto)   
    and (@cd_serie_produto = 0 or a.cd_serie_produto = @cd_serie_produto)   
--
--    and (b.qt_saldo_atual_produto < b.qt_minimo_produto or b.qt_saldo_atual_produto < 0)   
--Arrumar para o comparativo
    and (isnull(b.qt_saldo_reserva_produto,0) < b.qt_minimo_produto or isnull(b.qt_saldo_reserva_produto,0) < 0)   
    and (@cd_fase_produto = 0 or b.cd_fase_produto = @cd_fase_produto)   
    and isnull(sp.ic_bloqueia_uso_produto,'N')='N'
      
---------------------------------------------------  
-- Saldos de produtos com baixa de estoque em outro  
---------------------------------------------------  
  
  Select  
    o.cd_grupo_produto            as 'CodGrupoProduto',   
    o.cd_produto                  as 'CodProduto',  
    --dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, o.cd_mascara_produto) as 'MascaraProduto',  
    case
      when isnull(dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto),'') <> '' then
        dbo.fn_formata_mascara(c.cd_mascara_grupo_produto, a.cd_mascara_produto)
      else
        a.cd_mascara_produto
    end as 'MascaraProduto', 
    o.nm_produto                  as 'Descricao',  
    o.nm_fantasia_produto         as 'Produto',   
    b.qt_saldo_reserva_produto    as 'Disponivel',  
    f.nm_fase_produto             as 'Fase',  
    b.qt_saldo_atual_produto      as 'Atual',  
    isnull(b.qt_minimo_produto,0) as 'Minimo',  
--    b.qt_req_compra_produto       as 'Requisicao',  
  
    isnull(b.qt_pd_compra_produto,0)+  
    isnull(b.qt_importacao_produto,0)     as 'PedidoCompra',  
  
    --isnull(b.dt_prev_ent1_produto,'' )    as 'Previsao1',  
    --isnull(b.dt_prev_ent2_produto,'')     as 'Previsao2',  
    --isnull(b.dt_prev_ent3_produto,'')     as 'Previsao3',  
    b.dt_prev_ent1_produto                  as 'Previsao1',  
    b.dt_prev_ent2_produto                  as 'Previsao2',  
    b.dt_prev_ent3_produto                  as 'Previsao3',  
    d.sg_unidade_medida                   as 'UnidadeMedida',  
  
    ConsumoMensal =  
      case   
        when @ic_parametro in (1,3,4,5) then 0 -- Não necessário nesta query  
        else isnull((select sum(me.qt_movimento_estoque)/@cd_meses   
                     from movimento_estoque me  with (nolock) 
                     where (me.cd_produto = o.cd_produto) and  
                           (me.dt_movimento_estoque between @data_inicial and @data_final) and  
                           (me.ic_mov_movimento = 'S')),0)  
      end,  
   IsNUll((select Sum(pii.qt_saldo_item_ped_imp)  
           from pedido_importacao_item pii  with (nolock) 
           where pii.cd_produto = a.cd_produto and  
                 pii.qt_saldo_item_ped_imp > 0 and  
                 pii.dt_cancel_item_ped_imp is null  
           group by pii.cd_produto),0) as 'PedidoImportacao',  
    (isnull(b.qt_req_compra_produto,0) +  
     IsNull((select Sum(rci.qt_item_requisicao_compra)  
            from requisicao_compra_item rci  
                 left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and  
                                                               rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and  
                                                               pii.dt_cancel_item_ped_imp is null  
            where rci.cd_produto = a.cd_produto  
            Group by rci.cd_produto),0)) as 'Requisicao',

    --select * from processo_producao
    (isnull((select sum(pp.qt_planejada_processo)
            from
              processo_producao pp with (nolock) 
            where
              pp.cd_produto       = a.cd_produto and
              pp.dt_canc_processo is null        and 
              pp.cd_status_processo <> 5 --Não pode estar encerrada
              --select * from status_processo
            group by pp.cd_produto),0)) as 'Qtd_Producao',
         

    sp.nm_status_produto,
    c.nm_grupo_produto,
    cp.nm_categoria_produto
 
  into #TmpSaldosOutroProduto  
  from  
    Produto a   with (nolock)
      Inner Join   
    Produto o   
      on a.cd_produto_baixa_estoque = o.cd_produto  
      Left Outer Join   
    Produto_Saldo b   
      on o.cd_produto = b.cd_produto  
      Inner Join   
    Grupo_Produto c   
      on o.cd_grupo_produto = c.cd_grupo_produto  
      Inner Join   
    Fase_Produto f  
      on f.cd_fase_produto = b.cd_fase_produto  
      Left Outer Join   
    Unidade_Medida d   
      on o.cd_unidade_medida = d.cd_unidade_medida  
    Left outer Join Status_Produto sp with (nolock) on sp.cd_status_produto = a.cd_status_produto 
    left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = a.cd_categoria_produto
                                                       --and isnull(sp.ic_bloqueia_uso_produto,'N')='N'

  Where  
    isnull(a.cd_produto_baixa_estoque,0) > 0    
    and (@cd_grupo_produto = 0 or a.cd_grupo_produto = @cd_grupo_produto)   
    and (@cd_produto = 0 or a.cd_produto             = @cd_produto)   
    and (@cd_serie_produto = 0 or a.cd_serie_produto = @cd_serie_produto)   
--    and (b.qt_saldo_atual_produto < b.qt_minimo_produto or b.qt_saldo_atual_produto < 0)   
   and (isnull(b.qt_saldo_reserva_produto,0) < b.qt_minimo_produto or isnull(b.qt_saldo_reserva_produto,0) < 0)   
    and (@cd_fase_produto = 0 or b.cd_fase_produto = @cd_fase_produto)   
    and isnull(sp.ic_bloqueia_uso_produto,'N')='N'
  
  
-- Juntar as duas seleções   
  
  insert into #TmpSaldosProduto  
  select * from #TmpSaldosOutroProduto  
  
end  

-- Seleção final  
  
if @ic_parametro = 1  
begin  
  
  select   
    *,  
    Previsao =  
      case   
        when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
             ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
        when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
        else Previsao3   
      end  
  from #TmpSaldosProduto  
  
  where
     Disponivel < Minimo  
  order by
     Produto  
  
end  

else  

--Saldo Negativo
  
  if @ic_parametro = 2  
  begin  
    if @ic_tipo_saldo = 'A' OR @ic_tipo_saldo = 'D' 
    begin
      select *,  
            Previsao =  
           case when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
                      ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
                when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
           else Previsao3 end,  
           SaldoTotal =  
            (Disponivel + Atual + Requisicao + PedidoCompra)  
   
      from #TmpSaldosProduto  
  
      where
        Disponivel < 0  

      order by 
         Produto  
    end

  -- Real

    if @ic_tipo_saldo = 'R' 
    begin
      select *,  
            Previsao =  
           case when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
                      ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
                when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
           else Previsao3 end,  
           SaldoTotal =  
            (Disponivel + Atual + Requisicao + PedidoCompra)  
   
      from #TmpSaldosProduto  
  
      where
        Atual < 0  

      order by 
         Produto  
    end
    
  end  
else  
  
if @ic_parametro = 3  -- Abaixo do Estoque minimo  
begin  
  
  select   
    *,  
    Previsao =  
      case   
        when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
              ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
        when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
        else Previsao3   
      end  
  from #TmpSaldosProduto  
  
  where Minimo > Atual  
  order by Produto  
  
end  
else  
  
if @ic_parametro = 4 -- Atingiram estoque minimo  
begin  
  
  select   
    *,  
    Previsao =  
      case   
        when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
                    ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
        when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
        else Previsao3   
      end  
  from #TmpSaldosProduto  
  
  where Minimo = Atual  
  order by Produto  
  
end  
  
else  
  
if @ic_parametro = 5 -- Sem definição de estoque  
begin  
  
  select   
    *,  
    Previsao =  
      case   
        when (((Previsao1 < Previsao2) or (Previsao2 is null)) and   
                    ((Previsao1 < Previsao3) or (Previsao3 is null))) then Previsao1  
        when ((Previsao2 < Previsao3) or (Previsao3 is null)) then Previsao2   
        else Previsao3   
      end  
  from #TmpSaldosProdutoDefinicao  
  
  where Minimo = 0  
  order by Produto  
  
end  

