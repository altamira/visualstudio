
CREATE PROCEDURE pr_controle_ordem_producao
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
------------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		:  Realizar consulta para controle de ordem de produção
--Data		        : 07.04.2004
--Alteração : 31.05.2004 - Inclusão de novo filtro por processo. Igor Gama
--29.01.2009 - Ajustes Diversos - Carlos Fernandes
-- 13.12.2010 - Verificação do Lote - Carlos Fernandes 
------------------------------------------------------------------------------------------------------------------
@ic_parametro  as int      = 0,
@dt_inicial    as DateTime,
@dt_final      as DateTime,
@cd_op         as int      = 0
as

declare 
  @cd_processo int,
  @cd_chave    int

set @cd_op = isnull(@cd_op,0)

---------------------
--Processo Produção
---------------------
--select * from processo_producao

  select
    identity(int,1,1) as 'cd_chave',
    pp.cd_processo,
    pp.dt_processo,
    pp.cd_identifica_processo,
    pp.cd_usuario,
    pp.dt_usuario,
    pp.cd_fase_produto,
    pp.cd_status_processo,
    pp.qt_planejada_processo,
    pp.dt_entrega_processo,
    pp.cd_produto,
    pp.cd_pedido_venda,
    pp.cd_item_pedido_venda,
    cast(pp.ds_processo as varchar(2000))as 'ds_processo',
    pp.dt_liberacao_processo,
    pp.dt_canc_processo,
    pp.dt_encerramento_processo,
    pp.cd_processo_padrao,
    pp2.nm_identificacao_processo,
    pp2.nm_processo_padrao,
    sp.sg_status_processo,
    sp.nm_status_processo,
    fp.sg_fase_produto,
    cast(null as varchar(15)) as fase_1,
    cast(null as varchar(15)) as fase_2,
    cast(null as varchar(15)) as fase_3,
    cast(null as varchar(15)) as fase_4,
    cast(null as varchar(15)) as fase_5,
    cast(null as varchar(15)) as fase_6,
    cast(null as varchar(15)) as fase_7,
    cast(null as varchar(15)) as fase_8,
    cast(null as varchar(15)) as fase_9,
    cast(null as varchar(15)) as fase_10    ,
    pp.cd_lote_produto_processo
  into #Temp_1
  from
    Processo_Producao pp                 with (nolock) 
    left outer join Processo_Padrao pp2  with (nolock) on (pp.cd_processo_padrao = pp2.cd_processo_padrao) 
    left outer join Status_Processo sp   with (nolock) on (pp.cd_status_processo = sp.cd_status_processo)
    left outer join Fase_produto fp      with (nolock) on (pp.cd_fase_produto    = fp.cd_fase_produto)    
  where 
    dt_processo between case When @cd_op = 0 then @dt_inicial else dt_processo end and 
                        case When @cd_op = 0 then @dt_final   else dt_processo end and
    pp.cd_processo = case When @cd_op = 0 then pp.cd_processo else @cd_op      end

-------------------
-- Apontamentos
-------------------

select 
  cd_chave,
  cd_processo
into 
  #Temp_2 
from 
  #Temp_1 
order by cd_chave

----------------------------------------------------------
-- Atualização dos  Apontamentos no Processos de Produção
----------------------------------------------------------
while exists(select 'x' from #Temp_2)
begin
  select top 1
    @cd_processo = cd_processo,
    @cd_chave    = cd_chave
  from #Temp_2
  order by cd_chave

  select top 10
    identity(int,1,1)             as cd_chave,
    ppf.cd_processo,
    fp.sg_fase_producao

 --   case 
 --     when pp.ic_estado_processo = 'S' then '#' 
  --    when ppa.cd_processo_apontamento is null then '' 
  --  else '@' end as ic_status
  into #Temp_3
  from 
  Processo_Producao_fase ppf       with (nolock) 
  left outer join Fase_producao fp with (nolock) on (ppf.cd_fase_producao=fp.cd_fase_producao)
  where
    ppf.cd_processo = @cd_processo

 update #Temp_1
  set
    fase_1 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 1),
    fase_2 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 2),
    fase_3 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 3),
    fase_4 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 4),
    fase_5 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 5),
    fase_6 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 6),
    fase_7 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 7),
    fase_8 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 8),
    fase_9 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 9),
    fase_10 = ( select /*ic_status*/ + sg_fase_producao from #Temp_3 where cd_chave = 10)

where
    cd_chave = @cd_chave

  delete from #Temp_2 
  where cd_chave = @cd_chave

  drop table #Temp_3

end
    
select * 
from #Temp_1

drop table #Temp_1
drop table #Temp_2

--end

