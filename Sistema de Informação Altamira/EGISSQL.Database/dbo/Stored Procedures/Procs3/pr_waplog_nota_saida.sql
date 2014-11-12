

/****** Object:  Stored Procedure dbo.pr_waplog_nota_saida    Script Date: 13/12/2002 15:08:45 ******/
--pr_waplog_nota_saida
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Acesso ao Wapnet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
create procedure pr_waplog_nota_saida
@ic_parametro int,
@cd_nota_saida int
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

if @ic_parametro = 1
begin

   select n.cd_nota_saida,
          n.dt_nota_saida,
          case 
             when n.cd_cliente is not null 
             then 
                  ( select c.nm_fantasia_cliente 
                         from cliente c
                         where n.cd_cliente = c.cd_cliente )
             else 
                  ( select c.nm_fantasia_fornecedor 
                         from fornecedor c
                         where n.cd_fornecedor = c.cd_fornecedor )
             end as 'Destinatario',
          n.vl_total as 'Valor'
   from
          Nota_Saida n
   where
          n.cd_nota_saida = @cd_nota_saida

end

if @ic_parametro = 2
begin

  declare @cd_tipo_atualizado    int
  declare @dt_entrega_nota_saida datetime
   
  set @cd_tipo_atualizado = 0

  select @dt_entrega_nota_saida = dt_entrega_nota_saida 
  from
    Nota_Saida
  where
    cd_nota_saida = @cd_nota_saida

  if @dt_entrega_nota_saida is null 
  begin
   
    update nota_saida
    set
      dt_entrega_nota_saida = getdate()
    where
       cd_nota_saida = @cd_nota_saida
  end
  else
    set @cd_tipo_atualizado = 1

  select @cd_tipo_atualizado as 'Status'

end



