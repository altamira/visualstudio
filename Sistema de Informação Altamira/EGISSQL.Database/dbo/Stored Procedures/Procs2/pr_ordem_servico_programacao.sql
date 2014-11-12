-------------------------------------------------------------------------------------------
Create procedure pr_ordem_servico_programacao
-------------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
-------------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Fabio Cesar
--Banco Dados      : EGISSQL
--Objetivo
--                 : Consulta de Ordens de Serviço Programadas e não realizadas.
-- 09/06/2004 - Acerto no relacionamento de Programacao_Composicao - Daniel C. Neto.
-- 14/06/2004 - Feito rotina para gravar dt_emitida_ordem_fab e ic_emitida_ordem_fab
--            - Daniel C. Neto.
-- 21/06/2004 - Incluído novos campos - Daniel C. Neto.
-- 14/07/2004 - Acrescentado o Campo de Programador  Obs e colocado Não como default do campo
--              de CNC - ELIAS
-- 21.07.2004 - Tirei a macro substituição para uma query normal, atendendo o que propõe a sp
--            - inclusão de campos e deixando o processo com join, pois podem trazer programação
--            - que naum tenham Processo e/ou pedido de venda. Igor
-- 28/07/2004 - Acertado Relacionamento entre as tabelas Processo_Producao e Processo_Producao_Composicao
--              que não deve ser inner devido a possibilidade de existir processo de produção ainda
--              sem composição e que deve ser mostrado aqui. - ELIAS/LUCIO
--              Passa a utilizar o Pedido de Venda e o Item da tabela Programação Composição quando
--              não existir na tabela Processo Produção - ELIAS/LUCIO
-- 29/07/2004 - Acerto conforme pedido pelo Lucio no cd_item_processo, nm_produto_pedido,
-- nm_fantasia_cliente, cd_pedido_venda, cd_item_pedido_venda - Daniel C. Neto.
-- 10/08/2004 - Acerto - Daniel C. Neto.
-- 13/08/2004 - Acerto na dt. MP - Daniel C. Neto
-- 18/08/2004 - Incluído campo de reserva - Daniel C. Neto.
-- 30/09/2004 - Modificado condições para aparecer a palavra RESERVA - Daniel C. Neto.
-- 04.09.2007 - Mostrar o Produto quando não tiver pedido de Venda - Carlos Fernandes
-- 01.11.2007 - Verificação da Ordem de Serviço - Carlos Fernandes
-- 15.03.2010 - Não Mostrar as Ordem de Produção já Encerradas - Carlos Fernandes
-- 06.09.2010 - Nome da Máquina - Carlos Fernandes
-- 29.11.2010 - Quantidade da Programação/Ordem Produção - Carlos Fernandes
-- 01.12.2010 - Data de Entrega do Pedido de Venda - Carlos Fernandes
--------------------------------------------------------------------------------------------
  @cd_maquina_selecionada varchar(200),
  @dt_inicial datetime,
  @dt_final   datetime

as

Begin

  declare @SQL  varchar(8000)
  declare @SQL2 varchar(8000)

set @SQL2 = ''

