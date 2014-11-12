
---------------------------------------------------------------------------------------------------
--pr_gera_data_programacao
---------------------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Geração das datas de programação conforme a máquina e a data 
--                   de disponibilidade
--                   Sequenciamento das Operações
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--                 : Executa a atualização das tabelas de Programação e Programação Composição   
--                 : 13.07.2004 - Verificação da Geração da Data Correta de Programação, Qtd Hora > Disponibilidade
--                   05/08/2004 - Incluído novo parâmetro. - Daniel C. Neto.
--                   06.08.2004 - Acertos Gerais - Carlos
--                   09.08.2004 - Revisão da Programação
--                   23/08/2004 - Colocado IsNull nas variáveis - Daniel C. Neto.
--                   27/08/2004 - Transformado em decimal pra evitar problemas de casas. - Daniel C. Neto.
--                   02.02.2005 - Verificação da Rotina de Programação
--                   05.11.2005 - Colocar da Geração das Datas Iniciais/Finais de Programação - Carlos Fernandes
--                   20.08.2007 - Verificação da rotina - Carlos Fernandes
--                   20.09.2007 - Gravação da Quantidade Horas programadas na Composição do Processo - Carlos Fernandes
--                   01.11.2007 - Agrupamento de Operações - Carlos Fernandes
-- 21.08.2008 - Novo Campo de prioridade de operação na Programação - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
create procedure pr_gera_data_programacao
@cd_maquina              int,                      --Máquina
@dt_disponibilidade      datetime,                 --Data de Disponibilidade
@qt_hora_operacao        float,                    --Quantidade de Horas Programação
@ic_tipo_retorno         int,                      --Data de Retorno
@ic_atualiza_prog        int,                      --Tipo de Atualização
@cd_usuario              int,                      --Usuário
@cd_processo             int         = 0,          --Número do Processo
@cd_item_processo        int         = 0,          --Item   do Processo
@cd_operacao             int         = 0,          --Operação
@cd_numero_operacao      int         = 0,          --Número da Operação
@dt_ini_prod_operacao	 datetime    = null,       --Data   de Início
@dt_mat_prima_operacao 	 datetime    = null,       --Data   da Entrada da Matéria-Prima
@nm_obs_operacao         varchar(40) = null,       --Observação
@cd_reserva              int         = 0,          --Código da Reserva
@ic_agrupamento_operacao char(1)     = 'N',        --Agrupamento de Operação
@qt_prioridade_operacao  int         = 0           --Prioridade de Programação

--@ic_tipo_retorno
--                     0=Data Inicial de Produção
--                     1=Data Final   de Produção

--
--@ic_atualiza_prog 
--                     0=Não Atualiza
--                     1=Atualiza

as

--Variáveis Auxiliares no Processo de Programação

declare @dt_retorno              datetime
declare @dt_primeira_programacao datetime
declare @dt_ultima_programacao   datetime
declare @qt_hora_disponivel      float
declare @qt_hora_programacao     float
declare @qt_hora_real_prog       float
declare @controle                int
declare @ic_util                 char(1)
declare @ic_fabrica_operacao     char(1)
declare @ic_prog                 int
 
set @qt_hora_disponivel      = 0                   --Total Horas Disponivel para Programação
set @qt_hora_programacao     = @qt_hora_operacao   --Total Horas que deve ser Programada
set @qt_hora_real_prog       = cast(str(@qt_hora_operacao,25,2) as decimal(25,2))   --Total Horal Real Programação  
set @controle                = 0
set @ic_prog                 = 0
   
--Rotina de Programação

--Verificação da Horas Disponiveis e Horas que devem ser programadas

