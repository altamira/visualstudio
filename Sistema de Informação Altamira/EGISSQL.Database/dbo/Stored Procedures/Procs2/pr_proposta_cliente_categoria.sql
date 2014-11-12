
-----------------------------------------------------------------------------------
--pr_proposta_cliente_categoria
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.                                           2006
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor        : Carlos Cardoso Fernandes       
--Objetivo     : Consulta de Propostas por Cliente e Categoria
--Data         : 04.05.2006
--Atualizado   : 09.05.2006 - Acertos Diversos - Carlos Fernandes
--             : 
--------------------------------------------------------------------------------------

create procedure pr_proposta_cliente_categoria
@cd_cliente int         = 0,
@cd_mapa    varchar(10) = '',
@dt_inicial datetime    = '',
@dt_final   datetime    = '',
@cd_moeda   int         = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

--select * from consulta_itens

select
       a.cd_consulta, 
       a.dt_consulta, 
       b.cd_item_consulta, 
       b.qt_item_consulta, 
       b.nm_produto_consulta,
       b.qt_item_consulta*b.vl_unitario_item_consulta / @vl_moeda as 'total',
       b.dt_entrega_consulta,
       cli.nm_fantasia_cliente,
       b.dt_perda_consulta_itens,
       mp.nm_motivo_perda
from
   consulta a 
   inner join consulta_itens b     on a.cd_consulta      = b.cd_consulta
   inner join Cliente cli          on cli.cd_cliente     = a.cd_cliente
   left outer join motivo_perda mp on mp.cd_motivo_perda = b.cd_motivo_perda
where
   cli.cd_cliente = @cd_cliente                                                                  and
   b.cd_categoria_produto = case when @cd_mapa='' then b.cd_categoria_produto else @cd_mapa end  and
   (a.dt_consulta between @dt_inicial and @dt_final)                                             and
   (b.qt_item_consulta*b.vl_unitario_item_consulta / @vl_moeda) > 0      

order by total desc