set @SQL = 
  ' Select  ' + 
  ' p.cd_maquina, ' + 
  ' isnull(isnull(ppc.cd_item_processo,pc.cd_numero_operacao),1) as cd_item_processo, '  + 
  ' p.cd_programacao, ' +
  ' p.hr_inicio_programacao,'+
  ' p.hr_final_programacao,'+
  ' m.qt_ordem_mapa,  ' + 
  ' pc.cd_ordem_fab, ' +
  ' pp.cd_processo, ' +
  ' rtrim(ltrim(m.nm_fantasia_maquina)) +' +''' - '''+'+ rtrim(ltrim(m.nm_maquina) ) as nm_maqcompl_processo, ' +   
  ' p.dt_programacao, ' +  
  ' isnull(c.nm_fantasia_cliente,op.nm_operacao)  as nm_fantasia_cliente, ' +  
  ' isnull(pp.cd_pedido_venda,pc.cd_pedido_venda) as cd_pedido_venda, ' +  
  ' isnull(pp.cd_item_pedido_venda,pc.cd_item_pedido_venda) as cd_item_pedido_venda, ' + 
  ' pc.cd_operacao, ' +  
  ' op.nm_operacao, ' +
  ' pc.qt_hora_prog_operacao, ' + 
  ' nm_produto_pedido = ' + 
     ' case when IsNull(pc.cd_reserva_programacao,0) = 0 then isnull(pvi.nm_produto_pedido,prod.nm_produto) ' + 
          ' else ' + QuoteName('Reserva','''') + ' end, ' + 
--   ' isnull(pvi.dt_entrega_fabrica_pedido, pp.dt_entrega_processo) as dt_entrega_fabrica_pedido, ' + 
  'case when pvi.dt_entrega_vendas_pedido is not null then pvi.dt_entrega_vendas_pedido else pp.dt_entrega_processo end as dt_entrega_fabrica_pedido, '+
   ' case when isnull(pv.cd_cliente,0)>0 then op.nm_operacao else '''' end as nm_obs_operacao, ' +  
   ' IsNull(pp.dt_mp_processo, ' + 
                                   ' (select top 1 dt_item_nec_req_compra' + 
                                   ' from Requisicao_Compra_Item r inner join' +
                                   ' Requisicao_Compra rc on rc.cd_requisicao_compra = r.cd_requisicao_compra inner join' + 
                                   ' Tipo_Requisicao t on t.cd_tipo_requisicao = rc.cd_tipo_requisicao and ' + 
                                                         ' t.ic_tipo_requisicao = ''S'' where ' + 
                                   ' r.cd_pedido_venda = IsNull(pp.cd_pedido_venda, pc.cd_pedido_venda) and ' + 
                                   ' r.cd_item_pedido_venda= IsNull(pp.cd_item_pedido_venda, pc.cd_item_pedido_venda) ' + 
                                   ' order by r.cd_requisicao_compra )) as dt_mp_processo, ' + 

   ' pc.dt_mat_prima_operacao, ' +   
   ' isnull(pc.ic_cnc_operacao,''N'') as ic_cnc_operacao, ' +  
   ' prog.nm_programador_cnc + '' '' + pc.nm_obs_programa_cnc as nm_programador_cnc, ' + 
   ' pc.ds_prog_composicao, ' + 
   ' pc.cd_reserva_programacao, prod.cd_mascara_produto, prod.nm_fantasia_produto, pp.qt_planejada_processo, ' +

   --Quantidade de Producao-----------------------------------------------------------

   '       case when isnull(pc.qt_item_programacao,0) > 0 then
            pc.qt_item_programacao
          else
            pp.qt_planejada_processo
          end                           as qt_producao, pvi.dt_entrega_vendas_pedido ' +


 ' from ' + 
 '  Programacao p  with (nolock) ' + 
 ' inner join ' + 
   ' Programacao_Composicao pc with (nolock) on pc.cd_programacao = p.cd_programacao ' + 
     ' left outer join ' + 
   ' Processo_Producao pp ' + 
     ' on pc.cd_processo = pp.cd_processo ' + 
     ' left outer join ' +
  ' Processo_Producao_Composicao ppc ' +  
    ' on pp.cd_processo = ppc.cd_processo and ' + 
       ' pc.cd_operacao = ppc.cd_operacao and ' + 
       ' pc.cd_item_processo = ppc.cd_item_processo ' + 
     ' left outer join ' + 
   ' Pedido_Venda pv ' + 
     'on isnull(pp.cd_pedido_venda, pc.cd_pedido_venda) = pv.cd_pedido_venda ' + 
     'left outer join Cliente c on pv.cd_cliente = c.cd_cliente ' + 
      'left outer join ' + 
    'Pedido_Venda_Item pvi ' + 
      'on isnull(pp.cd_pedido_venda, pc.cd_pedido_venda) = pvi.cd_pedido_venda ' +  
         'and isnull(pp.cd_item_pedido_venda, pc.cd_item_pedido_venda) = pvi.cd_item_pedido_venda ' + 
      'left outer join ' + 
    'Maquina m ' + 
      'on m.cd_maquina = p.cd_maquina ' + 
      'left outer join ' + 
    'Programador_CNC prog ' + 
      'on prog.cd_programador_cnc = pc.cd_programador_cnc left outer join ' + 
    'Operacao op on op.cd_operacao = pc.cd_operacao ' + 
    'left outer join Produto prod on prod.cd_produto = pp.cd_produto '+
  'where  pp.dt_canc_processo is null and pp.cd_status_processo <> 5 and '

if @cd_maquina_selecionada <> ''
  set @SQL2 = ' IsNull(p.cd_maquina,0) in ( ' + @cd_maquina_selecionada + ') and '

  set @SQL2 = @SQL2 + ' p.dt_programacao between ' + QuoteName(cast(@dt_inicial as varchar),'''') + ' and ' +  
                                                     QuoteName(cast(@dt_final as varchar),'''') + ' and pc.dt_fim_prod_operacao is null ' + 
 ' order by  
    m.qt_ordem_mapa,  
    m.nm_fantasia_maquina,  
    p.dt_programacao,  
    pc.cd_ordem_fab  '

set @SQL2 = @SQL2 + 
 ' update Programacao_Composicao  
  set ic_emitida_ordem_fab = ''S'',
      dt_emitida_ordem_fab = GetDate()
  where cd_programacao in   
                    ( select p.cd_programacao 
                      from Programacao p with (nolock) 
                             inner join   
                           Programacao_Composicao pc with (nolock) on pc.cd_programacao = p.cd_programacao   
                      where ' 

if @cd_maquina_selecionada <> ''
  set @SQL2 = @SQL2 + ' IsNull(p.cd_maquina,0) in ( ' + @cd_maquina_selecionada + ') and '

set @SQL2 = @SQL2 + ' p.dt_programacao between ' + QuoteName(cast(@dt_inicial as varchar),'''') + ' and ' +  
                                                   QuoteName(cast(@dt_final as varchar),'''') + ' and pc.dt_fim_prod_operacao is null )' 

--print(@SQL + @SQL2)

exec(@SQL + @SQL2)

end
 
