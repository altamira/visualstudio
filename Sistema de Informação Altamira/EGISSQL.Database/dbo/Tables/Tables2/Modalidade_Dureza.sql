CREATE TABLE [dbo].[Modalidade_Dureza] (
    [cd_modalidade_dureza] INT          NOT NULL,
    [nm_modalidade_dureza] VARCHAR (40) NULL,
    [sg_modalidade_dureza] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ds_modidade_dureza]   TEXT         NULL,
    [qt_inicial_dureza]    FLOAT (53)   NULL,
    [qt_final_dureza]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Modalidade_Dureza] PRIMARY KEY CLUSTERED ([cd_modalidade_dureza] ASC) WITH (FILLFACTOR = 90)
);

