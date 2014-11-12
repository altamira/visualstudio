

/****** Object:  Stored Procedure dbo.pr_Grade_Produtos_Geral    Script Date: 13/12/2002 15:08:10 ******/
CREATE Procedure pr_Grade_Produtos_Geral
@ic_parametro      	int
as
begin
declare @cont      int

Set @Cont=(Select Count(cd_produto) from produto_grade where cd_tipo_grade=1)
print @cont
end



