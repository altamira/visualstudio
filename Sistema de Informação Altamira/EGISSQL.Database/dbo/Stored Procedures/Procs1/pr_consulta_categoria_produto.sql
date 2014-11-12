
CREATE procedure pr_consulta_categoria_produto

--@cd_parametro int

as

select 
   cd_categoria_produto,
   cd_mascara_categoria,
   nm_categoria_produto,
   sg_categoria_produto,
   cd_ordem_categoria

from categoria_produto

where ic_fatura_categoria = 'S' and
      IsNull(cd_soma_categoria,0) = 0
      
order by sg_categoria_produto

