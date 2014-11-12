Create view vw_Fornecedor_Endereco as
select 
ende.cd_fornecedor,
ende.cd_tipo_endereco, 
tipo.nm_tipo_Endereco,
ende.nm_endereco_fornecedor,
ende.cd_numero_endereco,
ende.nm_complemento_endereco,
ende.nm_bairro_fornecedor,
pais.nm_pais,
esta.nm_estado,
cida.nm_cidade
from Fornecedor_Endereco
ende
left join Tipo_Endereco tipo
on Ende.cd_tipo_endereco = tipo.cd_tipo_endereco
left join Cidade cida
on Ende.cd_cidade = cida.cd_cidade
left join Estado esta
on Ende.cd_estado = esta.cd_estado
left join Pais
on Ende.cd_pais = pais.cd_pais
