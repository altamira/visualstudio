
-----------------------------------------------------------------------------------
create procedure pr_programacao_producao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a programação das operações do processo por máquina
--                   Sequenciamento das Operações
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--                   20.06.2004 - Permite a Programação de Apenas 1 operação do Processo             
--                   13.07.2004 - Checagem da Programação, quando existe maior quantidadde Hora que a Carga
--                   06.08.2004 - Acertos Gerais
--                   09/08/2004 - Incluído novo parâmetro para digitação da hora. - Daniel C. Neto.
--                              - Revisão da Programação
-- 16/08/2004 - Modificado forma de pegar a máquina para permitir programar outro máquina
-- no processo_producao_composicao - Daniel C. Neto.
-- 27/08/2004 - Tirado verificação pra gravação da MP. - Daniel C. Neto.
-- 13.08.2007 - Verificação da Rotina - Carlos Fernandes
-- 02.09.2007 - Geração do Prazo de Entrega do Processo/Pedido de Venda - Carlos Fernandes
-- 20.09.2007 - Gravação da Quantidade Horas programadas na Composição do Processo - Carlos Fernandes
-- 26.09.2007 - Acerto da Programação - Carlos Fernandes
-- 27.10.2007 - Data Final de Programação - Carlos Fernandes 
-- 31.10.2007 - Agrupamento de Operações sem Disponibilidade - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------
@cd_processo            int      = 0,
@dt_inicio_programacao  datetime = '',
@cd_usuario             int      = 0,
@cd_tipo_programacao    int      = 0,
@cd_item_processo       int      = 0,
@qt_hora_digitado       float    = 0,
@qt_prioridade_operacao int      = 0

--@cd_processo           = número do processo
--@dt_inicio_programacao = data de início da programação
--@cd_usuario            = usuário que fez a programação
--@cd_tipo_programacao   = 0 --> Todo o Processo
--                       = 1 --> Apenas uma Operação/Sequência do Processo
--@cd_item_processo      = item do processo que deverá ser programado

as


if @dt_inicio_programacao is null
begin
   set @dt_inicio_programacao = getdate()
end

--Parâmetro_Manufatura
--
--Busca os parâmetros, para início da  Programação
--                     e    final para Geração do Prazo de entrega
--
--
  declare 
    @qt_dia_inicio_operacao int,
    @qt_dia_fim_operacao    int

	select
	  @qt_dia_inicio_operacao = isnull(qt_dia_inicio_operacao,0),
	  @qt_dia_fim_operacao    = isnull(qt_dia_fim_operacao,0)
	from
	  Parametro_Manufatura
	where
	  cd_empresa = dbo.fn_empresa()

--  select
--    @qt_dia_inicio_operacao,
--    @qt_dia_fim_operacao

--Montagem da Tabela Auxiliar de Programação

-- if @cd_tipo_programacao = 0
-- begin

  select 
    isnull(isnull(pp.dt_inicio_processo,@dt_inicio_programacao),getdate()) as dt_inicio_processo,
    isnull(pp.qt_prioridade_processo,0)  as qt_prioridade_processo, 
    pp.dt_mp_processo,                    
    m.nm_fantasia_maquina                  as 'maquina',
    isnull(m.ic_mapa_producao,'N')         as 'progmaq',
    op.nm_fantasia_operacao                as 'operacao',
    isnull(op.ic_mapa_operacao,'N')        as 'progop', 
    isnull(op.ic_mat_prima_operacao,'N')   as 'agmp',
    isnull(op.ic_anterior_operacao,'N')    as 'opant',
    isnull(op.ic_agrupamento_operacao,'N') as 'ic_agrupamento_operacao',
    op.pc_programacao_operacao             as 'desctoop',
    cm.dt_disp_carga_maquina,                               --Data       de Disponibilidade  na Carga Máquina
    isnull(cm.qt_disp_carga_maquina,0)     as 'qtdHoraDisp',  --Quantidade de Horas Disponível na Carga Máquina

    --Data da Programacao Inicial
    ProgInicial =
    dbo.fn_data_programacao(    ( case when IsNull(cd_maquina_processo,0) > 0 then
                                   cd_maquina_processo else ppc.cd_maquina end ) ,
                                cm.dt_disp_carga_maquina+IsNull(ppc.qt_dia_processo,0),
                                ppc.qt_hora_estimado_processo,0) ,

    --Data da Programacao Final
    ProgFinal = 
    dbo.fn_data_programacao(( case when IsNull(cd_maquina_processo,0) > 0 then
                                   cd_maquina_processo else ppc.cd_maquina end ),
                             cm.dt_disp_carga_maquina+IsNull(ppc.qt_dia_processo,0),
                             ppc.qt_hora_estimado_processo,1) ,

    --Itens do Processo

    ppc.* ,
    op.sg_operacao

  into
    #Programacao

  from 
    processo_producao             pp                 with (nolock)
    left outer join processo_producao_composicao ppc with (nolock) on ppc.cd_processo = pp.cd_processo
    left outer join maquina       m                  with (nolock) on m.cd_maquina    = ppc.cd_maquina
    left outer join operacao      op                 with (nolock) on op.cd_operacao  = ppc.cd_operacao
    left outer join carga_maquina cm                 with (nolock) on cm.cd_maquina   = m.cd_maquina
  
  where
    pp.cd_processo       = @cd_processo            and
    ppc.cd_item_processo = case when @cd_item_processo = 0 then ppc.cd_item_processo 
                                                           else @cd_item_processo end and
    isnull(pp.ic_libprog_processo,'N') = 'S' and --Verifica se o Processo nao foi liberado 
    isnull(pp.ic_mapa_processo,'N')    = 'S' and --Verifica se o Processo e' programado no Mapa
    isnull(m.ic_mapa_producao,'N')     = 'S' and --Verifica se a Máquina Recebe Programação
    isnull(op.ic_mapa_operacao,'N')    = 'S' and --Verifica se a Operação é Programada no Mapa
    isnull(ppc.cd_maquina,0)>0                   --Verifica se a Máquina foi Informada 

  order by
     pp.cd_processo

 
