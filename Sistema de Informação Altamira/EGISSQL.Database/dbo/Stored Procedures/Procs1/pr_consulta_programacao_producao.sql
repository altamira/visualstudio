
CREATE PROCEDURE pr_consulta_programacao_producao
---------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                2004
---------------------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consultar Programação de Uma máquina Escolhida.
--Data          : 30/04/2004
--                17/04/2004 - Incluído campos de legendas - Daniel C. Neto.
--              : 20/06/2004 - Verificação e colocação de mais algumas colunas
-- 06/08/2004 - Colocado order by cd_seq_processo - Daniel C. Neto.
-- 13/08/2004 - Incluído 3 novos campos - Daniel C. Neto.
-- 16/08/2004 - Acerto no cd_programacao - Daniel C. Neto.
-- 15/09/2004 - Incluído campo de Dt. Final de Prog. - Daniel C. Neto.
-- 20/09/2004 - Feito tratamento de serviços especiais - Daniel C. Neto.
-- 29/09/2004 - Incluído campo de Serviço especial, tirado tratamento - Daniel C. Neto.
-- 28/02/2005 - Incluído ds_processo - Daniel C. Neto.
-- 02.09.2007 - Acertos Diversos - Carlos Fernandes
-- 05.09.2007 - Complemento com uma Data de previsão/simulação de Programação - Carlos Fernandes
-- 06.09.2007 - Controle do Tempo da Operação Total ou somente o Tempo da Operação - Carlos Fernandes
-- 21.09.2007 - Verifica se mostra o fim de Produção - Carlos Fernandes
-- 31.10.2007 - Agrupamento de Operação - Carlos Fernandes
-- 08.01.2008 - Verificação da Data do Fim de Produção - Carlos Fernandes
-- 20.08.2008 - Ajuste da Observação - Carlos Fernandes
-- 19.05.2009 - Novo campo de Observação da Programação do Item - Carlos Fernandes
-- 24.01.2010 - Máquina Programada - Carlos Fernandes
-- 15.03.2010 - Não Mostrar OP's canceladas e Op's Encerradas - Carlos Fernandes/Luis
-- 06.09.2010 - Conversão do tempo do Processo para Hora - Carlos Fernandes
--              Checagem das datas de programação inicial/final
---------------------------------------------------------------------------------------------------------------------
@ic_parametro  int,
@cd_filtro     int,
@dt_base       datetime

AS

--Parâmetro_Manufatura
--Busca os parâmetros, para início da  Programação
--                     e    final para Geração do Prazo de entrega

	declare @qt_dia_inicio_operacao int
	declare @qt_dia_fim_operacao    int
	
	select
	  @qt_dia_inicio_operacao = isnull(qt_dia_inicio_operacao,0),
	  @qt_dia_fim_operacao    = isnull(qt_dia_fim_operacao,0)
	from
	  Parametro_Manufatura with (nolock) 
	where
	  cd_empresa = dbo.fn_empresa()

---------------------------------------------------------------------------------------------------------------------
--Tipo do Tempo de Programação
---------------------------------------------------------------------------------------------------------------------
--Total ( Operação + Setup )
--Tempo da Operação
---------------------------------------------------------------------------------------------------------------------
--select * from parametro_programacao

declare @ic_tipo_programacao      char(1)
declare @ic_conv_hora_programacao char(1)


select
  @ic_tipo_programacao      = isnull(ic_tipo_programacao,'T'),
  @ic_conv_hora_programacao = isnull(ic_conv_hora_programacao,'N')

from
  parametro_programacao with (nolock) 

where
  cd_empresa = dbo.fn_empresa()

--select * from processo_producao_composicao

