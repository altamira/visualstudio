
--pr_meta_setor
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Soma da Média de Vendas dos Ultimos 5 meses p/ Vendedor
--Data         : 30.01.2000
--Atualizado  : 03.02.2000 
--               : 05.06.2000 - Busca de uma tabela fixa
--               : 19.07.2000 - Verificação do Cálculo
-----------------------------------------------------------------------------------
CREATE procedure pr_meta_setor
@cd_vendedor int,
@dt_inicial datetime,
@dt_final  datetime
as

select  a.cd_vendedor                      as 'setor', 
          sum(a.vl_meta_categoria)      as 'MetaSetor' 
from
  SapSql.Dbo.MetaVendedor a
where
   a.cd_vendedor = @cd_vendedor   and
   a.dt_inicial_validade_meta >=  @dt_inicial                  

Group by a.cd_vendedor

