
-------------------------------------------------------------------------------
--pr_geracao_comparativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Comparativo de Valores / Quantidade 
--                   Montagem da Tabela Auxiliar
--Data             : 06.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_comparativo
    @ic_parametro           int         = 0,
    @nm_comparativo         varchar(40) = '',
    @vl_total               float       = 0,
    @vl_comparativo         float       = 0,
    @vl_diferenca           float       = 0,
    @pc_evolucao_total      float       = 0,
    @qt_total               float       = 0,
    @qt_comparativo         float       = 0,
    @qt_diferenca           float       = 0,
    @pc_evolucao_quantidade float       = 0,
    @cd_posicao_atual       int         = 0 ,
    @cd_posicao_anterior    int         = 0,
    @nm_obs_comparativo     varchar(40) = '',
    @cd_usuario             int         = 0,
    @cd_localizacao         int         = 0

as

declare @Tabela         varchar(50)
declare @cd_comparativo int


--Alteração

if @ic_parametro = 2
begin

  --Verifica se Existe a Localização

  if exists( select cd_localizacao from comparativo where cd_localizacao = @cd_localizacao )
  begin

    --Atualização
    update
      Comparativo
    set
      vl_comparativo      = @vl_comparativo,
      vl_diferenca        = vl_total - @vl_comparativo,
      pc_evolucao_total   = 100-((@vl_comparativo/vl_total)*100),
      cd_posicao_anterior = @cd_posicao_anterior
                      
    where
      cd_localizacao = @cd_localizacao

  end
  else
    begin
      set @ic_parametro = 1
    end

end


--Inclusão

if @ic_parametro = 1
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Comparativo' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_comparativo', @codigo = @cd_comparativo output

  insert 
  Comparativo (
    cd_comparativo,
    nm_comparativo,
    vl_total,
    vl_comparativo,
    vl_diferenca,
    pc_evolucao_total,
    qt_total,
    qt_comparativo,
    qt_diferenca,
    pc_evolucao_quantidade,
    cd_posicao_atual,
    cd_posicao_anterior,
    nm_obs_comparativo,
    cd_usuario,
    dt_usuario,
    dt_comparativo,
    cd_localizacao ) 
  values
   (
    @cd_comparativo,
    @nm_comparativo,
    @vl_total,
    @vl_comparativo,
    @vl_diferenca,
    @pc_evolucao_total,
    @qt_total,
    @qt_comparativo,
    @qt_diferenca,
    @pc_evolucao_quantidade,
    @cd_posicao_atual,
    @cd_posicao_anterior,
    @nm_obs_comparativo,
    @cd_usuario,
    getdate(),
    getdate(),
    @cd_localizacao )  

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_comparativo, 'D'   

end



