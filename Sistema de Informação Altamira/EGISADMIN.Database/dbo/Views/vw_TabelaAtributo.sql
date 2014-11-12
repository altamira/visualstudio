Create view vw_TabelaAtributo as
Select 
A.cd_tabela, 
A.nm_atributo, 
N.nm_natureza_atributo, 
A.qt_tamanho_atributo, 
A.ic_numeracao_automatica, 
A.ic_atributo_chave, 
A.ic_chave_estrangeira, 
A.nm_campo_mostra_combo_box, 
A.nm_tabela_combo_box, 
A.nm_campo_chave_combo_box, 
A.nu_ordem 
From Atributo A
inner join Natureza_Atributo N
on A.cd_natureza_atributo = N.cd_natureza_atributo
