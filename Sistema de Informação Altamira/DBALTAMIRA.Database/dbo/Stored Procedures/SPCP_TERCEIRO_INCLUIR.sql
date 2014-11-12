
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_INCLUIR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCP_TERCEIRO_INCLUIR

    @Sequencia   int,
    @OrdemServico int,
    @Descricao varchar(50),
    @NotaAltamira char(6),
    @DataAltamira smalldatetime,
    @NotaTerceiro char(6),
    @DataTerceiro smalldatetime

AS

BEGIN


    INSERT INTO CP_Terceiro (cptr_Sequencia,
                             cptr_OrdemServico,
                             cptr_Descricao,
                             cptr_NotaAltamira,
                             cptr_DataAltamira,
                             cptr_NotaTerceiro,
                             cptr_DataTerceiro)

                VALUES (@Sequencia,
                        @OrdemServico,
                        @Descricao,
                        @NotaAltamira,
                        @DataAltamira,
                        @NotaTerceiro,
                        @DataTerceiro)

END

