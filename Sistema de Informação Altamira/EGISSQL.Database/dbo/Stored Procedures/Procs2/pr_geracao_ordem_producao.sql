
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_ordem_producao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Ordem de Produção
--Data             : 01/06/2007
--Alteração        : 10.06.2007
--                 : 06.07.2007 - Verificação dos textos das operações - Carlos Fernandes
--                 : 28.09.2007 - Acerto dos Campos - Carlos Fernandes
--                 : 05.10.2007 - Número do Desenho - Carlos Fernandes
--                 : 11.10.2007 - Geração da Composição - Carlos Fernandes
--                 : 18.12.2007 - Revisão do Número do Desenho - Carlos Fernandes.
-- 25.10.2008 - Ajuste de campos da tabela - Carlos Fernandes
-- 10.12.2008 - Novos atributos - Carlos Fernandes
-- 15.06.2010 - Novos atributos - Carlos Fernandes
-- 20.08.2010 - Gravação da Ordem de Produção dos Filhos na Ordem Principal - Carlos Fernandes
-- 03.09.2010 - Gravar o Número do Plano do MRP - Carlos Fernandes
-- 08.09.2010 - Flag para verificação de qual processo padrão irá trazer - Carlos Fernandes
--              ( Padrão de Custo )
-- 21.09.2010 - Multiplicação pela quantidade do Processo - Carlos Fernandes
----------------------------------------------------------------------------------------------
create procedure pr_geracao_ordem_producao
@cd_processo_origem int = 0,
@cd_usuario         int = 0

as

--select * from processo_producao
--select * from processo_padrao

-------------------------------------------------------------------------------
--Processo Principal
-------------------------------------------------------------------------------

declare @cd_processo_padrao_origem int
declare @qt_planejada_processo     float

 select
   @cd_processo_padrao_origem = isnull(cd_processo_padrao,0),
   @qt_planejada_processo     = isnull(qt_planejada_processo,0)
 from
   processo_producao with (nolock) 
 where
   cd_processo = @cd_processo_origem
 
--select * from  #processo_producao

-------------------------------------------------------------------------------
--Componentes do Processo Principal, verificando se existe processo padrão
-------------------------------------------------------------------------------
--select * from processo_producao_componente where cd_processo = @cd_processo_origem

select
  *
into
  #composicao
