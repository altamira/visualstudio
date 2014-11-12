
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_ALTERAR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_ALTERAR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_ALTERAR    Script Date: 05/01/1999 11:03:44 ******/
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

