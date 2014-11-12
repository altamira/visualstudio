CREATE TABLE [dbo].[CP_Terceiro] (
    [cptr_Sequencia]    INT           NOT NULL,
    [cptr_OrdemServico] INT           NOT NULL,
    [cptr_Descricao]    VARCHAR (50)  NOT NULL,
    [cptr_NotaAltamira] CHAR (6)      NOT NULL,
    [cptr_DataAltamira] SMALLDATETIME NOT NULL,
    [cptr_NotaTerceiro] CHAR (6)      NULL,
    [cptr_DataTerceiro] SMALLDATETIME NULL,
    [cptr_Lock]         ROWVERSION    NOT NULL
);

