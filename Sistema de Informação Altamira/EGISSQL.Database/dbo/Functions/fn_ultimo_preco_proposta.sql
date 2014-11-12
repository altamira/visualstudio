
CREATE FUNCTION fn_ultimo_preco_proposta

(@ic_servico char(1), @cd_cliente int, @cd_prod_serv int)        	

RETURNS float

AS
BEGIN

  declare @vl_venda float

  select top 1 
    @vl_venda = isnull(ci.vl_unitario_item_consulta,0)
  from 
    Consulta_itens ci     with (nolock) 
    inner join Consulta c with (nolock) on c.cd_consulta = ci.cd_consulta
  where 
    c.cd_cliente = @cd_cliente and
    (case when @ic_servico = 'S' then ci.cd_servico
          else ci.cd_produto end ) = @cd_prod_serv
  order by 
    c.dt_consulta desc,c.cd_consulta desc

  RETURN (isnull(@vl_venda, 0) )

END


-------------------------------------------------------------------------------------------
--Example to execute function
-------------------------------------------------------------------------------------------
--Select * form  
