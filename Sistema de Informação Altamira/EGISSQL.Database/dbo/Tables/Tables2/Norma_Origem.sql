CREATE TABLE [dbo].[Norma_Origem] (
    [cd_norma_origem] INT          NOT NULL,
    [nm_norma_origem] VARCHAR (40) NOT NULL,
    [sg_norma_origem] CHAR (10)    NOT NULL,
    [ds_norma_origem] TEXT         NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Norma_Origem] PRIMARY KEY CLUSTERED ([cd_norma_origem] ASC) WITH (FILLFACTOR = 90)
);

