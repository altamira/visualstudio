

/****** Object:  Stored Procedure dbo.pr_seleciona_classificacao_fiscal    Script Date: 13/12/2002 15:08:42 ******/
create procedure pr_seleciona_classificacao_fiscal
 (
   @cd_classificacao int
 )
as
  select * from classificacao_fiscal
  where @cd_classificacao in (0, cd_classificacao_fiscal )
  



