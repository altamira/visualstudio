

/****** Object:  Stored Procedure dbo.pr_emissao_nota_saida    Script Date: 13/12/2002 15:08:28 ******/

CREATE PROCEDURE pr_emissao_nota_saida
@ic_parametro int,
@cd_empresa int,
@cd_nota_saida int

as

-----------------------------------------------------------------------------
if @ic_parametro = 1      -- Atualiza o status de emitida
-----------------------------------------------------------------------------
  begin

    update
      nota_saida
    set
      ic_emitida_nota_saida = 'S'
    where
      cd_nota_saida = @cd_nota_saida

    update 
      empresa_serie_nota
    set
      cd_ultima_nota_impressa = @cd_nota_saida
    where
      cd_empresa = @cd_empresa

  end
/*
----------------------------------------------------------------------------
else if @ic_parametro = 2  -- Atualiza outras configurações (Implementar)
  begin

  end
*/

else
  return



update nota_saida set ic_emitida_nota_saida = 'N' 

select * from nota_saida


