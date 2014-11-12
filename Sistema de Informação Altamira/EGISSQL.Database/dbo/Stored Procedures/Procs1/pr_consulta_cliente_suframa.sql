
CREATE PROCEDURE pr_consulta_cliente_suframa
@ic_parametro int,
@nm_fantasia_cliente varchar(15),
@ic_tipo_consulta char(4) = 'F'

as

begin

if @ic_parametro = 1 --Traz todos os clientes
begin
    select
      cli.cd_cliente,
      cli.nm_fantasia_cliente,
      cli.cd_suframa_cliente,
			cli.ic_habilitado_suframa,
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente,
      cli.cd_reparticao_origem,
      e.cd_estado,
      e.sg_estado,
      cid.cd_cidade,
      cid.nm_cidade

      from
      Cliente cli

      left outer join Estado e
        on cli.cd_estado = e.cd_estado

      left outer join Cidade cid
        on cli.cd_cidade = cid.cd_cidade

      where 
         ISNULL(cd_suframa_cliente,'') <> ''

end
else if @ic_parametro = 2 --Realiza filtragem 
begin
-------------------------------------------------------------------------------------------
  if @ic_tipo_consulta = 'F' --Consulta Fantasia
-------------------------------------------------------------------------------------------
  begin
    select
      cli.cd_cliente,
      cli.nm_fantasia_cliente,
      cli.cd_suframa_cliente,
			cli.ic_habilitado_suframa,
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente,
      cli.cd_reparticao_origem,
      e.cd_estado,
      e.sg_estado,
      cid.cd_cidade,
      cid.nm_cidade 

      from
      Cliente cli

      left outer join Estado e
        on cli.cd_estado = e.cd_estado

      left outer join Cidade cid
        on cli.cd_cidade = cid.cd_cidade

      where 
				cli.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and
         ISNULL(cd_suframa_cliente,'') <> ''
end

-------------------------------------------------------------------------------------------
  else if @ic_tipo_consulta = 'R'  --Consulta Razão Social
-------------------------------------------------------------------------------------------
 begin
    select
      cli.cd_cliente,
      cli.nm_fantasia_cliente,
      cli.cd_suframa_cliente,
			cli.ic_habilitado_suframa,
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente,
      cli.cd_reparticao_origem,
      e.cd_estado,
      e.sg_estado,
      cid.cd_cidade,
      cid.nm_cidade 

      from
       Cliente cli

      left outer join Estado e
        on cli.cd_estado = e.cd_estado

      left outer join Cidade cid
        on cli.cd_cidade = cid.cd_cidade

      where 
			  cli.nm_razao_social_cliente like @nm_fantasia_cliente + '%' and
       ISNULL(cd_suframa_cliente,'') <> ''
end

-------------------------------------------------------------------------------------------
  else if (@ic_tipo_consulta = 'CNPJ') or (@ic_tipo_consulta = 'CPF')  --Consulta CNPJ/CPF
-------------------------------------------------------------------------------------------
  begin
    select
      cli.cd_cliente,
      cli.nm_fantasia_cliente,
      cli.cd_suframa_cliente,
			cli.ic_habilitado_suframa,
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente,
      cli.cd_reparticao_origem,
      e.cd_estado,
      e.sg_estado,
      cid.cd_cidade,
      cid.nm_cidade

      from
      Cliente cli

      left outer join Estado e
        on cli.cd_estado = e.cd_estado

      left outer join Cidade cid
        on cli.cd_cidade = cid.cd_cidade

      where 
				cli.cd_cnpj_cliente = @nm_fantasia_cliente and
        ISNULL(cd_suframa_cliente,'') <> ''
	end
end
else
begin
    select
      cli.cd_cliente,
      cli.nm_fantasia_cliente,
      cli.cd_suframa_cliente,
			cli.ic_habilitado_suframa,
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente,
      cli.cd_reparticao_origem,
      e.cd_estado,
      e.sg_estado,
      cid.cd_cidade,
      cid.nm_cidade
      from
      Cliente cli

      left outer join Estado e
        on cli.cd_estado = e.cd_estado

      left outer join Cidade cid
        on cli.cd_cidade = cid.cd_cidade

      where 
        1=2	
end

end

