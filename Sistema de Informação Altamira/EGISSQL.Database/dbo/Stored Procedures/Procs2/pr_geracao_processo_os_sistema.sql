
-------------------------------------------------------------------------------
--pr_geracao_processo_os_sistema
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes 
--Banco de Dados   : EgisSQL
--Objetivo         : Geração de Processo de Produção a partir da Ordem Serviço
--                   Engenharia de Sistemas
--
--Data             : 08.09.2005
--Atualizado       : 09.09.2005
--------------------------------------------------------------------------------------------------
create procedure pr_geracao_processo_os_sistema
@dt_inicial datetime,
@dt_final   datetime,
@cd_usuario int

as

--select * from modulo
--select * from cliente_sistema

select 
  top 1 --p/ testar
  mh.cd_menu_historico,
  mh.cd_modulo,
  m.sg_modulo,
  mh.dt_usuario,
  tm.nm_tipo_manut_sistema,
  mh.nm_os,
  mh.nm_atividade_processo,
  mh.ds_problema_os,
  mh.nm_obs_menu_historico,
  mh.cd_cliente_sistema,
  cs.nm_cliente_sistema,
  isnull(mh.qt_hora_os,0) as qt_hora_os
 
into #OS
from 
  egisadmin.dbo.menu_historico mh
  left outer join egisadmin.dbo.modulo m           on m.cd_modulo           = mh.cd_modulo
  left outer join egisadmin.dbo.cliente_sistema cs on cs.cd_cliente_sistema = mh.cd_cliente_sistema
  left outer join egisadmin.dbo.tipo_manutencao_sistema tm on tm.cd_tipo_manut_sistema = mh.cd_tipo_manut_sistema  
where
  mh.dt_fim_desenvolvimento is null and
  isnull(mh.cd_processo,0) = 0      and
  mh.dt_usuario between @dt_inicial and @dt_final 
order by
  mh.dt_usuario


--Dados da Tabela de Processo

declare @Tabela                   varchar(50)
declare @cd_menu_historico        int
declare @cd_processo              int   
declare @cd_identifica_processo   varchar(20)
declare @ds_processo_fabrica      varchar(8000)
declare @nm_obs_prog_processo     varchar(40)
declare @nm_mp_processo_producao  varchar(50)

set @Tabela = cast(DB_NAME()+'.dbo.Processo_Producao' as varchar(50))

while exists ( select top 1 'x' from #OS )
begin

  select top 1 
    @cd_menu_historico       = cd_menu_historico,
    @cd_identifica_processo  = nm_os,
    @ds_processo_fabrica     = ds_problema_os,
    @nm_mp_processo_producao = nm_atividade_processo,
    @nm_obs_prog_processo    = nm_obs_menu_historico
  from 
    #OS

  --busca a os para geração do processo

  --Código Único    
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_processo', @codigo = @cd_processo output


  --Verifica se Existe o Processo na Tabela
  
  if not exists(select cd_processo from processo_producao where @cd_processo=cd_processo )  
  begin  
    --print ''
    INSERT INTO processo_producao
          (cd_processo,
           dt_processo,
           cd_identifica_processo,
           ds_processo_fabrica,
           qt_planejada_processo,
           cd_status_processo,       
           cd_origem_processo,        
           cd_usuario_lib_processo,
           cd_tipo_processo,
           qt_prioridade_processo,
           ic_libprog_processo,
           cd_usuario_processo,
           dt_liberacao_processo,
           ic_prog_mapa_processo,
           nm_mp_processo_producao,
           nm_obs_prog_processo,
           ic_mapa_processo,
           cd_usuario,
           dt_usuario )
    SELECT 
       @cd_processo,
       cast( cast( getdate() as int ) as datetime ),
       @cd_identifica_processo, 
       @ds_processo_fabrica,
       1,
       1,
       1,
       @cd_usuario,
       1,
       0,
       'S',
       @cd_usuario,
       getdate(),
       'S',
       @nm_mp_processo_producao,
       @nm_obs_prog_processo,
       'S',
       @cd_usuario,
       getdate() 

    --Gravação do Item na Tabela Processo_Producao_Composicao

    insert into processo_producao_composicao
      ( cd_processo,
        cd_item_processo,
        cd_seq_processo,
        cd_maquina,
        cd_operacao,
        nm_obs_item_processo,
        ic_operacao_mapa_processo,
        qt_hora_estimado_processo,
        qt_hora_real_processo,
        cd_usuario,
        dt_usuario )
    select
        @cd_processo,
        1,
        1,
        1,
        1,
        @nm_mp_processo_producao, --Atividade
        'S',
        2,
        2,
        @cd_usuario,   
        getdate()

 end



  --Libera o Código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_processo, 'D'   

  --Atualiza a Ordem de Serviço com o Número do Processo
  update
    egisadmin.dbo.menu_historico
  set
    cd_processo = @cd_processo    
  where cd_menu_historico = @cd_menu_historico

  delete from #os where cd_menu_historico = @cd_menu_historico
  
end
 
--select * from #OS
--SELECT TOP 100 * FROM PROCESSO_PRODUCAO ORDER BY DT_PROCESSO DESC,cd_processo
--select * from egisadmin.dbo.menu_historico where cd_menu_historico = 3340
