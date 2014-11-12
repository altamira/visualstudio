
-----------------------------------------------------------------------------------
--pr_atualiza_programacao_composicao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a atualização da tabela programação_composição
--                   com os dados da programação
--                   Sequenciamento das Operações
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--                   20.06.2004 - Atualização do Item do Processo. 
--                   20.07.2004 - Atualização de Novos Campos
--                   30.07.2004 - Novos campos : Pedido e Item
--                   05/08/2004 - Incluído novo campo de reserva e novo parâmetro - Daniel C. neto
--                   05.11.2005 - Gravação dos Horários de Programação - Carlos Fernandes
--                   20.08.2007 - Verificação - Carlos Fernandes
-- 20.09.2007 - Gravação da Quantidade Horas programadas na Composição do Processo - Carlos Fernandes
-- 27.10.2007 - Hora Final de Programação - Carlos Fernandes
-- 01.11.2007 - Agrupamento de Operações - Carlos Fernandes
-- 21.08.2008 - Novo campo para campo de prioridade - Carlos Fernandes
---------------------------------------------------------------------------------------------------
create procedure pr_atualiza_programacao_composicao
@cd_maquina             int,
@dt_programacao         datetime,
@cd_processo            int,
@cd_item_processo       int,
@cd_operacao            int,
@cd_numero_operacao     int,
@qt_hora_prog_operacao	float,
@dt_ini_prod_operacao	datetime,
@dt_mat_prima_operacao	datetime,
@nm_obs_operacao        varchar(40),
@cd_usuario	        int,
@ic_antecipada_operacao char(1) = 'N',
@ic_ordem_fab           char(1) = 'N',
@ds_prog_composicao     varchar(8000) = null,
@cd_pedido_venda        int = 0,
@cd_item_pedido_venda   int = 0,
@cd_reserva             int = 0,
@qt_prioridade_operacao int = 0 

as

begin

  declare @cd_programacao       int
  declare @cd_item_programacao  int
  declare @cd_ordem_fab         int  
  declare @sg_operacao          char(10)
  declare @hr_ini_prod_operacao varchar(8) 
  declare @hr_fim_prod_operacao varchar(8)
 
  set @cd_programacao       = 0
  set @cd_item_programacao  = 0
  set @cd_ordem_fab         = 0
  set @hr_ini_prod_operacao = ''
  set @hr_fim_prod_operacao = '' 

  --Busca o Código da Programação

  select 
    @cd_programacao       = isnull(cd_programacao,0),
    @hr_ini_prod_operacao = isnull(hr_inicio_programacao,''),
    @hr_fim_prod_operacao = isnull(hr_final_programacao,'')
  from
    Programacao with (nolock)  
  where
    cd_maquina     = @cd_maquina     and
    dt_programacao = @dt_programacao and
    isnull(cd_programacao,0)>0 

  --Busca o Próximo Código do Item da Programação

  select 
     @cd_item_programacao  = isnull( max(cd_item_programacao),0 )+1,
     @cd_ordem_fab         = case when isnull(@qt_prioridade_operacao,0)=0 
                             then
                               isnull( max(cd_ordem_fab       ),0 )+1
                             else
                               @qt_prioridade_operacao
                             end,
     @hr_ini_prod_operacao = case when isnull(max(hr_fim_prod_operacao),'')='' then @hr_ini_prod_operacao 
                                                                               else max(hr_fim_prod_operacao) end
  from 
     Programacao_Composicao pc with (nolock)
  where 
     @cd_programacao = pc.cd_programacao

  --Sigla da Operação-------------------------------------------------------------------------------------

  select 
     @sg_operacao = o.sg_operacao
  from 
     Programacao_Composicao pc  with (nolock) 
     left outer join Operacao o with (nolock) on o.cd_operacao = pc.cd_operacao
  where 
     @cd_programacao = pc.cd_programacao

  --Cálculo da Hora Final

   set @hr_fim_prod_operacao = dbo.fn_gera_horario_programacao(@hr_ini_prod_operacao,@qt_hora_prog_operacao)

  --Insere os registros na tabela
  insert into Programacao_Composicao 
    (
     cd_programacao,
     cd_item_programacao,
     cd_processo,
     cd_item_processo,
     cd_operacao,
     cd_numero_operacao,
     qt_hora_prog_operacao,
     dt_ini_prod_operacao,
     dt_mat_prima_operacao,
     nm_obs_operacao,
     cd_ordem_fab,
     dt_lanc_mapa_programacao,
     ds_prog_composicao,  
     ic_antecipada_operacao,
     ic_ordem_fab,
     cd_usuario,
     dt_usuario,
     cd_pedido_venda,
     cd_item_pedido_venda,
     cd_reserva_programacao,
     hr_ini_prod_operacao,
     hr_fim_prod_operacao
    )
  values 
    (
     @cd_programacao,
     @cd_item_programacao,
     @cd_processo,
     @cd_item_processo,
     @cd_operacao,
     @cd_numero_operacao,
     @qt_hora_prog_operacao,
     @dt_ini_prod_operacao,
     @dt_mat_prima_operacao,
     IsNull(@sg_operacao,'') + ' ' + IsNull(@nm_obs_operacao,''),
     @cd_ordem_fab,
     getdate(),
     @ds_prog_composicao,  
     @ic_antecipada_operacao,
     @ic_ordem_fab,
     @cd_usuario,
     getdate(),
     @cd_pedido_venda,
     @cd_item_pedido_venda,
     @cd_reserva,
     @hr_ini_prod_operacao,
     @hr_fim_prod_operacao )

--print @cd_reserva

end

