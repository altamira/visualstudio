
-------------------------------------------------------------------------------
--pr_mapa_producao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Produção por Produto
--Data             : 08.06.06
--Alteração        : 20/11/2006 - Modificado nome de Entrega para Entrega PCP - Daniel C. Neto.
--                 : 10.12.2006 - Cliente/Pedido - Carlos fernandes
--                 : 10.01.2007 - acrescentando coluna nm_situacao_op - Anderson
--                 : 17.02.2007 - verificado as datas de programação  - Carlos Fernandes
--                 : 03.09.2007 - Acertos Diversos - Carlos Fernandes
--                 : 27.10.2007 - Data da Reprogramação - Carlos Fernandes
----------------------------------------------------------------------------------------
create procedure pr_mapa_producao_produto  
@ic_parametro int      = 0,  
@cd_processo  int      = 0,  
@cd_produto   int      = 0,  
@dt_inicial   datetime = '',  
@dt_final     datetime = ''  
  
as  
  
--select * from processo_producao  
  
if @ic_parametro = 1  
begin  
  
  DECLARE Cur_Data CURSOR  
  FOR  
    select a.dt_agenda  
    from Agenda a  
    where   
       a.dt_agenda between @dt_inicial and @dt_final  
    
  OPEN Cur_Data  
  
  declare @sql      varchar(8000)  
  declare @sql2     varchar(8000)  
  declare @RowCount int  
  declare @dt_data  datetime  
  
  FETCH NEXT FROM Cur_Data into @dt_data  

  set @sql      = ''  
  set @sql2     = ''  
  set @RowCount = 0  

  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  if @RowCount < 70   
   begin  

    set @sql = @sql + ',Cast((case when(DATEDIFF(day,[De],'''+Convert(char(10), @dt_data, 103)+''')>=0 )and (DATEDIFF(day,[Até],'''+Convert(char(10), @dt_data, 103)+''')<=0 ) then''S''else''N''end)'    
                           +' as  Char(9))as['+ dbo.fn_strzero(cast( day(@dt_data)   as varchar(02)),2)   
                           +'/'+dbo.fn_strzero(cast( month(@dt_data) as varchar(02)),2)   
                           +']'  
   end   
   else if @RowCount < 140   
   begin  
    set @sql2 = @sql2 + ',Cast((case when('''+Convert(char(10), @dt_data, 103)+''' >=[DE])and '''+Convert(char(10), @dt_data, 103)+'''<=[Até] then''S''else''N''end)'    
                           +' as  Char(9))as['+ dbo.fn_strzero(cast( day(@dt_data)   as varchar(02)),2)   
                           +'/'+dbo.fn_strzero(cast( month(@dt_data) as varchar(02)),2)   
                           +']'  
   end   

   set @RowCount = @RowCount + 1  

  
   FETCH NEXT FROM Cur_Data into @dt_data  
  
  END  
  
  CLOSE Cur_Data  
  DEALLOCATE Cur_Data  
  
  print (@sql)  
  print (@sql2) 
  
  --Montagem da Tabela Auxiliar  
  
 select  
        pp.cd_processo                                             as [Processo],  
        pp.dt_processo                                             as [Emissão],  
        isnull(pp.qt_prioridade_processo,0)                        as [Prioridade],  
        isnull(pp.cd_pedido_venda,0)                               as Pedido,  
        isnull(pp.cd_item_pedido_venda,0)                          as Item,  
        isnull(c.nm_fantasia_cliente,'')                           as Cliente,  
--    pp.cd_produto   
        p.cd_mascara_produto                                          as [Código],  
       (p.nm_fantasia_produto)                                        as Fantasia,  
        p.nm_produto                                                  as [Descrição],  
        um.sg_unidade_medida                                          as [Unid.],  
        isnull(pp.qt_planejada_processo,0)                            as [Quantidade  ],  
        isnull(pp.dt_prog_processo,pp.dt_processo)                    as [Data Programação],  
        isnull(pvi.dt_entrega_vendas_pedido,pp.dt_entrega_processo)   as [Data Comercial],
        pp.dt_entrega_processo                                        as [Entrega PCP],  
        pvi.dt_reprog_item_pedido                                     as [Reprogramação],
        cast((pp.dt_entrega_processo - 
        isnull(pvi.dt_entrega_vendas_pedido,pp.dt_entrega_processo))
        as int )                                                      as [Dias],
        isnull(pp.nm_situacao_op,'')                                  as [Situação],  

    ( select top 1 min(isnull(ppp.dt_programacao_processo,ppp.dt_estimada_operacao)) from Processo_Producao_Composicao ppp  
      where  
         ppp.cd_processo = pp.cd_processo ) as [De],  
  
    ( select top 1 max(isnull(ppp.dt_programacao_processo,ppp.dt_estimada_operacao)) from Processo_Producao_Composicao ppp  
      where  
         ppp.cd_processo = pp.cd_processo ) as [Até],  
  
     datepart(week,dt_entrega_processo)     as Semana  
  
--select * from Processo_Producao  
  
  into #AuxProcesso   
  from  
   Processo_Producao pp                  with (nolock)  
   inner join Produto p                  with (nolock) on p.cd_produto             = pp.cd_produto  
   left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida     = p.cd_unidade_medida  
   left outer join Cliente        c      with (nolock) on c.cd_cliente             = pp.cd_cliente  
   left outer join Pedido_Venda_item pvi with (nolock) on pvi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
  where  
    pp.cd_processo = case when @cd_processo = 0 then pp.cd_processo else @cd_processo end and  
    pp.cd_produto  = case when @cd_produto  = 0 then pp.cd_produto  else @cd_produto  end and  
    pp.dt_fimprod_processo is null and          --Op. Baixa/encerrada não Entra na Consulta 
--    pp.dt_processo between @dt_inicial and @dt_final  
   pp.dt_entrega_processo between @dt_inicial and @dt_final

  order by  
    pp.qt_prioridade_processo,  
    pp.dt_entrega_processo,  
    p.nm_fantasia_produto  
  
 end  

--select * from processo_producao
--select * from #AuxProcesso
--select * from pedido_venda_item

 --print @sql
 --print @sql2
    
 --print('Select * '+@sql+@sql2+'  from #AuxProcesso')    
 Exec('Select * '+@sql+@sql2+' from #AuxProcesso')    
  
--   
-- --Operações  
--   
if @ic_parametro = 2  
begin  
  --select * from processo_producao_composicao  
  --select * from maquina  
  select  
    ppc.cd_seq_processo,  
    ppc.cd_maquina,  
    m.nm_fantasia_maquina,  
    ppc.cd_operacao,  
    o.nm_fantasia_operacao,  
    ppc.qt_hora_estimado_processo,  
    ppc.qt_hora_real_processo,  
    ppc.qt_hora_setup_processo,  
    isnull(ppc.dt_programacao_processo,ppc.dt_estimada_operacao) as dt_estimada_processo,  
    pc.qt_hora_prog_operacao,  
    pr.dt_programacao,  
    pr.cd_maquina                 as cd_maquina_programacao  
  from  
    Processo_Producao pp                        with (nolock)  
    inner join Processo_Producao_Composicao ppc with (nolock) on ppc.cd_processo     = pp.cd_processo  
    left outer join Maquina m                   with (nolock) on m.cd_maquina        = ppc.cd_maquina  
    left outer join Operacao o                  with (nolock) on o.cd_operacao       = ppc.cd_operacao  
    left outer join Programacao_Composicao pc   with (nolock) on pc.cd_processo      = pp.cd_processo       and  
                                                                 pc.cd_processo      = ppc.cd_processo      and  
                                                                 pc.cd_item_processo = ppc.cd_item_processo and  
                                                                 pc.cd_operacao      = ppc.cd_operacao    
    left outer join Programacao pr              with (nolock) on pr.cd_programacao   = pc.cd_programacao  
  where  
    pp.cd_processo = case when @cd_processo = 0 then pp.cd_processo else @cd_processo end and  
    pp.cd_produto  = case when @cd_produto  = 0 then pp.cd_produto  else @cd_produto  end   
  
  order by  
    ppc.cd_seq_processo  
   
end  

