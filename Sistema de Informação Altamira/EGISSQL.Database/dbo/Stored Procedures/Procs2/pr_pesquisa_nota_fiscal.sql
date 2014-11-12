

/****** Object:  Stored Procedure dbo.pr_pesquisa_nota_fiscal    Script Date: 13/12/2002 15:08:38 ******/

CREATE  procedure pr_pesquisa_nota_fiscal
  (
    @cd_nota_saida int
  )
as
  select ns.*, c.nm_razao_social_cliente, c.cd_telefone
    from nota_saida ns, cliente c
   where nm_fantasia_nota_saida = c.nm_fantasia_cliente
     and cd_nota_saida = @cd_nota_saida



