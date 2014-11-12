
------------------------------------------------------------------------------- 
--pr_consulta_lote_produto
-------------------------------------------------------------------------------
--GBS - Global Business Solution	                                   2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar Lote de Produtos
--Data			: 17/11/2004
--Alteração             : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                        16/03/2005 - Separação de tipos de visualização - Daniel C. Neto.
--                        02.05.2005 - Revisão e Acertos - Carlos Fernandes
--                        07.05.2005 - Saldo da Reserva - Carlos Fernandes
--                        28.09.2005 - Corrigido para apresentar somente os Lotes que possuem 
--                                     quantidade disponível. - Rafael Santiago
--                        22.10.2005 - Início da Validade - Carlos Fernandes.
--                        28.10.2005 - Mostrar somente os Lotes Disponíveis - Carlos Fernandes.
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_consulta_lote_produto

@ic_parametro         int,
@cd_produto           int,
@cd_movimento_estoque int = 0,
@cd_lote_produto      int = 0,
@cd_loja              int = 0 

AS

-------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Visualiza a somatória por lotes de produto.
-------------------------------------------------------------------------------------
begin

  SELECT distinct
    0 as Sel,
    l.cd_lote_produto,
    l.nm_ref_lote_produto              as nm_lote_produto,
    ls.qt_saldo_reserva_lote           as qtd_disponivel,
    ls.qt_saldo_atual_lote             as qtd_saldo_atual,
    cast(null as float)                as qtd_sel,
    l.dt_final_lote_produto            as DtValidade,
    p.cd_mascara_produto               as CodigoProduto,
    p.nm_fantasia_produto              as FantasiaProduto,
    p.nm_produto                       as Descricao

   from
     Lote_Produto_item lp 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto and
                                         ls.cd_produto      = lp.cd_produto           
     inner join lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join Produto p        on p.cd_produto       = lp.cd_produto
                 
   where
     lp.cd_produto = @cd_produto        AND
     isnull(ls.qt_saldo_atual_lote,0) > 0
   order by
     l.dt_final_lote_produto


end

-------------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Visualiza o Saldo de lotes 
-------------------------------------------------------------------------------------
begin

   select distinct
     0                                as Selecao,
     l.nm_ref_lote_produto            as Lote,
     lp.cd_lote_produto,
     lp.cd_produto,
     lp.cd_fase_produto, 
     ls.qt_saldo_reserva_lote          as qtd_disponivel,
     ls.qt_saldo_atual_lote            as qtd_saldo_atual,
     cast(null as float)               as qtd_sel,
     lp.dt_inicio_item_lote            as InicioValidade,
     lp.dt_final_item_lote             as FimValidade,
     cast( getdate()-
     lp.dt_final_item_lote as int)     as Dias,
     lp.nm_obs_item_lote_produto       as Observacao,
     lp.qt_comp_item_lote,
     lp.cd_peca_item_lote,
     lp.cd_loja,
     l.nm_lote_produto,
     case when getdate()>lp.dt_final_item_lote then 'Vencido' else '' end as Status,
     und.sg_unidade_medida,
     ( case when lp.ic_status_item_lote = 'A' then 'Aberto' 
            when lp.ic_status_item_lote = 'B' then 'Bloqueado'
            end ) as 'ic_status_item_lote'
   from
     Lote_Produto_item lp 
     inner join lote_produto_saldo ls   on ls.cd_lote_produto = lp.cd_lote_produto and
                                           ls.cd_produto      = lp.cd_produto           
     inner join lote_produto l          on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join unidade_medida und on und.cd_unidade_medida = lp.cd_unidade_medida
                      
   where
     lp.cd_produto = @cd_produto and
     lp.cd_lote_produto = (case when @cd_lote_produto = 0 then lp.cd_lote_produto 
                                else @cd_lote_produto end ) 
   order by
     lp.dt_final_item_lote,
     l.nm_ref_lote_produto

end

-------------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Visualiza a somatória por lotes de produto - Loja
-------------------------------------------------------------------------------------
begin

  SELECT distinct
    0 as Sel,
    lpi.cd_lote_produto,
    lpi.nm_lote_produto,
    sum(lpi.qt_comp_reserva_item_lote) as qtd_disponivel,
    cast(null as float)                as qtd_sel,
    min(dt_final_item_lote)           as DtValidade,
    l.cd_loja,
    l.nm_fantasia_loja
  FROM         
    Lote_produto_Saldo lpi left outer join
    Loja l on l.cd_loja = lpi.cd_loja
  where
   lpi.cd_produto = @cd_produto and
   lpi.qt_comp_reserva_item_lote > 0 
  group by
    lpi.cd_lote_produto,
    lpi.nm_lote_produto,
    l.cd_loja,
    l.nm_fantasia_loja
  order by 1

end
-------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Visualiza o Saldo de lotes por peça.
-------------------------------------------------------------------------------------
begin

   select distinct
     0                                as Selecao,
     lp.nm_lote_produto                as Lote,
     lp.cd_lote_produto,
     lp.cd_produto,
     lp.cd_loja,
     lp.cd_fase_produto,
     lp.qt_comp_reserva_item_lote    as qtd_disponivel,
     cast(null as float)             as qtd_sel,
     lp.dt_final_item_lote             as FimValidade,
     cast( getdate()-
     lp.dt_final_item_lote as int)  as Dias,
     lp.nm_obs_item_lote_produto            as Observacao,
     case when getdate()>lp.dt_final_item_lote then 'Vencido' else '' end as Status,
     und.sg_unidade_medida,
     loj.nm_fantasia_loja,
     lp.cd_peca_item_lote,
     lp.cd_box_item_lote,
     ( case when lp.ic_status_item_lote = 'A' then 'Aberto' 
            when lp.ic_status_item_lote = 'B' then 'Bloqueado'
            end ) as 'ic_status_item_lote',
     c.nm_cor,
     ( select top 1 
         x.nm_desenho_projeto
       from
         Desenho_projeto x 
       where x.cd_desenho_projeto = lp.cd_desenho_projeto) as nm_desenho,
     lp.qt_comp_reserva_item_lote * lp.qt_largura_item_lote as qt_reserva_m2_item_lote,
     ( case when IsNull(lp.qt_largura_item_lote,0) = 0 then 1 else 0 end) as qtd_largura,
     ( IsNull(lp.qt_comp_reserva_item_lote,0) * IsNull(lp.qt_largura_item_lote,0) ) / --1 
      ( case when IsNull(lp.qt_largura_item_lote,0) = 0 then 1 else IsNull(lp.qt_largura_item_lote,0) end) 
as qt_saldo_ml_item_lote,
     lp.qt_largura_item_lote,
     lp.qt_comp_item_lote
   from
     Lote_produto_Saldo lp 
     left outer join unidade_medida und    on und.cd_unidade_medida = lp.cd_unidade_medida
     left outer join Loja loj on loj.cd_loja = lp.cd_loja
     left outer join cor c on c.cd_cor = lp.cd_cor
                      
   where
     lp.cd_produto = @cd_produto and
     lp.cd_lote_produto = (case when @cd_lote_produto = 0 then lp.cd_lote_produto 
                                else @cd_lote_produto end ) and
     lp.cd_loja = @cd_loja 
   order by
     lp.cd_peca_item_lote,
     lp.dt_final_item_lote,
     lp.nm_lote_produto

end


