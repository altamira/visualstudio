

CREATE  function fn_getlocalizacao_produto
---------------------------------------------------
--GBS - Global Business Solution	             2002
--Function: Microsoft SQL Server               2000
--Autor(es): Igor Gama
--Banco de Dados: EGISSQL
--Objetivo: Trazer a localização do produto no estoque
--Data: 11/12/2002
--Atualizado: 
---------------------------------------------------
(@codigo Integer)
RETURNS varchar(100)
AS
BEGIN
   
   If Isnull(@codigo,0) = 0
     return('')

   --Variável de retorno
   declare @local  varchar(100)
 
   declare @loc as Varchar(100)
   declare @cd_produto as Integer

   declare cProduto cursor for

   select 
      @codigo

   open cProduto
   fetch next from cProduto into @cd_produto

   while (@@FETCH_STATUS =0)
      begin
         set @loc = ''

         select 
           @loc = @loc + (Ltrim(rtrim(cast(pl.qt_posicao_localizacao as varchar)))) 
         from 
           Produto_Localizacao pl 
             left outer join 
           Produto_Grupo_Localizacao pgl 
           on pgl.cd_grupo_localizacao = pl.cd_grupo_localizacao
         where 
           (pl.cd_produto = @cd_produto) 
         order by 
           pl.cd_grupo_localizacao

         SET @local = @loc

      fetch next from cProduto into @cd_Produto
     end
     close cProduto
     deallocate cProduto


  return(@Local)

End


