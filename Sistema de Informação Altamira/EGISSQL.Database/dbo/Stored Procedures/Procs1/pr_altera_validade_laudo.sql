
-------------------------------------------------------------------------------
--pr_altera_validade_laudo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Rafael Santiago	
--Banco de Dados   : EgisSql
--Objetivo         : Alterar a Validade das tabelas reçlacionadas ao Laudo
--Data             : 20/05/2005
--Alteração        : 23/08/2005 - Acertado para gravar a modificacao do LOTE - Rafael M Santiago
--                 : 22.10.2005 
-- 03.12.2010 - Ajustes Diversos - Carlos Fernandes
-- 09.12.2010 - Verificação porque está gravando data em branco - Carlos Fernandes
------------------------------------------------------------------------------------------------
create procedure pr_altera_validade_laudo

@dt_fabricacao datetime,
@dt_validade   datetime,
@cd_lote       varchar(25),
@cd_produto    int,
@cd_lote_novo  varchar(25) 

as

declare @dt_hoje datetime

set @dt_hoje       = convert(datetime,left(convert(varchar,getdate(),121),10)     + ' 00:00:00',121)
set @dt_validade   = convert(datetime,left(convert(varchar,@dt_validade,121),10)  + ' 00:00:00',121)
set @dt_fabricacao = convert(datetime,left(convert(varchar,@dt_fabricacao,121),10)+ ' 00:00:00',121)

update 
  Lote_Produto
set 
  dt_inicial_lote_produto = @dt_fabricacao,
  dt_final_lote_produto   = @dt_validade,
  nm_lote_produto         = @cd_lote_novo,
  nm_ref_lote_produto     = @cd_lote_novo

where 
  nm_ref_lote_produto     = @cd_lote

  
update lote_produto_item 
set 
  dt_inicio_item_lote = @dt_fabricacao,
  dt_final_item_lote  = @dt_validade
where
  cd_lote_produto = (select
                       top 1
                       cd_lote_produto                      
                     from 
                       Lote_Produto lp with (nolock)   
                     where 
                       lp.nm_ref_lote_produto = @cd_lote) AND
   cd_produto = @cd_produto

update lote_produto_saldo
set 
  dt_inicio_item_lote = @dt_fabricacao,
  dt_final_item_lote  = @dt_validade
where
  cd_lote_produto = (select
                       top 1
                       cd_lote_produto                      
                     from 
                       Lote_Produto lp  with (nolock) 
                     where 
                       lp.nm_ref_lote_produto = @cd_lote) AND
   cd_produto = @cd_produto

