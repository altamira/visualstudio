
CREATE PROCEDURE pr_consulta_cliente_regiao
@ic_parametro               int, 
@nm_fantasia_cliente        varchar(20),
@cd_usuario int = 0

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Região por Cliente
-------------------------------------------------------------------------------
begin
  select 
    c.cd_cliente,
    c.nm_razao_social_cliente,
    c.nm_fantasia_cliente,
    c.dt_cadastro_cliente,
    c.cd_ddd+' '+cd_telefone as 'cd_fone_cliente',
    c.nm_endereco_cliente+' ,'+c.cd_numero_endereco as 'nm_endereco_cliente',
    c.nm_bairro,
    c.cd_cep,
    c.nm_divisao_area,
    d.nm_distrito,
    z.nm_zona,
    r.nm_regiao,
    cid.nm_cidade,
    est.sg_estado,
    p.nm_pais,
   (SELECT nm_vendedor 
    FROM Vendedor 
    WHERE cd_vendedor = c.cd_vendedor_interno) AS 'nm_vendedor_interno',
   (SELECT nm_vendedor 
    FROM Vendedor 
    WHERE cd_vendedor = c.cd_vendedor)         AS 'nm_vendedor'

  from Cliente c
  left outer join Distrito d
    on (d.cd_cidade=c.cd_cidade) and
       (d.cd_estado=c.cd_estado) and
       (d.cd_pais=c.cd_pais) and
       (d.cd_regiao=c.cd_regiao)
  left outer join Zona z
    on z.cd_zona=d.cd_zona
  left outer join Regiao r 
    on r.cd_regiao=c.cd_regiao
  left outer join Cidade cid 
    on cid.cd_cidade=c.cd_cidade
  left outer join Estado est
    on est.cd_estado=c.cd_estado
  left outer join Pais p
    on p.cd_pais=c.cd_pais
  where c.nm_fantasia_cliente like @nm_fantasia_cliente+'%' 
        and c.cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then c.cd_vendedor else dbo.fn_vendedor(@cd_usuario) END)
  order by c.nm_fantasia_cliente
end  
  