while IsNull(@qt_hora_disponivel,0) <= IsNull(@qt_hora_programacao,0)
begin

   --Atenção Dia Útil na Agenda Geral, sempre executa Programação

   --Verificação da Agenda Geral e Agenda da Fábrica

   set @ic_util                 = 'N'
   set @ic_fabrica_operacao     = 'N'

   --Loop para achar a data de disponibilidade útil para programacao
   --Carlos 11.6.2004          ( Talvez fazer uma função )

   while @ic_util = 'N'   --Checagem se o Dia é util
   begin

     select
       @ic_util             = isnull(ic_util,'N'),
       @ic_fabrica_operacao = isnull(ic_fabrica_operacao,'N')
     from 
       agenda
     where 
       dt_agenda = @dt_disponibilidade

     if ( @ic_util = 'N' and @ic_fabrica_operacao = 'N' )
     begin    
        set @dt_disponibilidade = @dt_disponibilidade + 1
     end

     if ( @ic_util = 'N' and @ic_fabrica_operacao = 'S' )
     begin
       set @ic_util = 'S'
     end

      --select @dt_disponibilidade,@ic_util,@ic_fabrica_operacao
     
    end

  -- primeira data de programação disponível

  if IsNull(@ic_prog,0) = 0 
  begin
    --Montagem da 1a. data de Programacao Disponível
    set @dt_primeira_programacao = @dt_disponibilidade
    set @ic_prog                 = 1

    --select @dt_primeira_programacao

  end

  -- Capacidade de Horas de Trabalho da Máquina - Quantidade de Horas já Programadas

  select

    --Verifica se Permite Agrupar a Operação

    @qt_hora_disponivel = case when @ic_agrupamento_operacao = 'N' then
                           ( isnull(p.qt_hora_operacao_maquina,0) - isnull(p.qt_hora_prog_maquina,0) )
                          else
                           isnull(p.qt_hora_operacao_maquina,0)
                          end,

    @controle           = p.cd_programacao

  from
    Programacao p with (nolock)
  where
    p.cd_maquina     = @cd_maquina         and
    p.dt_programacao = @dt_disponibilidade and
    isnull(p.qt_hora_operacao_maquina,0)>0

  --Mostra a quantidade de Horas Disponível para Programação
  --select @qt_hora_disponivel

  --Verifica se Existe horas disponíveis nesta data

  if @qt_hora_disponivel = null 
  begin
     set @qt_hora_disponivel = 0
  end

  if IsNull(@qt_hora_disponivel,0)>0 
  begin

    set @qt_hora_real_prog = IsNull(@qt_hora_programacao,0)

    if IsNull(@qt_hora_programacao,0)>=IsNull(@qt_hora_disponivel,0)
    begin
      set @qt_hora_real_prog = @qt_hora_disponivel 
    end

        --    select @qt_hora_real_prog,
        --           @qt_hora_disponivel                      ,
        --           @qt_hora_programacao-@qt_hora_disponivel ,
        --           @qt_hora_programacao                     ,
        --           @dt_disponibilidade 


     --Atualização da Tabela de Programação

     if IsNull(@ic_atualiza_prog,0)=1
     begin
  
       --select @dt_disponibilidade

       --Programacao 

       update
         Programacao
       set
         qt_hora_prog_maquina = isnull(qt_hora_prog_maquina,0) + @qt_hora_real_prog
       from
         Programacao p
       where
         p.cd_maquina     = @cd_maquina         and
         p.dt_programacao = @dt_disponibilidade and
         isnull(p.qt_hora_prog_maquina,0)<=isnull(p.qt_hora_operacao_maquina,0)


	       --Mostra os dados que serao atualizados

--        select @cd_maquina,
--               @dt_disponibilidade,
--               @cd_processo,
--               @cd_item_processo,
--               @cd_operacao,
--               @qt_hora_real_prog,
--               @dt_disponibilidade,
--               @dt_mat_prima_operacao,
--               @nm_obs_operacao,
--               @cd_usuario 	

       -- Gera a Programação Composição ( Tabela : Programacao_Composicao )

       if cast(str(@qt_hora_real_prog,25,2) as decimal(25,2)) > 0.00
       begin

         exec pr_atualiza_programacao_composicao  @cd_maquina             = @cd_maquina,
                                                  @dt_programacao         = @dt_disponibilidade,
                                                  @cd_processo            = @cd_processo,
                                                  @cd_item_processo       = @cd_item_processo,
                                                  @cd_operacao            = @cd_operacao,
                                                  @cd_numero_operacao     = 0, 
                                                  @qt_hora_prog_operacao  = @qt_hora_real_prog,
                                                  @dt_ini_prod_operacao   = @dt_disponibilidade,
                                                  @dt_mat_prima_operacao  = @dt_mat_prima_operacao,
                                                  @nm_obs_operacao        = @nm_obs_operacao,
                                                  @cd_usuario             = @cd_usuario, 	            --Usuário
                                                  @ic_antecipada_operacao = 'N',
                                                  @ic_ordem_fab           = 'N',
                                                  @ds_prog_composicao     = null,
                                                  @cd_pedido_venda        = 0,
                                                  @cd_item_pedido_venda   = 0,
                                                  @cd_reserva             = @cd_reserva,
                                                  @qt_prioridade_operacao = @qt_prioridade_operacao
       end 

     end   

     set @qt_hora_programacao = IsNull(@qt_hora_programacao,0) - IsNull(@qt_hora_real_prog,0)

     if IsNull(@qt_hora_programacao,0)>0 
     begin
        set @dt_disponibilidade = @dt_disponibilidade + 1
        set @qt_hora_disponivel = 0
     end

   end
   else
     begin
       set @dt_disponibilidade = @dt_disponibilidade + 1
       set @qt_hora_disponivel = 0
     end

   --select @qt_hora_programacao,@qt_hora_real_prog

end


--Verifica se existe saldo para programação

if IsNull(@qt_hora_programacao,0)>0
begin

  set @qt_hora_real_prog = IsNull(@qt_hora_programacao,0)

end

--Data da Disponibilidade
set @dt_ultima_programacao = @dt_disponibilidade

--Verifica o Parâmetro para retorno da data correta

if @ic_tipo_retorno=0
   set @dt_retorno = @dt_primeira_programacao
else
   set @dt_retorno = @dt_ultima_programacao

--Data da Disponibilidade
--select @dt_retorno

--print @cd_reserva