-------------------------------------------------------------
if @ic_parametro = 1 -- Faz filtro por processo.
-------------------------------------------------------------
begin

	select 
	  --Composição do Processo de Produção
          pps.cd_processo,
          pps.cd_item_processo,
          pps.cd_seq_processo,
          pps.cd_maquina,
          pps.nm_maqcompl_processo,
          pps.cd_operacao,
          pps.nm_opecompl_processo,

          (case when @ic_tipo_programacao='O'
          then 
            isnull(pps.qt_hora_estimado_processo,0)
          else
	    isnull(pps.qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0)

          end )
          /
          case when @ic_conv_hora_programacao = 'S' then
            60
          else
            1
          end

          as qt_hora_estimado_processo,

          pps.qt_hora_real_processo,
          pps.dt_prog_mapa_processo,
          pps.cd_servico_especial,
          pps.ic_operacao_mapa_processo,
          pps.nm_obs_item_processo, 
          pps.cd_grupo_maquina,
          pps.cd_usuario,
          pps.dt_usuario,
          pps.qt_seq_ant_processo,
          pps.qt_dia_processo,

          pps.dt_programacao_processo,

          pps.ic_apontamento_operacao,

          pps.qt_hora_setup_processo
          /
          case when @ic_conv_hora_programacao = 'S' then
            60
          else
            1
          end  as qt_hora_setup_processo,


          pps.dt_estimada_operacao,
          pps.cd_ordem,
          pps.cd_fornecedor,
          pps.cd_composicao_proc_padrao,
          pps.ic_movimenta_estoque,
          pps.cd_maquina_processo,
          pps.ic_operacao_priorizada,
          pps.ic_inspecao_operacao,

          (case when @ic_tipo_programacao='O'
          then
	    isnull(pps.qt_hora_estimado_processo,0)
          else 
	    isnull(pps.qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0)
          end) 
          /
          case when @ic_conv_hora_programacao = 'S' then
            60
          else
            1
          end


          as qt_hora_sem_edicao,
         

    (case when IsNull(pps.cd_maquina_processo,0) > 0 then  
                                                                            pps.cd_maquina_processo else
                                                                              m.cd_maquina end )
                                                                              as cd_maquina_certa,

    (case when IsNull(pps.cd_maquina_processo,0) > 0 then  'S' else 'N' end ) as ic_outra_maquina,


	  --Operação 
	  op.nm_fantasia_operacao,
	  op.nm_operacao,
	  op.pc_programacao_operacao,
	  IsNull(op.ic_mapa_operacao,'N')        as ic_mapa_operacao,
	  isnull(op.ic_mat_prima_operacao,'N')   as ic_mat_prima_operacao,
	  isnull(op.ic_anterior_operacao,'N')    as ic_anterior_operacao,
          isnull(op.qt_dia_prog_operacao,0)      as qt_dia_prog_operacao,
          isnull(op.ic_agrupamento_operacao,'N') as ic_agrupamento_operacao,

	  --Máquina
	  m.nm_fantasia_maquina,
	  IsNull(m.ic_mapa_producao,'N')         as 'ic_mapa_producao',
	
	  case when m.ic_processo_maquina = 'D'
          then m.nm_maquina
          else m.nm_fantasia_maquina end         as nm_maquina,

          --Máquina Original do Processo

	  case when mo.ic_processo_maquina = 'D'
          then mo.nm_maquina
          else mo.nm_fantasia_maquina end         as nm_maquina_original,

 
	  --Pedido de Venda
	  pv.cd_vendedor,
	  pv.cd_vendedor_interno,

	  --Cliente
	  c.nm_fantasia_cliente,

	  --Item do Pedido de Venda
	  pvi.qt_item_pedido_venda,
	  pvi.dt_item_pedido_venda,
	  pvi.dt_entrega_vendas_pedido,
	  pvi.dt_entrega_fabrica_pedido,
	  pvi.nm_produto_pedido,
	
	  --Vendedor
	  vi.nm_fantasia_vendedor as nm_vendedor_interno,
	  v.nm_fantasia_vendedor,
	
	  --Projeto
	  pj.cd_interno_projeto,
	  pj.dt_inicio_projeto,
	  pj.dt_entrada_projeto,
	  pj.dt_entrega_cliente,
	  pji.nm_item_desenho_projeto,
	
	  ( select top 1 pji.nm_item_desenho_projeto +'/'+cast(pcm.cd_projeto_material as varchar) 
	    from Projeto_Composicao_Material pcm with (nolock) 
	    where
	      pcm.cd_projeto = pp.cd_projeto and
	      pcm.cd_item_projeto = pp.cd_item_projeto ) as 'Material',
	
	  --Produto
	  dbo.fn_mascara_produto(pp.cd_produto) as 'cd_mascara_produto',
	  p.nm_fantasia_produto,
	  p.nm_produto,
	  un.sg_unidade_medida,
	  fp.nm_fase_produto,
	
	  --Processo 
	  pp.cd_pedido_venda,
	  pp.cd_item_pedido_venda,
	  pp.qt_planejada_processo as qtd_produto, --Quantidade de Produto
	  pp.dt_processo,                          -- Falta definição.
	  pp.dt_prog_processo,
       -- pp.dt_mp_processo,

          --Data da Matéria-Prima
          dt_mp_processo =
          isnull((select top 1 rci.dt_item_nec_req_compra  
          from Requisicao_Compra_Item rci with (nolock) 
          where pp.cd_pedido_venda = rci.cd_pedido_venda and
                pp.cd_item_pedido_venda = rci.cd_item_pedido_venda
          order by rci.cd_requisicao_compra),pp.dt_mp_processo),

	  --Data de Fim de Produção

	  ( select top 1 x.dt_fim_prod_operacao
	    from Programacao_Composicao x with (nolock) 
                 inner join Programacao y with (nolock) on y.cd_programacao = x.cd_programacao
                 
	    where 
                  y.cd_maquina       = pps.cd_maquina            and
                  x.cd_processo      = pps.cd_processo           and
                  x.cd_operacao      = op.cd_operacao            and
                  x.cd_item_processo = pps.cd_item_processo and
	          x.dt_fim_prod_operacao is not null ) as dt_fim_prod_operacao, 
	
          (case when @ic_tipo_programacao='O'
          then
	    isnull(pps.qt_hora_estimado_processo,0)
          else 
	    isnull(pps.qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0) 
          end

          - 

	  case when isnull(pc_programacao_operacao,0) <> 0 then
	    ( pc_programacao_operacao * pps.qt_hora_estimado_processo  / 100 ) 
	    else 
              0.00
          end)
          /
          case when @ic_conv_hora_programacao = 'S' then
            60
          else
            1
          end

                                            as qt_hora_calculado_processo,

	  case when dbo.fn_disponibilidade_maquina(m.cd_maquina, pps.dt_programacao_processo) = 0 or
	          IsNull(( select top 1 x.ic_operacao
	                   from Maquina_Turno x with (nolock) 
	                   where x.cd_maquina = m.cd_maquina and
	                         x.ic_operacao = 'S'),'N') = 'N' then 'N' else 'S' end as ic_disponivel,
	
	  --Dados da Programação
	  --Carlos 20/6/2004
	  
	  --Data de Início do Processo
	  case when pp.dt_inicio_processo is not null then isnull(pp.dt_inicio_processo,getdate()) 
	                                              else isnull(pp.dt_mp_processo,getdate()) + @qt_dia_inicio_operacao end as 'dt_inicio_processo',
	
	  --Data Disponível da Máquina para Programação          
	  a.dt_disp_carga_maquina,
	
	  --Código da Programação
	  cd_programacao = ( select top 1 
	                       pc.cd_programacao
                             from programacao_composicao pc with (nolock) 
	                     where pc.cd_processo      = pps.cd_processo and
                                   pc.cd_item_processo = pps.cd_item_processo ),
	  
	
	  --item da Programação
	  cd_item_programacao = ( select top 1 
	                            cd_item_programacao 
	                          from programacao_composicao with (nolock) 
	                          where cd_processo      = pps.cd_processo and
	                                cd_item_processo = pps.cd_item_processo ),

          dt_final_programacao = ( select max(p.dt_programacao)
                                   from programacao p with (nolock) 
                                   inner join
                                   programacao_composicao pc with (nolock) on pc.cd_programacao = p.cd_programacao
	                           where cd_processo       = pps.cd_processo and
	                                  cd_item_processo = pps.cd_item_processo ),
   pp.nm_processista,
   u.nm_fantasia_usuario,
   isnull(se.nm_servico_especial,'')             as nm_servico_especial,
   rtrim(ltrim(cast(pp.ds_processo         as varchar(4000))))+' '+
   rtrim(ltrim(cast(pp.ds_processo_fabrica as varchar(4000)))) as 'ds_processo',
   cast(pp.ds_processo_fabrica as varchar(4000))               as 'ds_processo_fabrica',
 
