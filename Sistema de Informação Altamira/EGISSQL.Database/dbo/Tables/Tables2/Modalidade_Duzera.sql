CREATE TABLE [dbo].[Modalidade_Duzera] (
    [cd_modalidade_duzera] INT          NOT NULL,
    [nm_modalidade_dureza] VARCHAR (40) NULL,
    [sg_modalidade_duzera] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ds_modidade_dureza]   TEXT         NULL,
    CONSTRAINT [PK_Modalidade_Duzera] PRIMARY KEY CLUSTERED ([cd_modalidade_duzera] ASC) WITH (FILLFACTOR = 90)
);

