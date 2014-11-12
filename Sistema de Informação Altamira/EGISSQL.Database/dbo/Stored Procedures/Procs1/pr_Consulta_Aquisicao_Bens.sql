
CREATE PROCEDURE pr_Consulta_Aquisicao_Bens

@ic_parametro                 Int      ,
@dt_inicial                   DateTime ,
@dt_final                     DateTime ,
@cd_lancamento_padrao_inicial Int      ,
@cd_lancamento_padrao_final   int  

As
---------------------------------------------------------------------------------------------
if @ic_parametro = 1  --Seleciona po Conta Contábil
---------------------------------------------------------------------------------------------
Begin
	Select 
		b.cd_bem                      as Codigo,
	  b.cd_subitem_bem              as Sub_Item,
	  b.ds_bem                      as Descricao,
	  b.cd_item_bem                 as Item,
	  b.dt_aquisicao_bem            as Data_Aquisicao,
	  b.cd_fornecedor               as Codigo_Fornecedor,
    b.cd_nota_entrada             as Nota_Fiscal,
	  vb.vl_original_bem            as ValorCompra,
	  vb.cd_moeda                   as Moeda ,
		gb.nm_grupo_bem               as NomeGrupo,
    gb.cd_lancamento_padrao       as Conta_Contabil

	From
	  Bem b
	Left Outer Join
	  Valor_Bem vb
	On (b.cd_bem = vb.cd_bem)
	Left Outer Join
    Grupo_Bem gb
  On (b.cd_grupo_bem = gb.cd_grupo_bem)
	Where   
		b.dt_aquisicao_bem Between @dt_inicial And @dt_final 
  And
    gb.cd_lancamento_padrao between @cd_lancamento_padrao_inicial And @cd_lancamento_padrao_final
  Order By 
    gb.cd_lancamento_padrao 
End
Else
--------------------------------------------------------------------------------------------------------
if @ic_parametro = 2 --Seleciona todas as aquisições por periodo
--------------------------------------------------------------------------------------------------------
Begin
	Select 
		b.cd_bem                      as Codigo,
	  b.cd_subitem_bem              as Sub_Item,
	  b.ds_bem                      as Descricao,
	  b.cd_item_bem                 as Item,
	  b.dt_aquisicao_bem            as Data_Aquisicao,
	  b.cd_fornecedor               as Codigo_Fornecedor,
    b.cd_nota_entrada             as Nota_Fiscal, 
	  vb.vl_original_bem            as ValorCompra,
	  vb.cd_moeda                   as Moeda ,
 		gb.nm_grupo_bem               as NomeGrupo,
    gb.cd_lancamento_padrao       as Conta_Contabil

	From
	  Bem b
	Left Outer Join
	  Valor_Bem vb
	On (b.cd_bem = vb.cd_bem)
	Left Outer Join
    Grupo_Bem gb
  On (b.cd_grupo_bem = gb.cd_grupo_bem)
	Where   
		b.dt_aquisicao_bem Between @dt_inicial And @dt_final 
End
