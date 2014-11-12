create view vw_cadastro_produto_composicao_agrupamento as

select
cd_produto_pai, 
cd_agrupamento_produto,
cd_minimo_componentes, 
cd_maximo_componentes 


from
		Produto_Composicao_Agrupamento



