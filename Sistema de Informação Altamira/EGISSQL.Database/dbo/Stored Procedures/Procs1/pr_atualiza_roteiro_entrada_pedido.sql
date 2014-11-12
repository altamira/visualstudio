
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_roteiro_entrada_pedido
-------------------------------------------------------------------------------
--pr_atualiza_roteiro_entrada_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Tabela de Entrada de Pedido de Venda
--                   Nextel
--                   Para identificar se o Vendedor já finalizou as vendas
--                   na região de vendas e se o Faturista pode iniciar 
--                   o processo de faturamento dos pedidos.
--Data             : 20.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualiza_roteiro_entrada_pedido
@cd_controle    varchar(8)    = '0',
@cd_vendedor    varchar(8)    = '',
@nm_download    varchar(20)   = '',
@nm_finalizacao varchar(20)   = ''


-- dt_roteiro_entrada
-- cd_vendedor
-- dt_download_roteiro
-- dt_fim_roteiro
-- nm_obs_roteiro
-- nm_linha_roteiro
-- cd_usuario
-- dt_usuario

as

  declare @cd_roteiro_entrada int
  declare @dt_entrada         datetime 

  set @dt_entrada = getdate()

  --set @dt_entrada = cast(convert(int,getdate(),103) as datetime)

  --select @dt_entrada = cast( CONVERT(CHAR,getdate(),101) as datetime )

--   select 
--     @dt_entrada = cast(
--                   cast( datepart(mm,@dt_entrada) as varchar(2)) + '/' +
--                   cast( datepart(dd,@dt_entrada) as varchar(2)) + '/' +
--                   cast( datepart(yyyy,@dt_entrada) as varchar(4)) as datetime )

--  select @dt_entrada

  set @cd_roteiro_entrada = cast(@cd_controle as int )


  --verifica se existe o registro na tabela de entrada de Pedidos

  if @cd_roteiro_entrada>0 and 
     not exists( select top 1 cd_roteiro_entrada from roteiro_entrada_pedido where cd_roteiro_entrada = @cd_roteiro_entrada )
  begin
    --roteiro_entrada_pedido
    insert into roteiro_entrada_pedido
     select
       @cd_roteiro_entrada,
       @dt_entrada,
       --CONVERT(CHAR,getdate(),101),
       cast(@cd_vendedor as int ),
    
       @nm_download,
       @nm_finalizacao,
       null,
       @cd_controle +' '+@cd_vendedor +' '+@nm_download + ' ' + @nm_finalizacao ,
       null,
       getdate()

-- dt_roteiro_entrada
-- cd_vendedor
-- dt_download_roteiro
-- dt_fim_roteiro
-- nm_obs_roteiro
-- nm_linha_roteiro
-- cd_usuario
-- dt_usuario

  end



