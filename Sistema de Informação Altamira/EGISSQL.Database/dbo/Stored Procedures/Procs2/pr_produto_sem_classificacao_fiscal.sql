
CREATE    PROCEDURE pr_produto_sem_classificacao_fiscal

--< pr_produto_sem_classificacao_fiscal >--
---------------------------------------------------
--GBS - Global Business Sollution              2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): André de Oliveira Godoi 
--Banco de Dados: EGISSQL
--Objetivo: - Listar todos os Produtos que não tenha classificação  fiscal ou que não esteja com o campo preenchido.
--Data: 23/01/2004
--Atualizado: - 
---------------------------------------------------

@nm_grupo_produto  varchar (40)

as

select gp.nm_grupo_produto, p.cd_mascara_produto, p.nm_fantasia_produto, p.nm_produto as descrição,
	  	 um.nm_unidade_medida 	       

from 
   grupo_produto gp 

  left outer join
   produto p 
  on p.cd_grupo_produto = gp.cd_grupo_produto 

  left outer join
   produto_fiscal pf 
  on pf.cd_produto = p.cd_produto 

  left outer join
   unidade_medida um 
  on um.cd_unidade_medida = p.cd_unidade_medida

where		
     gp.nm_grupo_produto like @nm_grupo_produto + '%' and
  	(pf.cd_classificacao_fiscal is null or 
     pf.cd_classificacao_fiscal ='') 

--gp.nm_grupo_produto like 'F' + '%' and

