CREATE TABLE [dbo].[Tipo_Despesa_Processo] (
    [cd_tipo_despesa] INT          NOT NULL,
    [nm_tipo_despesa] VARCHAR (40) NULL,
    [sg_tipo_despesa] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Despesa_Processo] PRIMARY KEY CLUSTERED ([cd_tipo_despesa] ASC) WITH (FILLFACTOR = 90)
);

