

create procedure pr_altera_recebimento_nota_entrada

@nm_fantasia_fornecedor char(10),
@cd_fornecedor int,
@cd_nota_entrada int,
@cd_parametro int,
@data datetime

as

/*
select a.cd_fornecedor, 
       c.nm_fantasia_fornecedor,
       a.cd_nota_entrada, 
       a.cd_operacao_fiscal,
       a.cd_serie_nota_fiscal,
       a.dt_receb_nota_entrada,
       b.dtrec
from nota_entrada a, sap.dbo.cadenf b, fornecedor c
where a.dt_receb_nota_entrada between '12/01/2002' and '12/31/2002' and
      a.cd_fornecedor = c.cd_fornecedor and 
      c.nm_fantasia_fornecedor = b.fan_cli and
      a.cd_nota_entrada = b.nf and
      a.dt_receb_nota_entrada <> b.dtrec
order by a.dt_receb_nota_entrada,
         a.cd_fornecedor
*/

if @cd_parametro = 1
begin
  select * from sap.dbo.cadenf where fan_cli=@nm_fantasia_fornecedor and nf=@cd_nota_entrada
  select * from nota_entrada where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada

  select * from sap.dbo.cadrine where fan_for=@nm_fantasia_fornecedor and nf=@cd_nota_entrada
  select * from nota_entrada_registro where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada
end

if @cd_parametro = 2
begin
  update nota_entrada set dt_receb_nota_entrada = @data
  where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada

  update nota_entrada_registro set dt_rem = @data
  where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada
end

if @cd_parametro = 3
begin
  delete from nota_entrada
  where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada

  delete from nota_entrada_registro
  where cd_fornecedor=@cd_fornecedor and cd_nota_entrada=@cd_nota_entrada
end