from
  dbo.fn_composicao_processo_producao( @cd_processo_origem )

  --deleta o processo padrão de Origem
  delete from #composicao where cd_processo_padrao = @cd_processo_padrao_origem

  --select * from #composicao

  declare @qt_processo int

  select
    @qt_processo = count(*)
  from
    #composicao

  -------------------------------------------------------------------------------
  --Quantidade de Processo que serão gerados
  -------------------------------------------------------------------------------

  --select @qt_processo

  declare @Tabela                 varchar(50)
  declare @cd_processo            int
  declare @cd_processo_padrao     int
  declare @cd_fase_produto        int
  declare @qt_produto_composicao  float
  declare @cd_produto             int
  declare @cd_desenho_produto     varchar(30)
  declare @cd_rev_desenho_produto varchar(5)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Processo_Producao' as varchar(50))

  while exists ( select top 1 cd_processo_padrao from #composicao )
  begin
    select
      top 1
      @cd_processo_padrao     = c.cd_processo_padrao,
      @cd_fase_produto        = c.cd_fase_produto,
      @qt_produto_composicao  = c.qt_produto_composicao,
      @cd_produto             = c.cd_produto,
      @cd_desenho_produto     = p.cd_desenho_produto,
      @cd_rev_desenho_produto = p.cd_rev_desenho_produto
    from
      #composicao c

    inner join Produto p on p.cd_produto = c.cd_produto

    --Código do processo

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_processo', @codigo = @cd_processo output
	
    while exists(Select top 1 'x' from processo_producao where cd_processo = @cd_processo)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_processo', @codigo = @cd_processo output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_processo, 'D'
    end

    --select * from origem_processo
    --select * from status_processo
    --select * from tipo_processo

    select
      @cd_processo                                        as cd_processo,
      cast(convert(varchar(10),getdate(),103)as datetime) as dt_processo,
      pp.qt_prioridade_processo,
      pp.cd_pedido_venda,
      pp.cd_item_pedido_venda,
      pp.ds_processo,
      'N'                                        as ic_listado_processo,
      'N'                                        as ic_libprog_processo,
      pp.qt_hora_processo,
      null                                       as dt_prog_processo,
      null                                       as dt_alt_processo,
      null                                       as nm_alteracao_processo,
      null                                       as dt_canc_processo,
      null                                       as nm_canc_processo,
      null                                       as dt_mp_processo,
      pp.cd_identifica_processo,
      null                                       as ic_compesp_processo,
      'S'                                        as ic_mapa_processo,
      null                                       as ic_aponta_processo,
      null                                       as dt_fimprod_processo,
      null                                       as ic_arvore_processo,
      @cd_usuario                                as cd_usuario_processo,
      null                                       as nm_mp_processo_producao,
      null                                       as dt_liberacao_processo,
      @cd_usuario                                as cd_usuario,
      getdate()                                  as dt_usuario,
      pp.cd_projeto,
      pp.cd_item_projeto,
      pp.ic_estado_processo,
      @cd_fase_produto                           as cd_fase_produto,
      5                                          as cd_origem_processo,
      3                                          as cd_status_processo,
      null                                       as qt_refugo_processo,
      null                                       as qt_produzido_processo,
      null                                       as pc_refugo_processo,
      @qt_produto_composicao                     as qt_planejada_processo,
      pp.dt_entrega_processo,
      pp.dt_inicio_processo,
      @cd_produto                                as cd_produto,
      null                                       as cd_produto_pai,
      pp.qt_hora_setup,
      pp.ds_processo_fabrica,
      pp.nm_processista,
      pp.cd_projeto_material,
      pp.ic_componente_proc_padrao,
      pp.ic_composicao_proc_padrao,
      pp.qt_hora_prevista,
      pp.qt_setup_previsto,
      @cd_processo_padrao                        as cd_processo_padrao,
      null                                       as cd_usuario_mapa_processo,
      null                                       as cd_usuario_lib_processo,
      null                                       as nm_obs_prog_processo,
      null                                       as ic_prog_mapa_processo,
      null                                       as dt_encerramento_processo,
      null                                       as dt_entrega_prog_processo,
      3                                          as cd_tipo_processo,
      null                                       as nm_documento_processo,
      null                                       as nm_imagem_processo,
      null                                       as ic_fmea_processo,
      null                                       as ic_plano_processo,
      pp.ds_especificacao_tecnica,
      null                                       as qt_faturado_processo,
      null                                       as nm_numero_apontamento,
      pp.cd_cliente,
      null                                       as cd_item_requisicao,
      null                                       as cd_requisicao,
      null                                       as qt_saldo_produto_processo,
      null                                       as qt_minimo_produto_processo,
      null                                       as qt_producao_produto_processo,
      pp.cd_id_item_pedido_venda,
      null                                       as cd_rnc,
      isnull(@cd_desenho_produto,p.cd_desenho_produto)
                                                 as cd_desenho_processo_produto,
      isnull(@cd_rev_desenho_produto,p.cd_rev_desenho_produto)
                                                 as cd_rev_des_processo_produto,
      null                                       as cd_lote_produto_processo,
      null                                       as nm_situacao_op,
      null                                       as cd_programacao_entrega,
      @cd_processo_origem                        as cd_processo_origem,
      null                                       as cd_plano_mrp

--select * from processo_producao

    into
      #processo_producao

    from
      processo_producao pp      with (nolock) 
      left outer join Produto p with (nolock) on p.cd_produto = pp.cd_produto
    where
      cd_processo = @cd_processo_origem

--select * from produto
 
    insert into
      processo_producao     
    select
      *
    from
      #processo_producao

    --Operações
    --select * from Processo_Padrao_Composicao

    select
      @cd_processo                               as cd_processo,
      ppc.cd_composicao_proc_padrao              as cd_item_processo,
      ppc.cd_composicao_proc_padrao              as cd_seq_processo,
      ppc.cd_maquina                             as cd_maquina,
      null                                       as nm_maqcompl_processo,
      ppc.cd_operacao                            as cd_operacao,
      null                                       as nm_opecompl_processo,
 
      --Tempo

      case when isnull(ppc.qt_peca_ciclo,0)>0 then
        case when isnull(ppc.ic_calculo_operacao_unico,'N')='S' then
            ppc.qt_hora_operacao/ppc.qt_peca_ciclo
        else
           ( ppc.qt_hora_operacao/ppc.qt_peca_ciclo ) * @qt_planejada_processo 
        end
      else
        case when isnull(ppc.ic_calculo_operacao_unico,'N')='S' then
            ppc.qt_hora_operacao
        else
           ( ppc.qt_hora_operacao ) * @qt_planejada_processo 
        end
      end                                        as  qt_hora_estimado_processo,

      case when isnull(ppc.qt_peca_ciclo,0)>0 then
        case when isnull(ppc.ic_calculo_operacao_unico,'N')='S' then
            ppc.qt_hora_operacao/ppc.qt_peca_ciclo
        else
           ( ppc.qt_hora_operacao/ppc.qt_peca_ciclo ) * @qt_planejada_processo 
        end
      else
        case when isnull(ppc.ic_calculo_operacao_unico,'N')='S' then
            ppc.qt_hora_operacao
        else
           ( ppc.qt_hora_operacao ) * @qt_planejada_processo 
        end
      end                                        as  qt_hora_real_processo,


--      ppc.qt_hora_operacao * @qt_planejada_processo  as qt_hora_estimado_processo,
--      ppc.qt_hora_operacao * @qt_planejada_processo  as qt_hora_real_processo,


      null                                       as dt_prog_mapa_processo,
      ppc.cd_servico_especial                    as cd_servico_especial,
      null                                       as ic_operacao_mapa_processo,
      ppc.nm_obs_processo_padrao                 as nm_obs_item_processo,
      ppc.cd_grupo_maquina                       as cd_grupo_maquina,
      @cd_usuario                                as cd_usuario,
      getdate()                                  as dt_usuario,
      ppc.qt_depopant_processo_pad               as qt_seq_ant_processo,
      ppc.qt_dia_prog_processo_pad               as qt_dia_processo,
      null                                       as dt_programacao_processo,
      ppc.ic_apontamento_proc_pad                as ic_apontamento_operacao,

      --Setup

      case when isnull(ppc.qt_peca_ciclo,0)>0 then
        case when isnull(ppc.ic_calculo_setup_unico,'N')='S' then
            ppc.qt_hora_setup/ppc.qt_peca_ciclo
        else
           ( ppc.qt_hora_setup/ppc.qt_peca_ciclo ) * @qt_planejada_processo 
        end
      else
        case when isnull(ppc.ic_calculo_setup_unico,'N')='S' then
            ppc.qt_hora_setup
        else
           ( ppc.qt_hora_setup ) * @qt_planejada_processo 
        end
      end                                        as  qt_hora_setup_processo,

--      ppc.qt_hora_setup                          as qt_hora_setup_processo,

      null                                       as dt_estimada_operacao,
      ppc.cd_ordem                               as cd_ordem,
      ppc.cd_fornecedor                          as cd_fornecedor,                         
      ppc.cd_composicao_proc_padrao              as cd_composicao_proc_padrao,
      ppc.ic_movimenta_estoque                   as ic_movimenta_estoque,
      null                                       as cd_maquina_processo,
      null                                       as ic_operacao_priorizada,
      ppc.ic_inspecao_operacao                   as ic_inspecao_operacao,
      null                                       as qt_hora_prog_processo

--select * from processo_producao_composicao
--select * from  Processo_Padrao_Composicao
    into
      #Processo_Producao_Composicao

    from
      Processo_Padrao_Composicao ppc

    where
      cd_processo_padrao = @cd_processo_padrao

    insert into
      Processo_Producao_Composicao
    select
      *
    from
      #Processo_Producao_Composicao 



    -------------------------------------------------------------------------------
    --Textos das Operações
    -------------------------------------------------------------------------------
    --select * from processo_padrao_texto
    --select * from processo_producao_texto

    select
      @cd_processo                               as cd_processo_producao,
      ppt.cd_composicao_proc_padrao              as cd_item_processo_producao,              
      ppt.cd_tipo_texto_processo                 as cd_tipo_texto_processo,
      ppt.ds_processo_padrao_texto               as ds_processo_prod_texto,
      @cd_usuario                                as cd_usuario,
      getdate()                                  as dt_usuario
    into
      #Processo_Producao_Texto

    from
      Processo_Padrao_texto ppt with (nolock)
    where
      cd_processo_padrao = @cd_processo_padrao

    insert into
      Processo_Producao_Texto
    select
      *
    from
      #Processo_Producao_Texto


    --Componentes

     select
       @cd_processo                              as cd_processo,
       ppp.cd_produto_proc_padrao                as cd_componente_processo,
       ppp.cd_produto_proc_padrao                as cd_seq_comp_processo,
       ppp.cd_produto                            as cd_produto,
       null                                      as cd_placa_processo,
       ppp.qt_produto_processo * 
       isnull(@qt_planejada_processo,1)          as qt_comp_processo,
       ppp.nm_comp_processo                      as nm_comp_processo,
       ppp.cd_fase_produto                       as cd_fase_produto,
       case when isnull(ppp.cd_produto,0)>0 
       then 'N'
       else 'S' end                              as ic_esp_comp_processo,
       ppp.nm_medida_comp_processo               as nm_medida_comp_processo,
       ppp.cd_materia_prima                      as cd_mat_prima,
       ppp.nm_obs_proc_padrao_prod               as nm_obs_comp_processo,
       @cd_usuario                               as cd_usuario,
       getdate()                                 as dt_usuario,
       null                                      as ic_estoque_processo,
       ppp.pc_refugo_processo                    as pc_refugo_processo,
       isnull(ppp.cd_unidade_medida,p.cd_unidade_medida)
                                                 as cd_unidade_medida,
       null                                      as cd_movimento_estoque,
       isnull(p.ic_pcp_produto,'N')              as ic_pcp_comp_processo,
       ppp.cd_ordem                              as cd_ordem,
       p.qt_comprimento_produto                  as qt_compr_comp_processo,
       p.qt_largura_produto                      as qt_larg_comp_processo,
       p.qt_espessura_produto                    as qt_esp_comp_processo,
       null                                      as ic_redondo_comp_processo,
       ppp.qt_produto_processo                   as qt_processo_padrao,
       null                                      as cd_movimento_estoque_reserva,
       null                                      as ic_componente_substituto,
       isnull(ppp.cd_desenho_item_processo,
              p.cd_desenho_produto)               as cd_desenho_item_processo,
       isnull(ppp.cd_rev_res_item_processo,
              p.cd_rev_desenho_produto)           as cd_rev_des_item_processo,
       null                                       as cd_lote_item_processo,
       null                                       as ic_custo_produto_processo,
       null                                       as qt_real_processo,
       @cd_processo_origem                        as cd_processo_origem,
       null                                       as cd_requisicao_interna,
       null                                       as cd_item_req_interna,
       null                                       as cd_processo_destino
   
	

--select * from processo_producao_componente
   
    into
      #Processo_Producao_Componente

    from
      Processo_Padrao_Produto ppp with (nolock) 
      left outer join produto p                 on p.cd_produto = ppp.cd_produto
    where
      cd_processo_padrao = @cd_processo_padrao

--    select * from #Processo_Producao_Componente


    insert into
      Processo_Producao_Componente
    select
      * 
    from
      #Processo_Producao_Componente

    
    --Verifica se o Produto possui composição e gera a Composição do Processo
 
    --select * from produto_composicao   

     select
       @cd_processo                              as cd_processo,
       ppp.cd_ordem_produto_comp                 as cd_componente_processo,
       ppp.cd_ordem_produto_comp                 as cd_seq_comp_processo,
       ppp.cd_produto                            as cd_produto,
       null                                      as cd_placa_processo,
       ppp.qt_produto_composicao *
       @qt_planejada_processo                    as qt_comp_processo,
       p.nm_fantasia_produto                     as nm_comp_processo,
       ppp.cd_fase_produto                       as cd_fase_produto,
       case when isnull(ppp.cd_produto,0)>0 
       then 'N'
       else 'S' end                              as ic_esp_comp_processo,
       null                                      as nm_medida_comp_processo,
       ppp.cd_materia_prima                      as cd_mat_prima,
       null                                      as nm_obs_comp_processo,
       @cd_usuario                               as cd_usuario,
       getdate()                                 as dt_usuario,
       null                                      as ic_estoque_processo,
       null                                      as pc_refugo_processo,
       p.cd_unidade_medida                       as cd_unidade_medida,
       null                                      as cd_movimento_estoque,
       isnull(p.ic_pcp_produto,'N')              as ic_pcp_comp_processo,
       ppp.cd_ordem_produto_comp                 as cd_ordem,
       p.qt_comprimento_produto                  as qt_compr_comp_processo,
       p.qt_largura_produto                      as qt_larg_comp_processo,
       p.qt_espessura_produto                    as qt_esp_comp_processo,
       null                                      as ic_redondo_comp_processo,
       ppp.qt_produto_composicao                 as qt_processo_padrao,
       null                                      as cd_movimento_estoque_reserva,
       null                                      as ic_componente_substituto,
       p.cd_desenho_produto                      as cd_desenho_item_processo,
       p.cd_rev_desenho_produto                   as cd_rev_des_item_processo,
       null                                       as cd_lote_item_processo,
       null                                       as ic_custo_produto_processo,
       null                                       as qt_real_processo,
       @cd_processo_origem                        as cd_processo_origem,
       null                                       as cd_requisicao_interna,
       null                                       as cd_item_req_interna,
       null                                       as cd_processo_destino
   
    into
      #Processo_Producao_Componente_Composicao

    from
      Processo_Producao pp              with (nolock) 
      inner join Produto_Composicao ppp with (nolock) on ppp.cd_produto_pai = pp.cd_produto
      left outer join produto p         with (nolock) on p.cd_produto       = ppp.cd_produto
    where
      cd_processo = @cd_processo



    --Verifica se já existem componentes para Ajustar o Número do componente

    if exists( select top 1 cd_processo from #Processo_Producao_Componente )
    begin

      declare @cd_componente_processo int

      select
        @cd_componente_processo = max ( cd_componente_processo ) + 1
      from
        #Processo_Producao_Componente
  
      update
        #Processo_Producao_Componente_Composicao
      set
        cd_componente_processo = cd_componente_processo + @cd_componente_processo      

    end

    insert into
      Processo_Producao_Componente
    select
      * 
    from
      #Processo_Producao_Componente_Composicao

    
    --Libera da Tabela Código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_processo, 'D'

    --Deleta o Processo Padrão
    delete from #Composicao 
    where
      cd_processo_padrao = @cd_processo_padrao

    drop table #processo_producao
    drop table #processo_producao_composicao
    drop table #Processo_Producao_Componente
    drop table #Processo_Producao_Componente_Composicao
    drop table #Processo_Producao_texto

  end

  drop table #composicao


----------------------------------------------------------------------------------
--Grava na composição do processo origem a OP gerada para cada componente - Origem
----------------------------------------------------------------------------------
update
  processo_producao_componente
set
  cd_processo_destino = isnull(( select top 1 x.cd_processo
                          from 
                            processo_producao_componente x
                          where
                            x.cd_produto  = ppc.cd_produto and
                            x.cd_processo = @cd_processo_origem),0)

from
  processo_producao_componente ppc

where
  ppc.cd_processo = @cd_processo_origem



