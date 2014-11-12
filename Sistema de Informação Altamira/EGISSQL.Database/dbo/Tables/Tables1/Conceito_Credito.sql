CREATE TABLE [dbo].[Conceito_Credito] (
    [cd_conceito_credito]     INT          NOT NULL,
    [nm_conceito_credito]     VARCHAR (40) NULL,
    [sg_conceito_credito]     CHAR (10)    NULL,
    [qt_conceito_credito]     FLOAT (53)   NULL,
    [ic_pad_conceito_credito] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Conceito_Credito] PRIMARY KEY CLUSTERED ([cd_conceito_credito] ASC) WITH (FILLFACTOR = 90)
);

