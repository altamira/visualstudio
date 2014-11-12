
---------------------------------------------------------------------------------------
--fn_data_programacao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Fernandes
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo		: Busca a Data de Programação 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------

CREATE FUNCTION fn_data_programacao
( @cd_maquina          int,
  @dt_disponibilidade  datetime,
  @qt_hora_operacao    float,
  @ic_tipo_retorno     int)


--select * from programacao_composicao

--CREATE FUNCTION fn_data_programacao

--ALTER FUNCTION 

-- ( @cd_maquina          int,
--   @dt_disponibilidade  datetime,
--   @qt_hora_operacao    float,
--   @ic_tipo_retorno     int)

--@ic_tipo_retorno
--                     0=Data Inicial de Produção
--                     1=Data Final   de Produção

RETURNS datetime

as

begin

-- if @dt_disponibilidade is null
-- begin
--   set @dt_disponibilidade = cast(convert(int,getdate(),103) as datetime)
-- end
  

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
set @qt_hora_programacao     = @qt_hora_operacao   --Total Horas Programação
set @qt_hora_real_prog       = 0                   --Total Horal Real Programação  
set @controle                = 0
set @ic_prog                 = 0
   
--Rotina de Programação

while @qt_hora_disponivel <= @qt_hora_programacao 
begin

   --Verificação da Agenda 
   set @ic_util                 = 'N'
   set @ic_fabrica_operacao     = 'N'

   --Loop para achar a data de disponibilidade útil para programacao
   --Carlos 11.6.2004          ( Talvez fazer uma função )

   while @ic_util = 'N' 
   begin

     select
       @ic_util             = isnull(ic_util,'N'),
       @ic_fabrica_operacao = isnull(ic_fabrica_operacao,'N')
     from 
       agenda
     where 
       dt_agenda = @dt_disponibilidade

     if ( @ic_util = 'N' and @ic_fabrica_operacao = 'N' )
        set @dt_disponibilidade = @dt_disponibilidade + 1

     if ( @ic_util = 'N' and @ic_fabrica_operacao = 'S' )
        set @ic_util = 'S'
     
    end

  -- primeira data de programação disponível

  if @ic_prog = 0 
  begin
    set @dt_primeira_programacao = @dt_disponibilidade
    set @ic_prog = 1
  end

  select
    @qt_hora_disponivel = ( isnull(p.qt_hora_operacao_maquina,0) - isnull(qt_hora_prog_maquina,0) ),
    @controle           = cd_programacao
  from
    Programacao p
  where
    p.cd_maquina     = @cd_maquina         and
    p.dt_programacao = @dt_disponibilidade and
    isnull(p.qt_hora_operacao_maquina,0)>0

  --Verifica se Existe horas disponíveis nesta data

  if @qt_hora_disponivel>0 
  begin
    if @qt_hora_programacao>=@qt_hora_disponivel 
       set @qt_hora_real_prog = @qt_hora_disponivel 

        --    select @qt_hora_real_prog,
        --           @qt_hora_disponivel                      ,
        --           @qt_hora_programacao-@qt_hora_disponivel ,
        --           @qt_hora_programacao                     ,
        --           @dt_disponibilidade 


     --Atualização da Tabela de Programação

--      if @ic_atualiza_prog=1
--      begin

       --Programacao 

--        update
--          Programacao
--        set
--          qt_hora_prog_maquina = isnull(qt_hora_prog_maquina,0) + @qt_hora_real_prog
--        from
--          Programacao p
--        where
--          p.cd_maquina     = @cd_maquina         and
--          p.dt_programacao = @dt_disponibilidade and
--          isnull(p.qt_hora_prog_maquina,0)<isnull(p.qt_hora_operacao_maquina,0)
       
       --Programacao Composicao

--        exec pr_atualiza_programacao_composicao 
--             @cd_programacao         = 1,
--             @cd_processo            = 1,
--             @cd_operacao            =1 ,
--             @cd_numero_operacao     =10,
--             @qt_hora_prog_operacao  = 14,
--             @dt_ini_prod_operacao   = '06/12/2004',
--             @dt_mat_prima_operacao  = null,
--             @nm_obs_operacao        = '',
--             @cd_ordem_fab           = 1,
--             @cd_usuario	            = 1
    
       

--      end   

     set @qt_hora_programacao = @qt_hora_programacao - @qt_hora_real_prog

     if @qt_hora_programacao>0 
        set @dt_disponibilidade = @dt_disponibilidade + 1

   end
   else
      set @dt_disponibilidade = @dt_disponibilidade + 1

end

if @qt_hora_programacao>0
begin
  set @qt_hora_real_prog = @qt_hora_programacao 

--   select @qt_hora_real_prog,
--          @qt_hora_disponivel                      ,
--          @qt_hora_programacao-@qt_hora_disponivel ,
--          @qt_hora_programacao                     ,
--          @dt_disponibilidade 


  --Montagem da Tabela Auxiliar

end

--Data da Disponibilidade
set @dt_ultima_programacao = @dt_disponibilidade

--Verifica o Parâmetro para retorno da data correta

if @ic_tipo_retorno=0
   set @dt_retorno = @dt_primeira_programacao
else
  set @dt_retorno = @dt_ultima_programacao

return(@dt_retorno)

END

