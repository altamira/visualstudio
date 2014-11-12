
create procedure pr_material_reposicao

@cd_projeto Int

as

select pr.cd_projeto as 'Projeto',
       pr.cd_interno_projeto as 'IdentificaoProjeto', 
       c.nm_fantasia_cliente as 'Cliente',
       pr.dt_entrada_projeto as 'Entrada',
       pc.nm_projeto_composicao as 'Composicao',
       pcm.cd_projeto_material as 'Item',
       p.nm_fantasia_produto 'Produto',
       pcm.nm_esp_projeto_material as 'Especificacao',
       um.sg_unidade_medida as 'Unidade',
       pcm.qt_projeto_material as 'Quantidade'
from projeto_composicao_material pcm
     left outer join projeto_composicao pc on (pc.cd_projeto = pcm.cd_projeto and
                                               pc.cd_item_projeto = pcm.cd_item_projeto)
     left outer join projeto pr on (pr.cd_projeto = pc.cd_projeto)   
     left outer join cliente c on (c.cd_cliente = pr.cd_cliente) 
     left outer join produto p on (p.cd_produto = pcm.cd_produto)    
     left outer join unidade_medida um on (um.cd_unidade_medida = pcm.cd_unidade_medida)     
Where IsNull(pcm.ic_reposicao_material,'N') = 'S' and
      IsNull(pr.cd_projeto,0) = Case
                                  When @cd_projeto <> 0
                                    Then @cd_projeto
                                  Else IsNull(pr.cd_projeto,0)
                                End 
order by pr.dt_entrada_projeto desc

--exec pr_material_reposicao 1








