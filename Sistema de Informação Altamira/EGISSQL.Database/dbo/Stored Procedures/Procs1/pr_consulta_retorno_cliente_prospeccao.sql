
CREATE PROCEDURE pr_consulta_retorno_cliente_prospeccao
@dt_analise_inicial datetime,
@dt_analise_final datetime,
@nm_fantasia_cliente varchar(15)
AS

  Select 
    cph.cd_cliente_prospeccao,
    cd_sequecia_historico,
    dt_historico_lancamento,
		ds_historico_lancamento,
		(Select top 1 nm_vendedor from vendedor where cd_vendedor = cph.cd_vendedor) as nm_vendedor,
    cp.nm_fantasia_cliente,
    dt_historico_retorno,
    nm_assunto,                
    (Select top 1 nm_fantasia_contato from Cliente_Contato where cd_cliente = cph.cd_cliente_prospeccao and cd_contato = cph.cd_contato) as nm_fantasia_contato,
    cf.nm_cliente_fase as nm_cliente_fase
   from cliente_prospeccao_historico cph
        inner join cliente_prospeccao cp on cp.cd_cliente_prospeccao = cph.cd_cliente_prospeccao 
        left outer join cliente_fase cf on cf.cd_cliente_fase = cph.cd_cliente_fase
   where dt_historico_lancamento between @dt_analise_inicial and @dt_analise_final and
         cp.nm_fantasia_cliente like @nm_fantasia_cliente+'%'

