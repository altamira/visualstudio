
-------------------------------------------------------------------------------
--pr_romaneio_entrega_varejo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta de romaneio para entrega em varejo.
--Data             : 21/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_romaneio_entrega_varejo
@cd_nota_saida int,
@dt_inicial datetime,
@dt_final datetime,
@cd_param int

as

if @cd_param = 0
begin
	select 
		'0' as selecionado,
		ns.cd_nota_saida,
		ns.dt_nota_saida,
		ns.dt_saida_nota_saida,
		ns.dt_entrega_nota_saida,
		ns.dt_coleta_nota_saida,
		c.nm_razao_social_cliente,
		c.cd_ddd,
		c.cd_celular_cliente,
		c.nm_ponto_ref_cliente,
		c.nm_endereco_cliente,
		c.nm_bairro,	
		ci.nm_cidade,
		e.nm_estado	

	from
		nota_saida ns left outer join
		cliente c on c.cd_cliente = ns.cd_cliente left outer join
		cidade ci on ci.cd_cidade = c.cd_cidade left outer join	
		estado e on e.cd_estado = c.cd_estado 
        where
          ns.dt_nota_saida between @dt_inicial and @dt_final

	order By ns.cd_nota_saida 

end
else if @cd_param = 1
begin

	select
		'0' as selecionado,
		ns.cd_nota_saida,
		ns.dt_nota_saida,
		ns.dt_saida_nota_saida,
		ns.dt_entrega_nota_saida,
		ns.dt_coleta_nota_saida,
		c.nm_razao_social_cliente,
		c.cd_ddd,
		c.cd_celular_cliente,
		c.nm_ponto_ref_cliente,
		c.nm_endereco_cliente,
		c.nm_bairro,	
		ci.nm_cidade,
		e.nm_estado	

	from
		nota_saida ns left outer join
		cliente c on c.cd_cliente = ns.cd_cliente left outer join
		cidade ci on ci.cd_cidade = c.cd_cidade left outer join	
		estado e on e.cd_estado = c.cd_estado
    where
          IsNull(ns.cd_nota_saida,0) = 
          case 
             When isnull(@cd_nota_saida,0) = 0 then 
                IsNull(ns.cd_nota_saida,0) 
             else 
               @cd_nota_saida
             end
		and (ns.dt_nota_saida between @dt_inicial and @dt_final)

    order by ns.cd_nota_saida


end

