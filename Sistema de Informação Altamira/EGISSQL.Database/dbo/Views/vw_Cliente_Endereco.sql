CREATE view vw_Cliente_Endereco as  
select   
ende.cd_cliente,  
ende.cd_tipo_endereco,   
tipo.nm_tipo_Endereco,  
ende.nm_endereco_cliente,  
ende.cd_numero_endereco,  
ende.nm_complemento_endereco,  
ende.nm_bairro_cliente,  
pais.nm_pais,  
esta.nm_estado,  
cida.nm_cidade,
c.ds_cliente_endereco,
c.nm_cidade_mercado_externo,
c.sg_estado_mercado_externo,
c.nm_pais_mercado_externo,
ende.ic_isento_insc_cliente
from Cliente_Endereco ende  
left join Tipo_Endereco tipo  
on Ende.cd_tipo_endereco = tipo.cd_tipo_endereco  
left join Cidade cida  
on Ende.cd_cidade = cida.cd_cidade  
left join Estado esta  
on Ende.cd_estado = esta.cd_estado  
left join Pais  
on Ende.cd_pais = pais.cd_pais  
left outer join Cliente c on c.cd_cliente = ende.cd_cliente

