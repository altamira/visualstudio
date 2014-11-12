CREATE TABLE [dbo].[GenGrpPreco] (
    [GenGrpPrecoCodigo] NVARCHAR (50) NULL,
    [GenGrpPrecoFator]  FLOAT (53)    NULL,
    [GENGRPPRECOMULT]   MONEY         NULL,
    [GENGRPPRECOMULT2]  MONEY         NULL,
    [GENGRPPRECOMULT3]  MONEY         NULL,
    [idGenGrpPreco]     INT           IDENTITY (1, 1) NOT NULL
);