--select * from processo_producao where cd_processo = 19281

   --Data da Programacao Inicial  

   ProgInicial =
    dbo.fn_data_programacao(    m.cd_maquina,
                                a.dt_disp_carga_maquina+IsNull(pps.qt_dia_processo,0),
                                (pps.qt_hora_estimado_processo 
                                /
                               case when @ic_conv_hora_programacao = 'S' then
                                 60
                               else
                                 1
                               end)
                                
                                ,0) ,

    --Data da Programacao Final

    ProgFinal = 
    dbo.fn_data_programacao( m.cd_maquina, 
                             a.dt_disp_carga_maquina+IsNull(pps.qt_dia_processo,0),
                                (pps.qt_hora_estimado_processo 
                                /
                               case when @ic_conv_hora_programacao = 'S' then
                                 60
                               else
                                 1
                               end) ,1),

    case when pp.dt_prog_processo is null then 'N'
                                          else 'S' end as Programado,

    isnull(pps.qt_hora_prog_processo,0)                as qt_hora_prog_processo
	
	from 
	  Processo_producao pp                             with (nolock)
	  left outer join Processo_Producao_Composicao pps with (nolock) on pp.cd_processo = pps.cd_processo
	  left outer join Operacao op                      with (nolock) on op.cd_operacao = pps.cd_operacao
          left outer join Maquina mo                       with (nolock) on mo.cd_maquina  = pps.cd_maquina
	  left outer join Maquina m                        with (nolock) on m.cd_maquina   = (case when IsNull(pps.cd_maquina_processo,0) > 0 then  
                                                                              pps.cd_maquina_processo else
                                                                              pps.cd_maquina end ) 
	  left outer join Pedido_Venda pv                  on pv.cd_pedido_venda = pp.cd_pedido_venda
	  left outer join Pedido_Venda_Item pvi            on pvi.cd_pedido_venda = pp.cd_pedido_venda and
	                                                      pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
	  left outer join Vendedor v                       on v.cd_vendedor = pv.cd_vendedor
	  left outer join Projeto pj                       on pj.cd_projeto = pp.cd_projeto
	  left outer join Projeto_Composicao pji           on pji.cd_projeto = pp.cd_projeto and
	                                                      pji.cd_item_projeto = pp.cd_item_projeto
	  left outer join Cliente c                        on c.cd_cliente = IsNull(pv.cd_cliente,pj.cd_cliente)
	  left outer join Fase_Produto fp                  on fp.cd_fase_produto = pp.cd_fase_produto
	  left outer join Produto p                        on p.cd_produto = pp.cd_produto 
	  left outer join Unidade_Medida un                on un.cd_unidade_medida = p.cd_unidade_medida
	  left outer join Vendedor vi                      on vi.cd_vendedor = pv.cd_vendedor_interno
	  left outer join Carga_maquina a                  on m.cd_maquina = a.cd_maquina 
          left outer join EGISADMIN.dbo.Usuario u          on u.cd_usuario = pp.cd_usuario_mapa_processo
          left outer join Servico_especial se              on se.cd_servico_especial = pps.cd_servico_especial
	
	where 
	  pp.cd_processo = @cd_filtro and
          isnull(pp.ic_libprog_processo,'N') = 'S' and --Verifica se o Processo nao foi liberado 
          isnull(pp.ic_mapa_processo,'N')    = 'S' and --Verifica se o Processo e' programado no Mapa
          isnull(m.ic_mapa_producao,'N')     = 'S' and --Verifica se a Máquina Recebe Programação
          isnull(op.ic_mapa_operacao,'N')    = 'S' and --Verifica se a Operação é Programada no Mapa
          isnull(m.cd_maquina,0)>0                 and --Verifica se a Máquina foi Informada 
          pp.dt_canc_processo is null              and --Processo não pode estar Cancelado
          pp.cd_status_processo <> 5                   --Processo não pode estar Encerrado
             

  order by
    pps.cd_seq_processo

end


