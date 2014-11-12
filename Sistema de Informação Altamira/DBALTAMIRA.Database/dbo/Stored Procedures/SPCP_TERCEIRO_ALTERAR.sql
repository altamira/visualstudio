
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_ALTERAR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCP_TERCEIRO_ALTERAR

    @Sequencia   int,
    @OrdemServico int,
    @Descricao varchar(50),
    @NotaAltamira char(6),
    @DataAltamira smalldatetime,
    @NotaTerceiro char(6),
    @DataTerceiro smalldatetime


AS

BEGIN


    UPDATE CP_Terceiro
     
       SET cptr_OrdemServico = @OrdemServico,
           cptr_Descricao    = @Descricao,
           cptr_NotaAltamira = @NotaAltamira,
           cptr_DataAltamira = @DataAltamira,     
           cptr_NotaTerceiro = @NotaTerceiro,
           cptr_DataTerceiro = @DataTerceiro
     
     WHERE cptr_Sequencia = @Sequencia



END