--Tabela Programacao
--  select * from #Programacao order by cd_processo,cd_seq_processo

--Programacao

  declare 
    @qt_hora_prog            float,
    @ic_primeira_operacao    int,
    @dt_mp_processo          datetime,
    @agmp                    char(1),
    @dt_disponibilidade      datetime,
    @dt_programacao          datetime,
    @dt_ultima_programacao   datetime,
    @opant                   char(1),
    @cd_maquina              int,
    @qt_hora_programacao     float,
    @cd_operacao             int,
    @nm_obs_item_processo    varchar(40),
    @dt_inicio_processo      datetime,
    @ic_agrupamento_operacao char(1)

    set @ic_primeira_operacao = 0

    while exists(select top 1 cd_maquina from #Programacao )
    begin

    --Busca o 1o. registro  
    --Verifica se é a primeira operação e a Data de Entrada do Material

	  if @ic_primeira_operacao = 0
	  begin	   

	    set @ic_primeira_operacao = 1
	   
	    select top 1
	      @dt_inicio_processo      = dt_inicio_processo,
	      @dt_programacao          = dt_inicio_processo,
	      @dt_disponibilidade      = dt_disp_carga_maquina, 
	      @agmp                    = agmp,
 	      @dt_mp_processo          = dt_mp_processo,
	      @cd_item_processo        = cd_item_processo,
	      @opant                   = opant,
	      @cd_maquina              = ( case when IsNull(cd_maquina_processo,0) > 0 then
                                         cd_maquina_processo else cd_maquina end ),
              @qt_hora_programacao     = ( case when IsNull(@qt_hora_digitado,0) = 0 then
                                         qt_hora_estimado_processo else @qt_hora_digitado end ) ,
	      @cd_operacao             = cd_operacao,
	      @nm_obs_item_processo    = IsNull(sg_operacao + ' ','') + LTrim(RTrim(nm_obs_item_processo)),
              @ic_agrupamento_operacao = isnull(ic_agrupamento_operacao,'N')

	    from
	      #Programacao
	    where
	      progmaq = 'S' and progop='S'   --Verifica se a Máquina/Operação é Programada no Mapa de Programação
            order by
              cd_processo,cd_seq_processo,dt_inicio_processo
  
	  end
      else
         begin

    --Dados 

	  select top 1
	    @cd_item_processo        = cd_item_processo,
	    @opant                   = opant,
	    @cd_maquina              = ( case when IsNull(cd_maquina_processo,0) > 0 then
                                      cd_maquina_processo else cd_maquina end ),
	    @qt_hora_programacao     = ( case when IsNull(@qt_hora_digitado,0) = 0 then
                                       qt_hora_estimado_processo else @qt_hora_digitado end ) ,
	    @cd_operacao             = cd_operacao,
	    @nm_obs_item_processo    = IsNull(sg_operacao + ' ','') + LTrim(RTrim(nm_obs_item_processo)),
            @ic_agrupamento_operacao = isnull(ic_agrupamento_operacao,'N')

	  from
	    #Programacao
	  where
	    progmaq = 'S' and progop='S'   --Verifica se a Máquina/Operação é Programada no Mapa de Programação
          order by
            cd_processo,cd_seq_processo,dt_inicio_processo

        end
	
	  --Mostra a data de Programação
	  --select @dt_programacao

          --Verifica se a Operação Aguarda o Término da Operação Anterior

          --  if @opant = 'S' 
	  --     print @opant

          --Mostra a Programacao

--           select                        @cd_maquina,
-- 	                                @dt_programacao,
-- 	                                @qt_hora_programacao,
-- 	                                1,
-- 	                                1,
-- 	                                @cd_usuario,
--                                         @cd_processo,
--                                         @cd_item_processo,
--                                         @cd_operacao,
--                                         0,
--                                         @dt_programacao,
--                                         @dt_mp_processo,
--                                         @nm_obs_item_processo
-- 
	  --Gera a Programação

          if @dt_programacao is null  
          begin  
            set @dt_programacao = getdate()  
          end  
  
          set @dt_programacao = cast(convert(int,@dt_programacao,103) as datetime)  


          if @dt_programacao is not null
          begin

            --select @dt_programacao

            exec pr_gera_data_programacao @cd_maquina,
 	                                  @dt_programacao,
	                                  @qt_hora_programacao,
	                                  1,
	                                  1,
	                                  @cd_usuario,
                                          @cd_processo,
                                          @cd_item_processo,
                                          @cd_operacao,
                                          0,
                                          @dt_programacao,
                                          @dt_mp_processo,
                                          @nm_obs_item_processo,
                                          0,
                                          @ic_agrupamento_operacao,
                                          @qt_prioridade_operacao

    --Atualiza a Data de Programação na Composição do Processo
  
	   update
	     Processo_Producao_Composicao
	   set
	     dt_prog_mapa_processo   = getdate(),
             --dt_prog_mapa_processo   = null,
	     dt_programacao_processo = @dt_programacao,
             qt_hora_prog_processo   = @qt_hora_digitado
	   where
	     cd_processo      = @cd_processo       and 
	     cd_item_processo = @cd_item_processo

         end

    --Deleta o registro da Tabela Auxiliar de Programação

    delete #programacao 
    where 
      cd_processo      = @cd_processo      and
      cd_item_processo = @cd_item_processo 

    --Atualiza a Data de Programação
    set @dt_programacao = @dt_programacao + 1

  end

-----------------------------------------------------------------------------------
----Atualiza o Processo com Dados da Programação
-----------------------------------------------------------------------------------

  update
    Processo_Producao
  set 
      cd_usuario_mapa_processo = @cd_usuario,
      dt_prog_processo         = getdate(),
      dt_entrega_prog_processo = @dt_programacao + 
      case when isnull(@qt_dia_fim_operacao,0) > 0 then ( @qt_dia_fim_operacao - 1 )
                                                   else 0 end,
      dt_entrega_processo     =  @dt_programacao + 
      case when isnull(@qt_dia_fim_operacao,0) > 0 then ( @qt_dia_fim_operacao - 1 )
                                                   else 0 end,
      nm_situacao_op          = 'Programada'
  where
    cd_processo = @cd_processo

-----------------------------------------------------------------------------------
----Atualiza o Prazo de Entrega do Pedido de Venda
-----------------------------------------------------------------------------------
  declare @cd_pedido_venda      int
  declare @cd_item_pedido_venda int

  select
    @cd_pedido_venda      = isnull(cd_pedido_venda,0),
    @cd_item_pedido_venda = isnull(cd_item_pedido_venda,0)
  from
    Processo_Producao pp
  where
    cd_processo = @cd_processo

  if @cd_pedido_venda>0 and @cd_item_pedido_venda>0
  begin
    update
      pedido_venda_item
    set
      dt_reprog_item_pedido     = case when dt_entrega_fabrica_pedido is null then null else dt_entrega_fabrica_pedido end,
      dt_entrega_fabrica_pedido =   @dt_programacao + 
        case when isnull(@qt_dia_fim_operacao,0) > 0 then ( @qt_dia_fim_operacao - 1 )
                                                   else 0 end,
      nm_observacao_fabrica1 = case when isnull(nm_observacao_fabrica1,'')=''
                                  then 'Prazo Gerado Prog.Automática'
                                  else nm_observacao_fabrica1 end
     where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda
  end
  
-----------------------------------------------------------------------------------
--select * from pedido_venda_item

--Tabela Programacao
--select * from #Programacao order by cd_processo,cd_seq_processo

--select dt_entrega_prog_processo,ic_libprog_processo,ic_mapa_processo,* from processo_producao where cd_processo = 379
